import { FaceLandmarker, FilesetResolver, PoseLandmarker } from '@mediapipe/tasks-vision'

// Everything here runs in the browser. The runtime and models are served from
// public/mediapipe (see scripts/setup-vision.mjs), so photos never leave the device.
const BASE = `${import.meta.env.BASE_URL}mediapipe`

export class VisionUnavailableError extends Error {
  constructor() {
    super('The on-device vision models could not be loaded. Run "npm run setup:vision" once, then reload.')
  }
}

let fileset: ReturnType<typeof FilesetResolver.forVisionTasks> | undefined
let face: Promise<FaceLandmarker> | undefined
let pose: Promise<PoseLandmarker> | undefined

const getFileset = () => (fileset ??= FilesetResolver.forVisionTasks(`${BASE}/wasm`))

function guarded<T>(create: () => Promise<T>, reset: () => void): Promise<T> {
  return create().catch((err) => {
    reset()
    console.error(err)
    throw new VisionUnavailableError()
  })
}

export function getFaceLandmarker(): Promise<FaceLandmarker> {
  return (face ??= guarded(
    async () =>
      FaceLandmarker.createFromOptions(await getFileset(), {
        baseOptions: { modelAssetPath: `${BASE}/models/face_landmarker.task`, delegate: 'CPU' },
        runningMode: 'IMAGE',
        numFaces: 1,
      }),
    () => (face = undefined),
  ))
}

export function getPoseLandmarker(): Promise<PoseLandmarker> {
  return (pose ??= guarded(
    async () =>
      PoseLandmarker.createFromOptions(await getFileset(), {
        baseOptions: { modelAssetPath: `${BASE}/models/pose_landmarker_full.task`, delegate: 'CPU' },
        runningMode: 'IMAGE',
        numPoses: 1,
        outputSegmentationMasks: true,
      }),
    () => (pose = undefined),
  ))
}
