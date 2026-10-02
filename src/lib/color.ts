export interface RGB {
  r: number
  g: number
  b: number
}

export interface Lab {
  L: number
  a: number
  b: number
}

export function hexToRgb(hex: string): RGB {
  const n = parseInt(hex.replace('#', ''), 16)
  return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 }
}

export function rgbToHex({ r, g, b }: RGB): string {
  const h = (v: number) => Math.round(Math.min(255, Math.max(0, v))).toString(16).padStart(2, '0')
  return `#${h(r)}${h(g)}${h(b)}`
}

/** sRGB (D65) -> CIELAB. */
export function rgbToLab({ r, g, b }: RGB): Lab {
  const lin = (v: number) => {
    const c = v / 255
    return c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4
  }
  const R = lin(r)
  const G = lin(g)
  const B = lin(b)
  const x = (R * 0.4124564 + G * 0.3575761 + B * 0.1804375) / 0.95047
  const y = R * 0.2126729 + G * 0.7151522 + B * 0.072175
  const z = (R * 0.0193339 + G * 0.119192 + B * 0.9503041) / 1.08883
  const f = (t: number) => (t > 0.008856 ? Math.cbrt(t) : 7.787 * t + 16 / 116)
  const fx = f(x)
  const fy = f(y)
  const fz = f(z)
  return { L: 116 * fy - 16, a: 500 * (fx - fy), b: 200 * (fy - fz) }
}

export const hexToLab = (hex: string) => rgbToLab(hexToRgb(hex))

/** CIE76 colour difference. ~2 is barely visible, ~20+ is a clearly different colour. */
export function deltaE(p: Lab, q: Lab): number {
  return Math.hypot(p.L - q.L, p.a - q.a, p.b - q.b)
}

/** True when dark text reads better than light text on this colour. */
export function isLight(hex: string): boolean {
  return hexToLab(hex).L > 62
}
