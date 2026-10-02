import { rgbToHex, rgbToLab, type RGB } from './color'
import type { Depth, Undertone } from './types'

export interface SkinReading {
  skinHex: string
  ita: number
  hue: number
  depth: Depth
  depthLabel: string
  undertone: Undertone
}

export interface Point {
  x: number
  y: number
}

const deg = (rad: number) => (rad * 180) / Math.PI

/**
 * Depth comes from the Individual Typology Angle (ITA), the standard
 * colorimetric skin classification. Undertone comes from the CIELAB hue angle:
 * yellower skin reads warm, pinker skin reads cool.
 */
export function classifySkin(rgb: RGB): SkinReading {
  const lab = rgbToLab(rgb)
  const ita = deg(Math.atan2(lab.L - 50, lab.b))
  const hue = deg(Math.atan2(lab.b, lab.a))

  const depthLabel =
    ita > 55 ? 'Very fair' : ita > 41 ? 'Fair' : ita > 28 ? 'Medium' : ita > 10 ? 'Tan' : ita > -30 ? 'Brown' : 'Deep'
  const depth: Depth = ita > 41 ? 'light' : ita > 10 ? 'medium' : 'deep'
  const undertone: Undertone = hue > 62 ? 'warm' : hue < 50 ? 'cool' : 'neutral'

  return { skinHex: rgbToHex(rgb), ita, hue, depth, depthLabel, undertone }
}

const luminance = (c: RGB) => 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b

/** Mean colour of one circular patch, using only its mid-brightness pixels (no shadow, no shine). */
function patchColour(ctx: CanvasRenderingContext2D, p: Point, r: number): RGB | null {
  const { width, height } = ctx.canvas
  const x0 = Math.max(0, Math.round(p.x) - r)
  const y0 = Math.max(0, Math.round(p.y) - r)
  const w = Math.min(width - x0, r * 2 + 1)
  const h = Math.min(height - y0, r * 2 + 1)
  if (w <= 0 || h <= 0) return null

  const { data } = ctx.getImageData(x0, y0, w, h)
  const pixels: RGB[] = []
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      if ((x0 + x - p.x) ** 2 + (y0 + y - p.y) ** 2 > r * r) continue
      const i = (y * w + x) * 4
      pixels.push({ r: data[i], g: data[i + 1], b: data[i + 2] })
    }
  }
  if (pixels.length < 4) return null

  pixels.sort((p1, p2) => luminance(p1) - luminance(p2))
  return mean(pixels.slice(Math.floor(pixels.length * 0.25), Math.ceil(pixels.length * 0.85)))
}

const mean = (colours: RGB[]): RGB => ({
  r: colours.reduce((s, c) => s + c.r, 0) / colours.length,
  g: colours.reduce((s, c) => s + c.g, 0) / colours.length,
  b: colours.reduce((s, c) => s + c.b, 0) / colours.length,
})

/**
 * Average the skin colour across circular patches. A patch that is much darker
 * or lighter than the typical one (hair across the forehead, a shadow, glare)
 * is left out.
 */
export function sampleSkin(canvas: HTMLCanvasElement, points: Point[], radius: number): RGB | null {
  const ctx = canvas.getContext('2d', { willReadFrequently: true })!
  const r = Math.max(2, Math.round(radius))
  const patches = points.map((p) => patchColour(ctx, p, r)).filter((c): c is RGB => c !== null)
  if (patches.length === 0) return null

  const ranked = patches.map(luminance).sort((p, q) => p - q)
  const typical = ranked[Math.floor(ranked.length / 2)]
  return mean(patches.filter((c) => Math.abs(luminance(c) - typical) <= typical * 0.18))
}

// Face-mesh landmarks on open skin: three across the forehead and two low on each
// cheek. The cheekbones are left out because blush and natural flush sit there.
const SKIN_LANDMARKS = [151, 108, 337, 205, 187, 425, 411]
const FACE_LEFT = 234
const FACE_RIGHT = 454

export interface SelfieSample {
  rgb: RGB
  points: Point[]
  radius: number
}

/** Find the face and sample skin from it. Resolves null when no face is found. */
export async function analyseSelfie(canvas: HTMLCanvasElement): Promise<SelfieSample | null> {
  // Loaded on demand so the vision runtime is only downloaded when it is used.
  const { getFaceLandmarker } = await import('./vision')
  const landmarker = await getFaceLandmarker()
  const face = landmarker.detect(canvas).faceLandmarks[0]
  if (!face) return null

  const px = (i: number): Point => ({ x: face[i].x * canvas.width, y: face[i].y * canvas.height })
  const faceWidth = Math.abs(px(FACE_RIGHT).x - px(FACE_LEFT).x)
  const radius = faceWidth * 0.045
  const points = SKIN_LANDMARKS.map(px)
  const rgb = sampleSkin(canvas, points, radius)
  return rgb ? { rgb, points, radius } : null
}
