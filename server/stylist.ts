import Anthropic from '@anthropic-ai/sdk'
import { betaZodOutputFormat } from '@anthropic-ai/sdk/helpers/beta/zod'
import { z } from 'zod'
import { PALETTES } from '../src/data/palettes'
import { HEIGHT_TIPS, LEG_TIPS, SHAPES } from '../src/data/shapes'
import { heightBand } from '../src/lib/fit'
import { COUNTRIES, PIECE_CATEGORIES, type Look, type StyleBrief } from '../shared/looks'
import { HttpError, missingKey } from './errors'

const MODEL = process.env.ANTHROPIC_MODEL || 'claude-opus-5-5'

const Looks = z.object({
  looks: z.array(
    z.object({
      title: z.string(),
      occasion: z.string(),
      why: z.string(),
      pieces: z.array(
        z.object({
          name: z.string(),
          category: z.enum(PIECE_CATEGORIES),
          colour: z.string(),
          colourHex: z.string(),
          shopQuery: z.string(),
        }),
      ),
    }),
  ),
})

const SYSTEM = `You are the stylist behind Aura, an app that helps people dress for their own body and colouring. The person you are styling has had their body shape and skin tone analysed. Put together three complete outfits they could realistically buy and wear.

Each outfit reaches the person in three ways, so each field has a job:
- "name" and "colour" are handed to an image model that draws a fashion model wearing the outfit, working from those words alone. Name every piece concretely enough to be drawn: cut, length, neckline or fabric. "High-waisted wide-leg linen trousers" works; "nice trousers" does not.
- "shopQuery" is typed into a shopping search engine exactly as written. Write it the way a shopper would: colour, then "women" or "men", then the garment and its one key detail. Four to eight words, no brand names, no punctuation.
- "why" is read by the person. In one or two plain sentences, addressed to "you", say how this outfit works for their shape and proportions.
- "title" is a short name for the outfit (two to four words) and "occasion" is where it would be worn (one to three words).

How to choose:
- Follow the fit guidance supplied for their shape, and suggest nothing from its "skip" list.
- When a colour palette is supplied, pieces worn near the face (tops, dresses, jackets, scarves) take a colour from "best colours". Trousers, skirts, coats, shoes and bags take a neutral or a best colour. Keep the "avoid" colours away from the face. When you use a palette colour, copy its name and hex exactly.
- When no palette is supplied, choose versatile colours and give a sensible hex for each.
- Make the three outfits for three different occasions: everyday, work or smart, and evening or a special occasion.
- Each outfit has three to five pieces: a dress, or a top with a bottom; then shoes; then optionally one outer layer and one bag or accessory.
- Respect the height and leg-length guidance when choosing lengths, rises and hemlines.
- Suggest clothes that are commonly sold in the shopping country given. Regional styles are welcome where they suit the shape.
- "colourHex" is a six-digit hex code starting with #.
- Use British spelling.`

function describe(brief: StyleBrief): string {
  const guide = SHAPES[brief.line][brief.shape]
  const palette = PALETTES.find((p) => p.id === brief.paletteId)
  const country = COUNTRIES.find((c) => c.code === brief.country)!.label
  const list = (shades: { name: string; hex: string }[]) => shades.map((s) => `${s.name} ${s.hex}`).join(', ')

  const lines = [
    `Styling line: ${brief.line}`,
    `Body shape: ${guide.label}. ${guide.summary}`,
    `Styling goal: ${guide.goal}`,
    `Tops that work: ${guide.tops.join('; ')}`,
    `Bottoms that work: ${guide.bottoms.join('; ')}`,
    `Layers that work: ${guide.layers.join('; ')}`,
    `Skip: ${guide.skip.join('; ')}`,
  ]
  if (brief.heightCm) {
    const band = HEIGHT_TIPS[heightBand(brief.heightCm, brief.line)]
    lines.push(`Height: ${brief.heightCm} cm (${band.label.toLowerCase()}). ${band.tips.join(' ')}`)
  }
  if (brief.legLine) lines.push(`Proportions: ${LEG_TIPS[brief.legLine].label}. ${LEG_TIPS[brief.legLine].tip}`)
  if (palette) {
    lines.push(
      `Colour palette: ${palette.season}. ${palette.about}`,
      `Best colours: ${list(palette.best)}`,
      `Neutrals: ${list(palette.neutrals)}`,
      `Avoid near the face: ${list(palette.avoid)}`,
    )
  } else {
    lines.push('Colour palette: not analysed yet.')
  }
  lines.push(`Shopping country: ${country}`)
  return lines.join('\n')
}

let client: Anthropic | undefined

/** Ask Claude for three outfits styled to the brief. */
export async function styleLooks(brief: StyleBrief): Promise<Omit<Look, 'id'>[]> {
  if (!process.env.ANTHROPIC_API_KEY && !process.env.ANTHROPIC_AUTH_TOKEN) {
    throw missingKey('ANTHROPIC_API_KEY', 'The AI stylist')
  }
  client ??= new Anthropic()

  try {
    const response = await client.beta.messages.parse({
      model: MODEL,
      max_tokens: 16000,
      // If a safety classifier declines the request, let the API retry it on its recommended fallback model.
      betas: ['server-side-fallback-2026-07-01'],
      fallbacks: 'default',
      output_config: { effort: 'medium', format: betaZodOutputFormat(Looks) },
      system: SYSTEM,
      messages: [{ role: 'user', content: describe(brief) }],
    })

    if (response.stop_reason === 'refusal') throw new HttpError(502, 'The AI stylist declined this request.')
    const looks = response.parsed_output?.looks.filter((look) => look.pieces.length > 0)
    if (!looks?.length) throw new HttpError(502, 'The AI stylist returned no outfits. Please try again.')

    return looks.slice(0, 3).map((look) => ({
      ...look,
      pieces: look.pieces.slice(0, 5).map((piece) => ({
        ...piece,
        colourHex: /^#[0-9a-f]{6}$/i.test(piece.colourHex) ? piece.colourHex : '#8a7a6a',
      })),
    }))
  } catch (err) {
    if (err instanceof HttpError) throw err
    if (err instanceof Anthropic.AuthenticationError) {
      throw new HttpError(502, 'The Anthropic API key was rejected. Check ANTHROPIC_API_KEY in the .env file.')
    }
    if (err instanceof Anthropic.RateLimitError) {
      throw new HttpError(429, 'The AI stylist is busy right now. Please try again in a minute.')
    }
    if (err instanceof Anthropic.APIError) {
      console.error('[stylist]', err.status, err.message)
      throw new HttpError(502, 'The AI stylist could not be reached. Please try again.')
    }
    throw err
  }
}
