import type { HeightBand } from '../lib/fit'
import type { BodyShape, LegLine, StyleLine } from '../lib/types'

export interface ShapeGuide {
  label: string
  summary: string
  goal: string
  tops: string[]
  bottoms: string[]
  /** Dresses and outerwear for womenswear; tailoring and outerwear for menswear. */
  layers: string[]
  skip: string[]
}

export const SHAPE_ORDER: BodyShape[] = ['hourglass', 'rectangle', 'triangle', 'inverted', 'oval']

export const LAYERS_TITLE: Record<StyleLine, string> = {
  womenswear: 'Dresses & layers',
  menswear: 'Tailoring & layers',
}

export const SHAPES: Record<StyleLine, Record<BodyShape, ShapeGuide>> = {
  womenswear: {
    hourglass: {
      label: 'Hourglass',
      summary: 'Shoulders and hips are balanced, with a clearly defined waist.',
      goal: 'Follow your natural line and keep the waist visible.',
      tops: ['Wrap tops and fitted knits', 'V and scoop necklines', 'Tucked-in shirts and bodysuits'],
      bottoms: ['High-waisted trousers and jeans', 'Pencil and bias-cut skirts', 'Straight or gently flared legs'],
      layers: ['Wrap and belted dresses', 'Tailored blazers that nip at the waist', 'Belted trench coats'],
      skip: ['Boxy, shapeless tops', 'Drop-waist dresses', 'Stiff oversized layers that hide the waist'],
    },
    rectangle: {
      label: 'Rectangle',
      summary: 'Shoulders, waist and hips fall in a fairly straight line.',
      goal: 'Create curves by adding shape at the bust and hip and marking the waist.',
      tops: ['Peplum and ruffled tops', 'Off-shoulder and boat necklines', 'Cropped jackets and layered knits'],
      bottoms: ['Paper-bag and pleated trousers', 'A-line and tiered skirts', 'Wide-leg and cargo cuts'],
      layers: ['Belted shirt dresses', 'Fit-and-flare dresses', 'Structured blazers worn with a belt'],
      skip: ['Straight shift dresses worn unbelted', 'Head-to-toe clingy fabric', 'Long column silhouettes with no break'],
    },
    triangle: {
      label: 'Triangle (pear)',
      summary: 'Hips are wider than shoulders, usually with a defined waist.',
      goal: 'Draw the eye upward and balance the hips with width at the shoulders.',
      tops: ['Boat, square and off-shoulder necklines', 'Puff sleeves and shoulder detail', 'Bright colours and prints on top'],
      bottoms: ['Dark, mid-rise straight or bootcut jeans', 'A-line skirts that skim the hip', 'Wide-leg trousers in fluid fabric'],
      layers: ['Fit-and-flare dresses', 'Structured jackets that end above the hip', 'Statement coats with strong shoulders'],
      skip: ['Heavy hip pockets and embellishment', 'Skinny jeans with a short, tight top', 'Tops that end at the widest part of the hip'],
    },
    inverted: {
      label: 'Inverted triangle',
      summary: 'Shoulders are broader than hips, with a straighter hip line.',
      goal: 'Soften the shoulder line and add volume below the waist.',
      tops: ['V-necks and narrow straps', 'Soft, draped fabrics', 'Plain, darker tones on top'],
      bottoms: ['Wide-leg and flared trousers', 'Full, pleated or printed skirts', 'Light or bright colours below the waist'],
      layers: ['A-line and skater dresses', 'Longline, unstructured jackets', 'Wrap dresses with a full skirt'],
      skip: ['Shoulder pads and puff sleeves', 'Boat necks and wide horizontal stripes on top', 'Skinny, plain dark bottoms'],
    },
    oval: {
      label: 'Oval (apple)',
      summary: 'The midsection is the fullest part, with slimmer legs and arms.',
      goal: 'Lengthen the torso and show off the legs and neckline.',
      tops: ['V-necks and open collars', 'Empire-line and A-line tops', 'Fabrics that drape rather than cling'],
      bottoms: ['Straight and slim-leg trousers', 'Mid-rise with a flat front', 'Knee-length skirts that show the leg'],
      layers: ['Empire-waist and shift dresses', 'Long, open-front jackets and dusters', 'Single-colour columns under a layer'],
      skip: ['Belts at the widest point', 'Cropped, boxy tops', 'Bulky pleats or gathers at the waist'],
    },
  },
  menswear: {
    hourglass: {
      label: 'Trapezoid',
      summary: 'Broad shoulders taper to a narrower waist, with balanced hips.',
      goal: 'Most cuts work. Choose fitted pieces that follow your line.',
      tops: ['Slim and tailored-fit shirts', 'Fitted crew-neck tees and polos', 'Fine-gauge knitwear'],
      bottoms: ['Slim or tapered trousers', 'Straight-leg denim', 'Mid-rise chinos'],
      layers: ['Two-button suits with light structure', 'Bomber and Harrington jackets', 'Tailored overcoats'],
      skip: ['Baggy, shapeless shirts', 'Very wide trousers that hide the taper', 'Heavily padded shoulders'],
    },
    rectangle: {
      label: 'Rectangle',
      summary: 'Shoulders, waist and hips are close to the same width.',
      goal: 'Build the shoulders and suggest a taper at the waist.',
      tops: ['Structured shirts with chest pockets', 'Horizontal stripes and layered tees', 'Chunky and textured knits'],
      bottoms: ['Slim tapered trousers', 'Dark, straight-leg denim', 'Flat-front chinos'],
      layers: ['Structured blazers with shoulder padding', 'Overshirts and denim jackets', 'Double-breasted coats'],
      skip: ['Skin-tight tops', 'Unstructured long cardigans', 'Head-to-toe slim monochrome'],
    },
    triangle: {
      label: 'Triangle',
      summary: 'Hips and waist are wider than the shoulders.',
      goal: 'Widen the shoulder line and keep the lower half simple.',
      tops: ['Structured shirts in lighter colours', 'Horizontal detail across the chest', 'Henleys and textured knits'],
      bottoms: ['Dark, straight-leg trousers', 'Plain front, no pleats', 'Mid-rise denim with a clean line'],
      layers: ['Single-breasted blazers with built-up shoulders', 'Field and chore jackets', 'Coats that hang straight from the shoulder'],
      skip: ['Tight polos and slim tees', 'Light or patterned trousers', 'Skinny jeans'],
    },
    inverted: {
      label: 'Inverted triangle',
      summary: 'Shoulders and chest are clearly wider than the waist and hips.',
      goal: 'Add a little weight below and avoid over-building the shoulders.',
      tops: ['V-necks and slim-fit shirts', 'Vertical stripes', 'Soft-shoulder polos and knits'],
      bottoms: ['Straight or relaxed-leg trousers', 'Lighter colours and texture below', 'Chinos with a slight pleat'],
      layers: ['Unstructured blazers', 'Longer-line coats', 'Cardigans and shawl collars'],
      skip: ['Padded shoulders and epaulettes', 'Wide horizontal stripes across the chest', 'Very skinny trousers'],
    },
    oval: {
      label: 'Oval',
      summary: 'The midsection is the fullest part of the frame.',
      goal: 'Create a long, clean vertical line and add structure at the shoulder.',
      tops: ['Vertical stripes and dark solids', 'Shirts with a little room, worn untucked', 'V-neck knits'],
      bottoms: ['Straight-leg trousers at the natural waist', 'Flat-front, no cuffs', 'Dark denim with a gentle taper'],
      layers: ['Single-breasted, structured blazers', 'Open overshirts as a top layer', 'Knee-length overcoats'],
      skip: ['Tight tees and clingy knits', 'Horizontal stripes at the waist', 'Low-rise trousers and bulky belts'],
    },
  },
}

