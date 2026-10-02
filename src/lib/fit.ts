import type { BodyRatios, BodyShape, LegLine, StyleLine } from './types'

export interface BodyWidths {
  shoulders: number
  waist: number
  hips: number
}

// Thresholds are for front-view silhouette widths, not tape-measure
// circumferences: seen from the front, shoulders are naturally wider than hips
// (roughly 1.15x in womenswear sizing data and 1.3x in menswear), so "balanced"
// sits around those values rather than around 1.
const THRESHOLDS = {
  womenswear: { triangle: 1.04, inverted: 1.25, oval: 0.97, defined: 0.8 },
  menswear: { triangle: 1.2, inverted: 1.42, oval: 1.02, defined: 0.88 },
}

export function classifyShape({ shoulders, waist, hips }: BodyWidths, line: StyleLine): BodyShape {
  const t = THRESHOLDS[line]
  const shoulderToHip = shoulders / hips
  const waistToHip = waist / hips
  if (waistToHip >= t.oval) return 'oval'
  if (shoulderToHip < t.triangle) return 'triangle'
  if (shoulderToHip > t.inverted) return 'inverted'
  return waistToHip <= t.defined ? 'hourglass' : 'rectangle'
}

/** Shoulder-to-hip vs hip-to-ankle length. Around 1.6 is typical. */
export function classifyLegLine(legToTorso: number): LegLine {
  if (legToTorso > 1.74) return 'long'
  if (legToTorso < 1.48) return 'short'
  return 'balanced'
}

export type HeightBand = 'petite' | 'average' | 'tall'

export function heightBand(cm: number, line: StyleLine): HeightBand {
  const [low, high] = line === 'menswear' ? [170, 185] : [160, 173]
  return cm < low ? 'petite' : cm > high ? 'tall' : 'average'
}

export function toRatios(w: BodyWidths, legToTorso: number): BodyRatios {
  return { shoulderToHip: w.shoulders / w.hips, waistToHip: w.waist / w.hips, legToTorso }
}

export function formatHeight(cm: number): string {
  const inches = Math.round(cm / 2.54)
  return `${cm} cm · ${Math.floor(inches / 12)}′${inches % 12}″`
}
