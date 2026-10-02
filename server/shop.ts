import type { CountryCode, Product } from '../shared/looks'
import { HttpError, missingKey } from './errors'

const BASE = process.env.SERPAPI_BASE_URL || 'https://serpapi.com'

// The fields of a Google Shopping result that the app uses.
interface ShoppingResult {
  title?: string
  price?: string
  source?: string
  thumbnail?: string
  product_link?: string
  link?: string
  rating?: number
  reviews?: number
}

/** Search Google Shopping (through SerpApi) for real products matching the query. */
export async function searchShop(query: string, country: CountryCode): Promise<Product[]> {
  const key = process.env.SERPAPI_KEY
  if (!key) throw missingKey('SERPAPI_KEY', 'Shopping')

  const url = new URL('/search.json', BASE)
  url.search = new URLSearchParams({ engine: 'google_shopping', q: query, gl: country, hl: 'en', api_key: key }).toString()

  let res: Response
  try {
    res = await fetch(url, { signal: AbortSignal.timeout(30_000) })
  } catch {
    throw new HttpError(502, 'The shop search could not be reached. Please try again.')
  }
  const body = (await res.json().catch(() => ({}))) as { error?: string; shopping_results?: ShoppingResult[] }

  if (res.status === 401) throw new HttpError(502, 'The SerpApi key was rejected. Check SERPAPI_KEY in the .env file.')
  if (res.status === 429) throw new HttpError(429, 'The monthly shop search allowance has been used up.')
  if (!res.ok) {
    // SerpApi reports "no results" as an error string rather than an empty list.
    if (body.error?.includes("hasn't returned any results")) return []
    console.error('[shop]', res.status, body.error)
    throw new HttpError(502, 'The shop search failed. Please try again.')
  }

  return (body.shopping_results ?? [])
    .filter((r) => r.title && r.thumbnail && (r.product_link || r.link))
    .slice(0, 6)
    .map((r) => ({
      title: r.title!,
      price: r.price ?? '',
      source: r.source ?? '',
      thumbnail: r.thumbnail!,
      link: (r.link || r.product_link)!,
      rating: r.rating,
      reviews: r.reviews,
    }))
}
