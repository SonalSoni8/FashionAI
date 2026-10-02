// Puts the on-device vision runtime where the app can load it:
//   public/mediapipe/wasm    <- copied from node_modules
//   public/mediapipe/models  <- downloaded once (face + pose landmark models)
// Runs on `npm install`; re-run with `npm run setup:vision`.
import { cp, mkdir, stat, writeFile } from 'node:fs/promises'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = join(dirname(fileURLToPath(import.meta.url)), '..')
const wasmSrc = join(root, 'node_modules', '@mediapipe', 'tasks-vision', 'wasm')
const wasmDest = join(root, 'public', 'mediapipe', 'wasm')
const modelDir = join(root, 'public', 'mediapipe', 'models')

const MODELS = {
  'face_landmarker.task':
    'https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task',
  'pose_landmarker_full.task':
    'https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_full/float16/1/pose_landmarker_full.task',
}

const exists = (p) => stat(p).then((s) => s.isDirectory() || s.size > 0, () => false)

async function main() {
  if (!(await exists(wasmSrc))) {
    console.log('[setup-vision] @mediapipe/tasks-vision not installed yet, skipping.')
    return
  }
  await mkdir(wasmDest, { recursive: true })
  await cp(wasmSrc, wasmDest, { recursive: true })
  console.log('[setup-vision] wasm runtime copied.')

  await mkdir(modelDir, { recursive: true })
  for (const [name, url] of Object.entries(MODELS)) {
    const dest = join(modelDir, name)
    if (await exists(dest)) continue
    console.log(`[setup-vision] downloading ${name} ...`)
    const res = await fetch(url)
    if (!res.ok) throw new Error(`${name}: HTTP ${res.status}`)
    await writeFile(dest, Buffer.from(await res.arrayBuffer()))
  }
  console.log('[setup-vision] models ready.')
}

main().catch((err) => {
  // Never fail the install over this: the app explains how to recover.
  console.warn(`[setup-vision] could not finish (${err.message}). Run "npm run setup:vision" when online.`)
})