export const HEIGHT_TIPS: Record<HeightBand, { label: string; tips: string[] }> = {
  petite: {
    label: 'Shorter frame',
    tips: [
      'Wear one colour head to toe, or match shoes to trousers, to lengthen your line.',
      'Choose cropped jackets and higher rises so your legs read longer.',
      'Keep prints, bags and details small in scale.',
    ],
  },
  average: {
    label: 'Mid-height frame',
    tips: [
      'Most lengths work on you, so let fit and proportion lead.',
      'Use the rule of thirds: a shorter top over a longer bottom, or the reverse.',
      'Hem trousers to just touch the shoe for a clean line.',
    ],
  },
  tall: {
    label: 'Taller frame',
    tips: [
      'Break up your height with colour blocking, belts and layers.',
      'Longer coats, wide legs and maxi lengths sit well on you.',
      'Check sleeve and trouser lengths, and choose tall sizing where it exists.',
    ],
  },
}

export const LEG_TIPS: Record<LegLine, { label: string; tip: string }> = {
  long: {
    label: 'Longer legs, shorter torso',
    tip: 'Mid or low-rise bottoms and longer, untucked tops bring your proportions into balance.',
  },
  balanced: {
    label: 'Balanced legs and torso',
    tip: 'Your proportions are even, so you can wear any rise and tuck or untuck freely.',
  },
  short: {
    label: 'Longer torso, shorter legs',
    tip: 'High-rise bottoms, tucked-in tops and shoes that match your trousers lengthen your legs.',
  },
}
