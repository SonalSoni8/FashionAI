import type { ApiStatus, Look, Product, StyleBrief } from '../../shared/looks'

/** Failure with a message written for the person using the app. */
export class ApiFailure extends Error {}

async function request(path: string, init?: RequestInit): Promise<Response> {
  let res: Response
  try {
    res = await fetch(path, init)
  } catch {
    throw new ApiFailure('The Aura server is not running. Start it with "npm run dev".')
  }
  if (res.ok) return res
  const body = (await res.json().catch(() => null)) as { error?: string } | null
  // A proxy error (server down) has no JSON body.
  throw new ApiFailure(body?.error ?? 'The Aura server is not responding. Start it with "npm run dev".')
}

export const getStatus = async () => (await (await request('/api/status')).json()) as ApiStatus

export async function createLooks(brief: StyleBrief): Promise<Look[]> {
  const res = await request('/api/looks', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(brief),
  })
  return ((await res.json()) as { looks: Look[] }).looks
}

/** The model photo for a look, as an object URL. The first call generates it; later calls are cached. */
export async function getLookImage(lookId: string): Promise<string> {
  const res = await request(`/api/looks/${lookId}/image`)
  return URL.createObjectURL(await res.blob())
}

export async function shopPiece(lookId: string, pieceIndex: number): Promise<Product[]> {
  const res = await request(`/api/looks/${lookId}/pieces/${pieceIndex}/shop`)
  return ((await res.json()) as { products: Product[] }).products
}
