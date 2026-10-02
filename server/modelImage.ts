import { ApiError, GoogleGenAI } from '@google/genai'
import { heightBand } from '../src/lib/fit'
import type { BodyShape, StyleLine } from '../src/lib/types'
import type { Look, StyleBrief } from '../shared/looks'
import { HttpError, missingKey } from './errors'

const MODEL = process.env.GEMINI_IMAGE_MODEL || 'gemini-3.1-flash-image'

// How each body shape should read in the picture.
const FIGURE: Record<StyleLine, Record<BodyShape, string>> = {
  womenswear: {
    hourglass: 'an hourglass figure: shoulders and hips the same width with a clearly defined waist',
    rectangle: 'a straight, rectangular figure: shoulders, waist and hips close to the same width',
    triangle: 'a pear-shaped figure: hips noticeably wider than the shoulders, with a defined waist',
    inverted: 'an inverted-triangle figure: broad shoulders and narrower hips',
    oval: 'an apple-shaped figure: a fuller midsection with slimmer legs and arms',
  },
  menswear: {
    hourglass: 'a trapezoid build: broad shoulders tapering to a narrower waist',
    rectangle: 'a straight, rectangular build: shoulders, waist and hips close to the same width',
    triangle: 'a triangle build: waist and hips wider than the shoulders',
    inverted: 'an inverted-triangle build: very broad shoulders and chest with a narrow waist and hips',
    oval: 'an oval build: a fuller midsection with a rounded torso',
  },
}

const STATURE = { petite: 'short in stature', average: 'of average height', tall: 'tall' }

export function imagePrompt(brief: StyleBrief, look: Look): string {
  const person = brief.line === 'menswear' ? 'man' : 'woman'
  const stature = brief.heightCm ? `, ${STATURE[heightBand(brief.heightCm, brief.line)]}` : ''
  const skin = brief.skinDepth ? ` with ${brief.skinDepth.toLowerCase()} skin` : ''
  const outfit = look.pieces.map((p) => `${p.colour.toLowerCase()} ${p.name.toLowerCase()}`).join('; ')

  return [
    `Full-length editorial fashion photograph of one adult ${person}${skin}${stature}, with ${FIGURE[brief.line][brief.shape]}.`,
    `The body proportions are realistic and clearly match that description.`,
    `Outfit: ${outfit}.`,
    `Standing relaxed and facing the camera, the whole body visible from head to shoes, centred in the frame.`,
    `Plain warm ivory studio backdrop, soft natural daylight, true-to-life fabric colours, realistic catalogue photography.`,
    `No text, no logos, no watermark, no other people.`,
  ].join(' ')
}

let client: GoogleGenAI | undefined

/** Generate a picture of a model with the brief's body shape wearing the look. Returns JPEG bytes. */
export async function renderLook(brief: StyleBrief, look: Look): Promise<Buffer> {
  const apiKey = process.env.GEMINI_API_KEY
  if (!apiKey) throw missingKey('GEMINI_API_KEY', 'Model images')
  client ??= new GoogleGenAI({
    apiKey,
    ...(process.env.GEMINI_BASE_URL && { httpOptions: { baseUrl: process.env.GEMINI_BASE_URL } }),
  })

  try {
    const interaction = await client.interactions.create({
      model: MODEL,
      input: imagePrompt(brief, look),
      response_format: { type: 'image', mime_type: 'image/jpeg', aspect_ratio: '3:4', image_size: '1K' },
    })
    const data = interaction.output_image?.data
    if (!data) throw new HttpError(502, 'The image model returned no picture for this outfit. Please try again.')
    return Buffer.from(data, 'base64')
  } catch (err) {
    if (err instanceof HttpError) throw err
    if (err instanceof ApiError) {
      console.error('[model-image]', err.status, err.message)
      if (err.status === 401 || err.status === 403) {
        throw new HttpError(502, 'The Gemini API key was rejected. Check GEMINI_API_KEY in the .env file.')
      }
      if (err.status === 429) throw new HttpError(429, 'The image model is busy right now. Please try again in a minute.')
      throw new HttpError(502, 'The image model could not draw this outfit. Please try again.')
    }
    throw err
  }
}
