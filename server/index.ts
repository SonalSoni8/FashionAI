import { createHash, randomUUID } from 'node:crypto'
import { existsSync } from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import express, { type NextFunction, type Request, type Response } from 'express'
import { z } from 'zod'
import { COUNTRIES, SKIN_DEPTHS, type ApiStatus, type Look, type Product, type StyleBrief } from '../shared/looks'
import { once, readCached, readJson, writeCached, writeJson } from './cache'
import { HttpError } from './errors'

// Keys live in .env, which is optional so the app still starts without it.
try {
  process.loadEnvFile()
} catch {
  /* no .env file */
}

// Imported after the env is loaded, because they read it when first evaluated.
const { styleLooks } = await import('./stylist')
const { renderLook } = await import('./modelImage')
const { searchShop } = await import('./shop')

const Brief = z.object({
  shape: z.enum(['hourglass', 'rectangle', 'triangle', 'inverted', 'oval']),
  line: z.enum(['womenswear', 'menswear']),
  heightCm: z.number().int().min(120).max(230).optional(),
  legLine: z.enum(['long', 'balanced', 'short']).optional(),
  paletteId: z
    .templateLiteral([z.enum(['warm', 'neutral', 'cool']), '-', z.enum(['light', 'medium', 'deep'])])
    .optional(),
  skinDepth: z.enum(SKIN_DEPTHS).optional(),
  country: z.enum(COUNTRIES.map((c) => c.code)),
}) satisfies z.ZodType<StyleBrief>

interface StoredLook {
  brief: StyleBrief
  look: Look
}

const SHOP_TTL_MS = 24 * 60 * 60 * 1000

// Each call below costs money, so cap how often one address can make it per hour.
const LIMITS = { looks: 12, image: 40, shop: 80 }
const hits = new Map<string, number[]>()

function limit(kind: keyof typeof LIMITS) {
  return (req: Request, _res: Response, next: NextFunction) => {
    const key = `${kind}:${req.ip}`
    const recent = (hits.get(key) ?? []).filter((t) => t > Date.now() - 60 * 60 * 1000)
    if (recent.length >= LIMITS[kind]) return next(new HttpError(429, 'You have made a lot of requests. Please try again later.'))
    hits.set(key, [...recent, Date.now()])
    next()
  }
}

async function storedLook(id: string): Promise<StoredLook> {
  const found = z.uuid().safeParse(id).success ? await readJson<StoredLook>(`looks/${id}.json`) : null
  if (!found) throw new HttpError(404, 'That outfit has expired. Generate your looks again.')
  return found
}

const app = express()
app.use(express.json({ limit: '10kb' }))

app.get('/api/status', (_req, res) => {
  const status: ApiStatus = {
    stylist: Boolean(process.env.ANTHROPIC_API_KEY || process.env.ANTHROPIC_AUTH_TOKEN),
    images: Boolean(process.env.GEMINI_API_KEY),
    shop: Boolean(process.env.SERPAPI_KEY),
  }
  res.json(status)
})

// Three outfits styled by Claude for this shape, height and palette.
app.post('/api/looks', limit('looks'), async (req, res) => {
  const parsed = Brief.safeParse(req.body)
  if (!parsed.success) throw new HttpError(400, 'That styling request was not valid.')
  const brief = parsed.data

  const looks: Look[] = (await styleLooks(brief)).map((look) => ({ ...look, id: randomUUID() }))
  await Promise.all(looks.map((look) => writeJson(`looks/${look.id}.json`, { brief, look } satisfies StoredLook)))
  res.json({ looks })
})

// The outfit worn by an AI model with the user's body shape. Generated once, then served from disk.
app.get('/api/looks/:id/image', limit('image'), async (req, res) => {
  const { brief, look } = await storedLook(String(req.params.id))
  const name = `images/${look.id}.jpg`
  const image = await once(name, async () => {
    const cached = await readCached(name)
    if (cached) return cached
    const fresh = await renderLook(brief, look)
    await writeCached(name, fresh)
    return fresh
  })
  res.set('Cache-Control', 'private, max-age=31536000, immutable').type('image/jpeg').send(image)
})

// Real products matching one piece of an outfit.
app.get('/api/looks/:id/pieces/:index/shop', limit('shop'), async (req, res) => {
  const { brief, look } = await storedLook(String(req.params.id))
  const piece = look.pieces[Number(req.params.index)]
  if (!piece) throw new HttpError(404, 'That piece was not found.')

  const digest = createHash('sha256').update(`${brief.country}|${piece.shopQuery.toLowerCase()}`).digest('hex')
  const name = `shop/${digest}.json`
  const products = await once(name, async () => {
    const cached = await readJson<{ at: number; products: Product[] }>(name)
    if (cached && cached.at > Date.now() - SHOP_TTL_MS) return cached.products
    const fresh = await searchShop(piece.shopQuery, brief.country)
    await writeJson(name, { at: Date.now(), products: fresh })
    return fresh
  })
  res.json({ products })
})

app.use('/api', (_req, _res, next) => next(new HttpError(404, 'Not found.')))

// In production the same server also serves the built app.
const dist = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', 'dist')
if (existsSync(dist)) {
  app.use(express.static(dist))
  app.get('/{*path}', (_req, res) => res.sendFile(path.join(dist, 'index.html')))
}

app.use((err: unknown, _req: Request, res: Response, _next: NextFunction) => {
  if (err instanceof HttpError) return void res.status(err.status).json({ error: err.message })
  console.error(err)
  res.status(500).json({ error: 'Something went wrong on the server. Please try again.' })
})

const port = Number(process.env.PORT) || 8787
app.listen(port, () => console.log(`[api] listening on http://localhost:${port}`))
