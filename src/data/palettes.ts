import type { Depth, Undertone } from '../lib/types'

export interface Shade {
  name: string
  hex: string
}

export interface Palette {
  id: `${Undertone}-${Depth}`
  season: string
  mood: string
  about: string
  best: Shade[]
  neutrals: Shade[]
  metals: Shade[]
  avoid: Shade[]
}

const GOLD = { name: 'Yellow gold', hex: '#D4AF37' }
const ROSE_GOLD = { name: 'Rose gold', hex: '#C9917E' }
const SILVER = { name: 'Silver', hex: '#C4C8CE' }
const PLATINUM = { name: 'Platinum', hex: '#DCDDDD' }
const BRONZE = { name: 'Bronze', hex: '#A9743A' }
const COPPER = { name: 'Copper', hex: '#B5693B' }

export const PALETTES: Palette[] = [
  {
    id: 'warm-light',
    season: 'Light Spring',
    mood: 'Fresh, sunlit, delicate',
    about:
      'Your skin is fair with a golden cast. Clear, warm, light colours make it glow; heavy or icy shades drain it.',
    best: [
      { name: 'Peach', hex: '#F7B58F' },
      { name: 'Coral', hex: '#F0806A' },
      { name: 'Warm aqua', hex: '#6FC6C0' },
      { name: 'Buttercream', hex: '#F6E2A3' },
      { name: 'Leaf green', hex: '#8DBE6B' },
      { name: 'Golden yellow', hex: '#F3C54A' },
      { name: 'Periwinkle', hex: '#8FA3E0' },
      { name: 'Poppy', hex: '#E8553E' },
    ],
    neutrals: [
      { name: 'Ivory', hex: '#FBF3E4' },
      { name: 'Camel', hex: '#C9A06B' },
      { name: 'Warm taupe', hex: '#B49A82' },
      { name: 'Soft navy', hex: '#3D4E73' },
    ],
    metals: [GOLD, ROSE_GOLD],
    avoid: [
      { name: 'Black', hex: '#141414' },
      { name: 'Burgundy', hex: '#5B1A2B' },
      { name: 'Cool grey', hex: '#8A8F98' },
      { name: 'Stark white', hex: '#FFFFFF' },
    ],
  },
  {
    id: 'neutral-light',
    season: 'Soft Summer',
    mood: 'Hazy, gentle, tonal',
    about:
      'Your skin is fair and sits between warm and cool. Soft, slightly muted colours flatter it most; very bright or very dark shades overpower it.',
    best: [
      { name: 'Dusty rose', hex: '#D4A0A7' },
      { name: 'Sage', hex: '#A3B59A' },
      { name: 'Soft teal', hex: '#5F9EA0' },
      { name: 'Mauve', hex: '#B08BA8' },
      { name: 'Powder blue', hex: '#A9C4DE' },
      { name: 'Watermelon', hex: '#E0707C' },
      { name: 'Lavender', hex: '#B7A8D6' },
      { name: 'Seafoam', hex: '#9AD0BD' },
    ],
    neutrals: [
      { name: 'Soft white', hex: '#F4F0EA' },
      { name: 'Stone', hex: '#B9B0A3' },
      { name: 'Dove grey', hex: '#9A9CA3' },
      { name: 'Denim navy', hex: '#40507A' },
    ],
    metals: [ROSE_GOLD, SILVER, { name: 'Soft gold', hex: '#D9C28A' }],
    avoid: [
      { name: 'Black', hex: '#141414' },
      { name: 'Neon orange', hex: '#FF6A00' },
      { name: 'Mustard', hex: '#C99A1E' },
      { name: 'Chocolate', hex: '#3E2418' },
    ],
  },
  {
    id: 'cool-light',
    season: 'Light Summer',
    mood: 'Cool, airy, pastel',
    about:
      'Your skin is fair with a pink or rosy cast. Cool, light colours with a blue base keep it clear; orange and yellow-based shades make it look flushed.',
    best: [
      { name: 'Rose pink', hex: '#E59AB4' },
      { name: 'Powder blue', hex: '#9FC3E8' },
      { name: 'Lavender', hex: '#B9A6E0' },
      { name: 'Mint', hex: '#A6E0CC' },
      { name: 'Raspberry', hex: '#C2456E' },
      { name: 'Periwinkle', hex: '#7F8FD9' },
      { name: 'Soft fuchsia', hex: '#D26AA6' },
      { name: 'Sky blue', hex: '#6FA8DC' },
    ],
    neutrals: [
      { name: 'Soft white', hex: '#F5F4F2' },
      { name: 'Pearl grey', hex: '#B8BCC4' },
      { name: 'Rose beige', hex: '#CDB5AE' },
      { name: 'Slate navy', hex: '#34446B' },
    ],
    metals: [SILVER, PLATINUM, ROSE_GOLD],
    avoid: [
      { name: 'Orange', hex: '#E8791E' },
      { name: 'Mustard', hex: '#C99A1E' },
      { name: 'Rust', hex: '#A6452A' },
      { name: 'Black', hex: '#141414' },
    ],
  },
  {
    id: 'warm-medium',
    season: 'True Autumn',
    mood: 'Earthy, rich, spiced',
    about:
      'Your skin is medium with a golden or olive warmth. Earthy, saturated colours echo that warmth; icy pastels and blue-pinks fight it.',
    best: [
      { name: 'Terracotta', hex: '#C1603F' },
      { name: 'Mustard', hex: '#D1A12B' },
      { name: 'Olive', hex: '#6F7438' },
      { name: 'Teal', hex: '#1F6F6B' },
      { name: 'Pumpkin', hex: '#D9772E' },
      { name: 'Forest', hex: '#2F5D3A' },
      { name: 'Tomato red', hex: '#C63D2B' },
      { name: 'Warm turquoise', hex: '#2E9C94' },
    ],
    neutrals: [
      { name: 'Cream', hex: '#F3E7D0' },
      { name: 'Camel', hex: '#B98A52' },
      { name: 'Khaki', hex: '#8A7C55' },
      { name: 'Chocolate', hex: '#4A2F22' },
    ],
    metals: [GOLD, BRONZE, COPPER],
    avoid: [
      { name: 'Icy pink', hex: '#F4D7E3' },
      { name: 'Fuchsia', hex: '#D0237A' },
      { name: 'Icy blue', hex: '#CFE4F5' },
      { name: 'Cool grey', hex: '#8A8F98' },
    ],
  },
  {
    id: 'neutral-medium',
    season: 'Soft Autumn',
    mood: 'Muted, warm, effortless',
    about:
      'Your skin is medium and balanced between warm and cool. Softened, blended colours look expensive on you; harsh brights and stark contrasts look loud.',
    best: [
      { name: 'Dusty coral', hex: '#D98A76' },
      { name: 'Moss', hex: '#7E8B55' },
      { name: 'Jade', hex: '#4F9A86' },
      { name: 'Warm rose', hex: '#C4737C' },
      { name: 'Butterscotch', hex: '#D9A650' },
      { name: 'Soft teal', hex: '#3F7F84' },
      { name: 'Plum rose', hex: '#8E5068' },
      { name: 'Brick', hex: '#A9503E' },
    ],
    neutrals: [
      { name: 'Oatmeal', hex: '#E8DCC8' },
      { name: 'Mushroom', hex: '#A8988A' },
      { name: 'Olive grey', hex: '#73715E' },
      { name: 'Cocoa', hex: '#5A4034' },
    ],
    metals: [{ name: 'Brushed gold', hex: '#C9AE6A' }, ROSE_GOLD, BRONZE],
    avoid: [
      { name: 'Stark white', hex: '#FFFFFF' },
      { name: 'Black', hex: '#141414' },
      { name: 'Electric blue', hex: '#1F4FFF' },
      { name: 'Neon pink', hex: '#FF2E93' },
    ],
  },
  {
    id: 'cool-medium',
    season: 'True Summer',
    mood: 'Cool, composed, elegant',
    about:
      'Your skin is medium with a rosy or blue-pink cast. Cool, mid-depth colours bring it to life; golden and orange shades turn it sallow.',
    best: [
      { name: 'Raspberry', hex: '#B5375F' },
      { name: 'Slate blue', hex: '#5B7AA6' },
      { name: 'Plum', hex: '#6E3B6E' },
      { name: 'Soft emerald', hex: '#2F8F7A' },
      { name: 'Rose', hex: '#D4718F' },
      { name: 'Periwinkle', hex: '#7C86CF' },
      { name: 'Cool red', hex: '#B8233F' },
      { name: 'Orchid', hex: '#A865B5' },
    ],
    neutrals: [
      { name: 'Soft white', hex: '#F2F2F0' },
      { name: 'Blue grey', hex: '#8892A0' },
      { name: 'Cocoa rose', hex: '#7A625E' },
      { name: 'Navy', hex: '#27365A' },
    ],
    metals: [SILVER, PLATINUM, ROSE_GOLD],
    avoid: [
      { name: 'Orange', hex: '#E8791E' },
      { name: 'Mustard', hex: '#C99A1E' },
      { name: 'Camel', hex: '#B98A52' },
      { name: 'Olive', hex: '#6F7438' },
    ],
  },
  {
    id: 'warm-deep',
    season: 'Deep Autumn',
    mood: 'Opulent, warm, dramatic',
    about:
      'Your skin is deep with a golden or red-brown warmth. Rich, saturated, warm colours match its depth; pale pastels sit ashy against it.',
    best: [
      { name: 'Burnt orange', hex: '#B5521B' },
      { name: 'Deep teal', hex: '#0F5257' },
      { name: 'Ochre gold', hex: '#C28B1E' },
      { name: 'Brick red', hex: '#8E2F1F' },
      { name: 'Forest', hex: '#1F4A33' },
      { name: 'Tomato', hex: '#C4381F' },
      { name: 'Aubergine', hex: '#4A2238' },
      { name: 'Marigold', hex: '#E0A21A' },
    ],
    neutrals: [
      { name: 'Warm cream', hex: '#EFE2C8' },
      { name: 'Bronze khaki', hex: '#6E5F3A' },
      { name: 'Espresso', hex: '#33221B' },
      { name: 'Ink navy', hex: '#1E2A3D' },
    ],
    metals: [{ name: 'Antique gold', hex: '#B8963E' }, BRONZE, COPPER],
    avoid: [
      { name: 'Pastel pink', hex: '#F6D5DE' },
      { name: 'Icy lavender', hex: '#DCD6F0' },
      { name: 'Baby blue', hex: '#BFD9F2' },
      { name: 'Ash grey', hex: '#A9A9AE' },
    ],
  },
  {
    id: 'neutral-deep',
    season: 'Deep Winter',
    mood: 'Bold, saturated, striking',
    about:
      'Your skin is deep and balanced between warm and cool. Strong jewel tones and high contrast suit it; dusty, washed-out shades look flat.',
    best: [
      { name: 'Burgundy', hex: '#6B1228' },
      { name: 'Emerald', hex: '#0B7A53' },
      { name: 'Royal purple', hex: '#4B2A8A' },
      { name: 'True red', hex: '#C4161C' },
      { name: 'Cobalt', hex: '#1F47B5' },
      { name: 'Deep teal', hex: '#0B5E66' },
      { name: 'Magenta', hex: '#B81E73' },
      { name: 'Lemon', hex: '#F2DC4B' },
    ],
    neutrals: [
      { name: 'Pure white', hex: '#FFFFFF' },
      { name: 'Charcoal', hex: '#3A3B40' },
      { name: 'Black', hex: '#141414' },
      { name: 'Midnight', hex: '#131C3A' },
    ],
    metals: [SILVER, GOLD, PLATINUM],
    avoid: [
      { name: 'Dusty peach', hex: '#E5BFA8' },
      { name: 'Beige', hex: '#D4C3A5' },
      { name: 'Muted sage', hex: '#A3B59A' },
      { name: 'Mustard', hex: '#C99A1E' },
    ],
  },
  {
    id: 'cool-deep',
    season: 'True Winter',
    mood: 'Crisp, vivid, high-contrast',
    about:
      'Your skin is deep with a cool, blue-red cast. Pure, icy and vivid cool colours look sharp on it; earthy, golden shades muddy it.',
    best: [
      { name: 'Sapphire', hex: '#1B3FA0' },
      { name: 'Fuchsia', hex: '#C81E7E' },
      { name: 'Emerald', hex: '#00875A' },
      { name: 'Blue red', hex: '#B5122E' },
      { name: 'Royal purple', hex: '#5A2AA0' },
      { name: 'Icy pink', hex: '#F4D7E3' },
      { name: 'Icy blue', hex: '#CFE4F5' },
      { name: 'Pine', hex: '#0E4D45' },
    ],
    neutrals: [
      { name: 'Pure white', hex: '#FFFFFF' },
      { name: 'Cool grey', hex: '#8A8F98' },
      { name: 'Black', hex: '#141414' },
      { name: 'Navy', hex: '#141E4A' },
    ],
    metals: [SILVER, PLATINUM, { name: 'White gold', hex: '#E3E1D8' }],
    avoid: [
      { name: 'Orange', hex: '#E8791E' },
      { name: 'Mustard', hex: '#C99A1E' },
      { name: 'Camel', hex: '#B98A52' },
      { name: 'Rust', hex: '#A6452A' },
    ],
  },
]

export function paletteFor(undertone: Undertone, depth: Depth): Palette {
  return PALETTES.find((p) => p.id === `${undertone}-${depth}`)!
}
