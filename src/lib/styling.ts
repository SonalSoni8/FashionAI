import type { Palette } from '../data/palettes'
import { deltaE, hexToLab } from './color'
import type { Category, WardrobeItem } from './types'

export type PaletteFit = 'match' | 'clash' | 'neutral'

/** How a garment colour sits against a palette: close to a recommended shade, close to one to avoid, or neither. */
export function paletteFit(hex: string, palette: Palette): PaletteFit {
  const lab = hexToLab(hex)
  const nearest = (hexes: string[]) => Math.min(...hexes.map((h) => deltaE(lab, hexToLab(h))))
  const good = nearest([...palette.best, ...palette.neutrals].map((s) => s.hex))
  const bad = nearest(palette.avoid.map((s) => s.hex))
  if (good <= 24 && good <= bad) return 'match'
  if (bad <= 16) return 'clash'
  return 'neutral'
}

export interface Outfit {
  pieces: WardrobeItem[]
}

const pick = <T,>(list: T[], random: () => number): T | undefined => list[Math.floor(random() * list.length)]

/**
 * Put together one outfit from the wardrobe: a dress, or a top with a bottom,
 * then shoes and optional extras. Pieces worn near the face prefer colours
 * from the palette when one is known.
 */
export function buildOutfit(items: WardrobeItem[], palette?: Palette, random: () => number = Math.random): Outfit | null {
  const by = (c: Category) => items.filter((i) => i.category === c)
  const flattering = (list: WardrobeItem[]) => {
    if (!palette) return list
    const good = list.filter((i) => paletteFit(i.colorHex, palette) === 'match')
    const ok = list.filter((i) => paletteFit(i.colorHex, palette) !== 'clash')
    return good.length ? good : ok.length ? ok : list
  }

  const tops = by('tops')
  const bottoms = by('bottoms')
  const dresses = by('dresses')
  const canSeparates = tops.length > 0 && bottoms.length > 0
  if (!canSeparates && dresses.length === 0) return null

  const useDress = dresses.length > 0 && (!canSeparates || random() < dresses.length / (dresses.length + tops.length))
  const base = useDress ? [pick(flattering(dresses), random)] : [pick(flattering(tops), random), pick(bottoms, random)]
  const extras = [
    random() < 0.5 ? pick(flattering(by('outerwear')), random) : undefined,
    pick(by('shoes'), random),
    pick(by('bags'), random),
    pick([...by('jewellery'), ...by('accessories')], random),
  ]
  return { pieces: [...base, ...extras].filter((p): p is WardrobeItem => Boolean(p)) }
}
