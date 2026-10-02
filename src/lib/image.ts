/** Decode an uploaded photo onto a canvas, downscaled so its longest side is at most `maxSide`. */
export async function loadPhoto(file: Blob, maxSide: number): Promise<HTMLCanvasElement> {
  let bitmap: ImageBitmap
  try {
    bitmap = await createImageBitmap(file, { imageOrientation: 'from-image' })
  } catch {
    throw new Error('That file could not be read as a photo. Please use a JPG, PNG or WebP image.')
  }
  const scale = Math.min(1, maxSide / Math.max(bitmap.width, bitmap.height))
  const canvas = document.createElement('canvas')
  canvas.width = Math.round(bitmap.width * scale)
  canvas.height = Math.round(bitmap.height * scale)
  const ctx = canvas.getContext('2d', { willReadFrequently: true })!
  // White underlay so transparent PNG cut-outs don't turn black as JPEG.
  ctx.fillStyle = '#ffffff'
  ctx.fillRect(0, 0, canvas.width, canvas.height)
  ctx.drawImage(bitmap, 0, 0, canvas.width, canvas.height)
  bitmap.close()
  return canvas
}

export function resizeCanvas(source: HTMLCanvasElement, maxSide: number): HTMLCanvasElement {
  const scale = Math.min(1, maxSide / Math.max(source.width, source.height))
  const canvas = document.createElement('canvas')
  canvas.width = Math.max(1, Math.round(source.width * scale))
  canvas.height = Math.max(1, Math.round(source.height * scale))
  canvas.getContext('2d', { willReadFrequently: true })!.drawImage(source, 0, 0, canvas.width, canvas.height)
  return canvas
}

export const toJpegUrl = (canvas: HTMLCanvasElement, quality = 0.85) => canvas.toDataURL('image/jpeg', quality)
