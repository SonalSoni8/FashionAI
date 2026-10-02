# Aura — Personal Atelier

A fashion web app that tells you which colours and cuts suit you, and keeps your wardrobe in one place.

- **Colour** — upload or take a selfie; Aura reads your skin depth and undertone and gives you a palette: colours to wear near your face, neutrals, metals, and shades to avoid.
- **Fit** — upload or take a full-length photo and enter your height; Aura measures your proportions and names your body shape. An AI stylist then writes three complete outfits for that shape, height and palette, shows each one on an AI-generated model with the same body type, and lists real products to buy for every piece.
- **Wardrobe** — photograph your clothes, shoes, bags and accessories. Each piece is filed by category and colour, tagged against your palette, searchable, and used to suggest outfits.

## Run it

```bash
npm install          # also copies the vision runtime and downloads two models (~13 MB)
cp .env.example .env # then add your API keys (see below)
npm run dev          # web app on http://localhost:5173, API server on :8787
```

Other commands: `npm run build`, `npm start` (serves the built app and the API from one server), `npm test`.
If the model download failed during install (offline), run `npm run setup:vision` later.

### API keys

The AI outfits need three services. Put the keys in `.env`; each feature switches on when its key is present, and the app says which one is missing.

| Key | Used for | Get it at |
| --- | --- | --- |
| `ANTHROPIC_API_KEY` | Claude writes the outfit suggestions | console.anthropic.com |
| `GEMINI_API_KEY` | Gemini draws each outfit on a model | aistudio.google.com |
| `SERPAPI_KEY` | Google Shopping products for each piece | serpapi.com |

All three are paid services. To keep the cost down, outfits are only generated when the user presses the button, each model image is generated once and then served from `server/.cache`, shop searches are cached for 24 hours, and the server limits how many requests one address can make per hour.

## How it works

Photo analysis runs in the browser; no photo is uploaded anywhere. The AI outfits go through a small server (`server/`) that holds the keys.

| Step | Method | Code |
| --- | --- | --- |
| Skin tone | MediaPipe face landmarks locate the forehead and lower cheeks; the skin colour there is averaged and converted to CIELAB. Depth comes from the Individual Typology Angle (ITA), undertone from the hue angle. | `src/lib/skin.ts` |
| Palette | Undertone (warm / neutral / cool) × depth (light / medium / deep) picks one of nine seasonal palettes. | `src/data/palettes.ts` |
| Body shape | MediaPipe pose landmarks plus person segmentation give the outline; its width is read at the shoulders, waist and hips and the ratios are classified. | `src/lib/body.ts`, `src/lib/fit.ts` |
| AI outfits | Claude receives the shape, its fit rules, height, palette and shopping country, and returns three outfits as structured data. | `server/stylist.ts` |
| Model photo | The server writes an image prompt from the body shape, skin depth, height and the outfit's pieces, and Gemini renders it. | `server/modelImage.ts` |
| Shop | Each piece carries a search phrase written by Claude; SerpApi runs it on Google Shopping for the user's country. | `server/shop.ts` |
| Garment colour | Backdrop colours (those common on the photo's border) are ignored and the most common remaining colour wins. | `src/lib/garment.ts` |
| Wardrobe outfits | A dress, or top + bottom, then shoes and extras, preferring palette colours near the face. | `src/lib/styling.ts` |

## Things to know

- **What leaves the device.** Only the body shape, height, leg-to-torso class, skin depth, palette and country are sent to the server and on to the AI services. Photos are never sent. The browser sends fixed choices only, never free text, and the image prompt and shop query are built on the server.
- **Accounts are local to the browser.** Users, profiles and wardrobe items are stored in IndexedDB on the device (`src/lib/db.ts`); passwords are salted and hashed with PBKDF2. An account does not follow you to another device and there is no password reset. Because of this the API server cannot tell users apart, so it only rate-limits by address. Before putting it on the public internet, add real accounts (Supabase or Firebase, for example) and require a signed-in user on the `/api` routes.
- **Results are estimates.** Lighting changes how skin photographs, and clothing and camera angle change an outline. Both result pages let the user correct the reading. The shape thresholds in `src/lib/fit.ts` are starting values and should be tuned against real photos.
- **Height is typed in**, because a photo has no scale.
- **Product links** open the Google Shopping page for the product, which lists the stores selling it.
- The full-length photo is never stored; the selfie is kept as a small thumbnail on the device.
