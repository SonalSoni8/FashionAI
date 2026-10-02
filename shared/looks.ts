// Types shared by the browser app and the API server.
import type { BodyShape, Depth, LegLine, StyleLine, Undertone } from '../src/lib/types'

export const COUNTRIES = [
  { code: 'in', label: 'India' },
  { code: 'us', label: 'United States' },
  { code: 'gb', label: 'United Kingdom' },
  { code: 'ca', label: 'Canada' },
  { code: 'au', label: 'Australia' },
  { code: 'ae', label: 'United Arab Emirates' },
  { code: 'sg', label: 'Singapore' },
  { code: 'de', label: 'Germany' },
  { code: 'fr', label: 'France' },
] as const

export type CountryCode = (typeof COUNTRIES)[number]['code']

export const SKIN_DEPTHS = ['Very fair', 'Fair', 'Medium', 'Tan', 'Brown', 'Deep'] as const
export type SkinDepth = (typeof SKIN_DEPTHS)[number]

export const PIECE_CATEGORIES = ['top', 'bottom', 'dress', 'outerwear', 'shoes', 'bag', 'accessory'] as const
export type PieceCategory = (typeof PIECE_CATEGORIES)[number]

/**
 * Everything the server is told about a user in order to style them. It is
 * deliberately made of fixed choices and numbers only: no photos and no free
 * text ever leave the device.
 */
export interface StyleBrief {
  shape: BodyShape
  line: StyleLine
  heightCm?: number
  legLine?: LegLine
  paletteId?: `${Undertone}-${Depth}`
  skinDepth?: SkinDepth
  country: CountryCode
}

export interface LookPiece {
  name: string
  category: PieceCategory
  colour: string
  colourHex: string
  shopQuery: string
}

export interface Look {
  id: string
  title: string
  occasion: string
  why: string
  pieces: LookPiece[]
}

export interface Product {
  title: string
  price: string
  source: string
  thumbnail: string
  link: string
  rating?: number
  reviews?: number
}

/** Which of the three outside services the server has a key for. */
export interface ApiStatus {
  stylist: boolean
  images: boolean
  shop: boolean
}
