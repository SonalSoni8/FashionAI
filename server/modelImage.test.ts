import { describe, expect, it } from 'vitest'
import type { Look, StyleBrief } from '../shared/looks'
import { imagePrompt } from './modelImage'

const look: Look = {
  id: 'x',
  title: 'Linen Weekend',
  occasion: 'Everyday',
  why: '',
  pieces: [
    { name: 'Wrap top', category: 'top', colour: 'Terracotta', colourHex: '#C1603F', shopQuery: '' },
    { name: 'Wide-leg trousers', category: 'bottom', colour: 'Cream', colourHex: '#F3E7D0', shopQuery: '' },
  ],
}

describe('imagePrompt', () => {
  it('describes the body shape, skin, stature and every piece', () => {
    const brief: StyleBrief = { shape: 'triangle', line: 'womenswear', heightCm: 152, skinDepth: 'Tan', country: 'in' }
    const prompt = imagePrompt(brief, look)
    expect(prompt).toContain('one adult woman with tan skin, short in stature')
    expect(prompt).toContain('pear-shaped figure')
    expect(prompt).toContain('terracotta wrap top; cream wide-leg trousers')
  })

  it('uses the menswear wording and leaves out what is unknown', () => {
    const prompt = imagePrompt({ shape: 'inverted', line: 'menswear', country: 'us' }, look)
    expect(prompt).toContain('one adult man, with an inverted-triangle build')
    expect(prompt).not.toContain('skin')
  })
})
