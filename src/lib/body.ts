import type { BodyWidths } from './fit'

export interface MeasureLine {
  label: string
  /** All normalised 0..1 against the photo. */
  y: number
  x1: number
  x2: number
}

export interface BodyMeasurement {
  widths: BodyWidths
  legToTorso: number
  lines: MeasureLine[]
}

export class BodyNotFoundError extends Error {}

// Pose landmark indices.
const SHOULDERS = [11, 12]
const ELBOWS = [13, 14]
const WRISTS = [15, 16]
const HIPS = [23, 24]
const ANKLES = [27, 28]

interface P {
  x: number
  y: number
}

/** The pose model stops at the wrist; carry the forearm on to cover the hand. */
const handTip = (elbow: P, wrist: P): P => ({
  x: wrist.x + (wrist.x - elbow.x) * 0.8,
  y: wrist.y + (wrist.y - elbow.y) * 0.8,
})

/** x of the shoulder-elbow-wrist-hand polyline at row y, if the arm passes through that row. */
function armXAt(arm: P[], y: number): number | null {
  for (let i = 0; i < arm.length - 1; i++) {
    const p = arm[i]
    const q = arm[i + 1]
    const top = Math.min(p.y, q.y)
    const bottom = Math.max(p.y, q.y)
    if (y < top || y > bottom || bottom - top < 1) continue
    return p.x + ((q.x - p.x) * (y - p.y)) / (q.y - p.y)
  }
  return null
}

/**
 * Measure the front silhouette: the person is segmented from the background
 * and the outline's width is read at the shoulder line, the narrowest point of
 * the torso (waist) and the widest point around the hip joints.
 */
export async function measureBody(canvas: HTMLCanvasElement): Promise<BodyMeasurement> {
  const { getPoseLandmarker } = await import('./vision')
  const landmarker = await getPoseLandmarker()
  const result = landmarker.detect(canvas)
  const marks = result.landmarks[0]
  const mask = result.segmentationMasks?.[0]
  if (!marks || !mask) {
    throw new BodyNotFoundError('No person was found in that photo. Try a clear, full-length photo.')
  }

  const W = mask.width
  const H = mask.height
  const data = mask.getAsFloat32Array().slice()
  result.segmentationMasks?.forEach((m) => m.close())

  const needed = [...SHOULDERS, ...HIPS, ...ANKLES]
  if (needed.some((i) => (marks[i].visibility ?? 0) < 0.5 || marks[i].y < 0 || marks[i].y > 1)) {
    throw new BodyNotFoundError(
      'Your whole body needs to be in the frame, from shoulders to ankles. Step back from the camera and try again.',
    )
  }

  const px = (i: number): P => ({ x: marks[i].x * W, y: marks[i].y * H })
  // Sort each pair by where it sits in the image, so index 0 is always image-left.
  const pair = (ids: number[]) => ids.map(px)
  const shoulders = pair(SHOULDERS)
  const flip = shoulders[0].x > shoulders[1].x
  const order = <T,>(v: T[]) => (flip ? [v[1], v[0]] : v)
  const [sL, sR] = order(shoulders)
  const [eL, eR] = order(pair(ELBOWS))
  const [wL, wR] = order(pair(WRISTS))
  const [hL, hR] = order(pair(HIPS))
  const ankles = pair(ANKLES)
  const armL = [sL, eL, wL, handTip(eL, wL)]
  const armR = [sR, eR, wR, handTip(eR, wR)]

  const shoulderY = (sL.y + sR.y) / 2
  const hipY = (hL.y + hR.y) / 2
  const ankleY = (ankles[0].y + ankles[1].y) / 2
  const torso = hipY - shoulderY
  const jointSpan = sR.x - sL.x
  if (torso < H * 0.08 || jointSpan < W * 0.03) {
    throw new BodyNotFoundError('Stand facing the camera, upright, so your shoulders and hips are clearly visible.')
  }

  const on = (x: number, y: number) => x >= 0 && x < W && y >= 0 && y < H && data[y * W + x] > 0.5
  const centreX = (y: number) => {
    const t = (y - shoulderY) / torso
    return (sL.x + sR.x) / 2 + t * ((hL.x + hR.x) / 2 - (sL.x + sR.x) / 2)
  }
  // An arm resting against the body merges with the torso in the mask, so stop
  // the scan just inside the arm's own line.
  const armPad = jointSpan * 0.12

  function extent(y: number, startL: number, startR: number, clampArms: boolean) {
    const row = Math.round(y)
    let l = Math.round(startL)
    let r = Math.round(startR)
    while (on(l - 1, row)) l--
    while (on(r + 1, row)) r++
    if (clampArms) {
      const aL = armXAt(armL, y)
      const aR = armXAt(armR, y)
      // Never cut inside the hip joints: an arm crossing in front of the body is not its edge.
      if (aL !== null && aL + armPad < startL) l = Math.max(l, Math.round(Math.min(aL + armPad, hL.x)))
      if (aR !== null && aR - armPad > startR) r = Math.min(r, Math.round(Math.max(aR - armPad, hR.x)))
    }
    return { y, l, r, width: r - l }
  }

  const shoulderLine = extent(shoulderY, centreX(shoulderY), centreX(shoulderY), false)

  let waistLine = extent(shoulderY + torso * 0.6, centreX(shoulderY + torso * 0.6), centreX(shoulderY + torso * 0.6), true)
  for (let y = shoulderY + torso * 0.4; y <= shoulderY + torso * 0.85; y += 1) {
    const e = extent(y, centreX(y), centreX(y), true)
    if (e.width > 0 && e.width < waistLine.width) waistLine = e
  }

  let hipLine = extent(hipY, hL.x, hR.x, true)
  for (let y = hipY - torso * 0.15; y <= hipY + torso * 0.15; y += 1) {
    const e = extent(y, hL.x, hR.x, true)
    if (e.width > hipLine.width) hipLine = e
  }

  if (shoulderLine.width < 4 || waistLine.width < 4 || hipLine.width < 4) {
    throw new BodyNotFoundError('The outline was not clear enough to measure. Try a plain background and even light.')
  }

  // No real front view has a waist under ~60% of the hips or shoulders narrower
  // than ~3/4 of them, so readings like that mean something covered the outline.
  const waistToHip = waistLine.width / hipLine.width
  const shoulderToHip = shoulderLine.width / hipLine.width
  if (waistToHip < 0.6 || waistToHip > 1.35 || shoulderToHip < 0.75 || shoulderToHip > 1.9) {
    throw new BodyNotFoundError(
      'Your outline could not be measured reliably. Stand with your arms relaxed and slightly away from your sides, hands out of your pockets, and put down any bag.',
    )
  }

  const line = (label: string, e: { y: number; l: number; r: number }): MeasureLine => ({
    label,
    y: e.y / H,
    x1: e.l / W,
    x2: e.r / W,
  })

  return {
    widths: { shoulders: shoulderLine.width, waist: waistLine.width, hips: hipLine.width },
    legToTorso: (ankleY - hipY) / torso,
    lines: [line('Shoulders', shoulderLine), line('Waist', waistLine), line('Hips', hipLine)],
  }
}
