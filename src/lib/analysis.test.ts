import { describe, expect, it } from 'vitest'
import { PALETTES, paletteFor } from '../data/palettes'
import { deltaE, hexToLab, hexToRgb, rgbToHex } from './color'
import { classifyLegLine, classifyShape, heightBand } from './fit'
import { guessCategory, nameFromFile } from './garment'
import { classifySkin } from './skin'
import { buildOutfit, paletteFit } from './styling'
import type { Category, WardrobeItem } from './types'

describe('colour maths', () => {
  it('round-trips hex and converts reference colours to Lab', () => {
    expect(rgbToHex(hexToRgb('#9a4a38'))).toBe('#9a4a38')
    expect(hexToLab('#ffffff').L).toBeCloseTo(100, 0)
    expect(hexToLab('#000000').L).toBeCloseTo(0, 0)
    const red = hexToLab('#ff0000')
    expect(red.L).toBeCloseTo(53.2, 0)
    expect(red.a).toBeCloseTo(80.1, 0)
    expect(deltaE(red, red)).toBe(0)
  })
})

describe('classifySkin', () => {
  it('reads depth from light to deep', () => {
    expect(classifySkin(hexToRgb('#f4d0b1')).depth).toBe('light')
    expect(classifySkin(hexToRgb('#d29e7c')).depth).toBe('medium')
    expect(classifySkin(hexToRgb('#825c43')).depth).toBe('deep')
    expect(classifySkin(hexToRgb('#3c1f1d')).depth).toBe('deep')
  })

  it('reads undertone from hue', () => {
    expect(classifySkin(hexToRgb('#e5b887')).undertone).toBe('warm')
    expect(classifySkin(hexToRgb('#d29e7c')).undertone).toBe('neutral')
    expect(classifySkin(hexToRgb('#e0a899')).undertone).toBe('cool')
  })
})

describe('palettes', () => {
  it('has a complete palette for every undertone and depth', () => {
    expect(PALETTES).toHaveLength(9)
    for (const u of ['warm', 'neutral', 'cool'] as const) {
      for (const d of ['light', 'medium', 'deep'] as const) {
        const p = paletteFor(u, d)
        expect(p.best).toHaveLength(8)
        expect(p.neutrals).toHaveLength(4)
        expect(p.avoid).toHaveLength(4)
        for (const s of [...p.best, ...p.neutrals, ...p.metals, ...p.avoid]) expect(s.hex).toMatch(/^#[0-9A-F]{6}$/i)
      }
    }
  })

  it('rates garment colours against a palette', () => {
    const autumn = paletteFor('warm', 'medium')
    expect(paletteFit('#c2613f', autumn)).toBe('match')
    expect(paletteFit('#f3d6e2', autumn)).toBe('clash')
  })
})

describe('classifyShape', () => {
  it('classifies womenswear silhouettes', () => {
    expect(classifyShape({ shoulders: 115, waist: 76, hips: 100 }, 'womenswear')).toBe('hourglass')
    expect(classifyShape({ shoulders: 115, waist: 90, hips: 100 }, 'womenswear')).toBe('rectangle')
    expect(classifyShape({ shoulders: 98, waist: 80, hips: 100 }, 'womenswear')).toBe('triangle')
    expect(classifyShape({ shoulders: 135, waist: 85, hips: 100 }, 'womenswear')).toBe('inverted')
    expect(classifyShape({ shoulders: 115, waist: 102, hips: 100 }, 'womenswear')).toBe('oval')
  })

  it('uses wider shoulder thresholds for menswear', () => {
    const widths = { shoulders: 130, waist: 92, hips: 100 }
    expect(classifyShape(widths, 'womenswear')).toBe('inverted')
    expect(classifyShape(widths, 'menswear')).toBe('rectangle')
  })
})

describe('proportions', () => {
  it('bands leg line and height', () => {
    expect(classifyLegLine(1.8)).toBe('long')
    expect(classifyLegLine(1.6)).toBe('balanced')
    expect(classifyLegLine(1.4)).toBe('short')
    expect(heightBand(155, 'womenswear')).toBe('petite')
    expect(heightBand(165, 'womenswear')).toBe('average')
    expect(heightBand(180, 'womenswear')).toBe('tall')
    expect(heightBand(180, 'menswear')).toBe('average')
  })
})

describe('wardrobe helpers', () => {
  it('guesses a category and a name from the file name', () => {
    expect(guessCategory('blue-denim_jacket.jpg')).toBe('outerwear')
    expect(guessCategory('black jeans.png')).toBe('bottoms')
    expect(guessCategory('IMG_2041.jpg')).toBe('tops')
    expect(nameFromFile('blue-denim_jacket.jpg')).toBe('Blue denim jacket')
    expect(nameFromFile('IMG_2041.jpg')).toBe('')
  })

  const piece = (id: string, category: Category): WardrobeItem => ({
    id,
    userId: 'u',
    name: id,
    category,
    colorHex: '#c1603f',
    image: '',
    favorite: false,
    notes: '',
    createdAt: 0,
  })

  it('builds an outfit only when there is a base to build on', () => {
    expect(buildOutfit([piece('shoes', 'shoes'), piece('top', 'tops')])).toBeNull()
    const outfit = buildOutfit([piece('top', 'tops'), piece('jeans', 'bottoms'), piece('shoes', 'shoes')])!
    expect(outfit.pieces.map((p) => p.id)).toEqual(['top', 'jeans', 'shoes'])
    expect(buildOutfit([piece('dress', 'dresses')])!.pieces.map((p) => p.id)).toEqual(['dress'])
  })
})
