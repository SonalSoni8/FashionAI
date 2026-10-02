import { rgbToHex } from './color'
import { resizeCanvas } from './image'
import type { Category } from './types'

/** Coarse colour bin: 3 bits per channel. */
const binOf = (r: number, g: number, b: number) => ((r >> 5) << 6) | ((g >> 5) << 3) | (b >> 5)

/**
 * Main colour of a garment photo. Colours that are common along the image
 * border are treated as backdrop and ignored; the remaining pixels vote in
 * coarse colour bins and the winning bin is averaged.
 */
export function dominantColor(source: HTMLCanvasElement): string {
  const small = resizeCanvas(source, 72)
  const { width: w, height: h } = small
  const { data } = small.getContext('2d')!.getImageData(0, 0, w, h)
  const at = (x: number, y: number) => {
    const i = (y * w + x) * 4
    return [data[i], data[i + 1], data[i + 2]] as const
  }

  const border = new Map<number, number>()
  const seen = (x: number, y: number) => {
    const k = binOf(...at(x, y))
    border.set(k, (border.get(k) ?? 0) + 1)
  }
  for (let x = 0; x < w; x++) (seen(x, 0), seen(x, h - 1))
  for (let y = 0; y < h; y++) (seen(0, y), seen(w - 1, y))
  const borderSize = 2 * (w + h)
  const backdrop = new Set([...border].filter(([, n]) => n >= borderSize * 0.02).map(([k]) => k))

  const vote = (skipBackdrop: boolean) => {
    const bins = new Map<number, [number, number, number, number]>()
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const [r, g, b] = at(x, y)
        const key = binOf(r, g, b)
        if (skipBackdrop && backdrop.has(key)) continue
        const bin = bins.get(key) ?? [0, 0, 0, 0]
        bin[0] += r
        bin[1] += g
        bin[2] += b
        bin[3] += 1
        bins.set(key, bin)
      }
    }
    return bins
  }

  let bins = vote(true)
  const counted = [...bins.values()].reduce((sum, bin) => sum + bin[3], 0)
  // The garment fills the frame or matches the backdrop (white shirt on a white wall).
  if (counted < w * h * 0.04) bins = vote(false)

  const top = [...bins.values()].sort((p, q) => q[3] - p[3])[0]
  return rgbToHex({ r: top[0] / top[3], g: top[1] / top[3], b: top[2] / top[3] })
}

const KEYWORDS: [Category, RegExp][] = [
  ['dresses', /dress|gown|jumpsuit|saree|sari|kurta|lehenga|romper/],
  ['outerwear', /jacket|coat|blazer|hoodie|cardigan|parka|trench|shrug/],
  ['bottoms', /jean|pant|trouser|skirt|short|legging|chino|jogger|palazzo/],
  ['shoes', /shoe|sneaker|boot|heel|sandal|loafer|flat|trainer|slipper/],
  ['bags', /bag|tote|clutch|purse|backpack|wallet/],
  ['jewellery', /ring|necklace|earring|bracelet|watch|chain|pendant|bangle|jewel/],
  ['accessories', /belt|scarf|hat|cap|sunglass|glove|tie|stole|dupatta/],
  ['tops', /top|shirt|tee|blouse|sweater|tank|polo|knit|vest/],
]

export function guessCategory(fileName: string): Category {
  const name = fileName.toLowerCase()
  return KEYWORDS.find(([, re]) => re.test(name))?.[0] ?? 'tops'
}

/** "IMG_blue-denim_jacket.jpg" -> "Blue denim jacket"; camera-roll names become a blank title. */
export function nameFromFile(fileName: string): string {
  const base = fileName.replace(/\.[^.]+$/, '').replace(/[_-]+/g, ' ').trim()
  if (!/[a-z]{3,}/i.test(base) || /^(img|image|dsc|pxl|photo|screenshot|whatsapp)\b/i.test(base)) return ''
  return base.charAt(0).toUpperCase() + base.slice(1).toLowerCase()
}
