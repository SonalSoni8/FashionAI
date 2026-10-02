import type { CountryCode, Look } from '../../shared/looks'

export type Undertone = 'warm' | 'neutral' | 'cool'
export type Depth = 'light' | 'medium' | 'deep'
export type BodyShape = 'hourglass' | 'rectangle' | 'triangle' | 'inverted' | 'oval'
export type StyleLine = 'womenswear' | 'menswear'
export type LegLine = 'long' | 'balanced' | 'short'

export interface User {
  id: string
  name: string
  email: string
  salt: string
  hash: string
  createdAt: number
}

export interface ColorProfile {
  skinHex: string
  /** Individual Typology Angle, the dermatology measure of skin depth. */
  ita: number
  /** CIELAB hue angle of the sampled skin, in degrees. */
  hue: number
  depth: Depth
  depthLabel: string
  undertone: Undertone
  /** Small data-URL thumbnail of the selfie, kept only on this device. */
  selfieThumb?: string
  analysedAt: number
}

export interface BodyRatios {
  shoulderToHip: number
  waistToHip: number
  legToTorso: number
}

export interface FitProfile {
  shape: BodyShape
  line: StyleLine
  heightCm?: number
  ratios?: BodyRatios
  legLine?: LegLine
  source: 'photo' | 'manual'
  analysedAt: number
}

/** AI-styled outfits, kept with the profile so they are not regenerated on every visit. */
export interface SavedLooks {
  /** Fingerprint of the shape, height and palette they were styled for. */
  basis: string
  generatedAt: number
  items: Look[]
}

export interface Profile {
  userId: string
  color?: ColorProfile
  fit?: FitProfile
  /** Where the user shops; decides which stores products come from. */
  country?: CountryCode
  looks?: SavedLooks
}

export type Category =
  | 'tops'
  | 'bottoms'
  | 'dresses'
  | 'outerwear'
  | 'shoes'
  | 'bags'
  | 'jewellery'
  | 'accessories'

export interface WardrobeItem {
  id: string
  userId: string
  name: string
  category: Category
  colorHex: string
  /** JPEG data URL, resized on upload. */
  image: string
  favorite: boolean
  notes: string
  createdAt: number
}
