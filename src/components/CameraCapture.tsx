import { SwitchCamera } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import Modal from './Modal'

export type Facing = 'user' | 'environment'

interface Props {
  title: string
  facing: Facing
  onCapture: (file: File) => void
  onClose: () => void
}

const TIMERS = [0, 3, 10]

function describe(err: unknown): string {
  const name = err instanceof DOMException ? err.name : ''
  if (name === 'NotAllowedError') {
    return 'Camera access is blocked. Allow the camera for this site in your browser settings, or upload a photo instead.'
  }
  if (name === 'NotFoundError' || name === 'OverconstrainedError') return 'No camera was found on this device.'
  if (name === 'NotReadableError') return 'The camera is in use by another app. Close it and try again.'
  return 'The camera could not be started. You can upload a photo instead.'
}

/** Live camera preview with a shutter, a self-timer and a front/back switch. */
export default function CameraCapture({ title, facing: initialFacing, onCapture, onClose }: Props) {
  const video = useRef<HTMLVideoElement>(null)
  const [facing, setFacing] = useState<Facing>(initialFacing)
  const [ready, setReady] = useState(false)
  const [error, setError] = useState('')
  const [timer, setTimer] = useState(0)
  const [countdown, setCountdown] = useState<number | null>(null)

  useEffect(() => {
    let stream: MediaStream | undefined
    let cancelled = false
    setReady(false)
    setError('')
    navigator.mediaDevices
      .getUserMedia({ audio: false, video: { facingMode: facing, width: { ideal: 1920 }, height: { ideal: 1080 } } })
      .then((s) => {
        stream = s
        if (cancelled) return s.getTracks().forEach((t) => t.stop())
        video.current!.srcObject = s
      })
      .catch((err) => !cancelled && setError(describe(err)))
    return () => {
      cancelled = true
      stream?.getTracks().forEach((t) => t.stop())
    }
  }, [facing])

  useEffect(() => {
    if (countdown === null) return
    if (countdown === 0) {
      setCountdown(null)
      shoot()
      return
    }
    const id = setTimeout(() => setCountdown(countdown - 1), 1000)
    return () => clearTimeout(id)
  }, [countdown])

  function shoot() {
    const source = video.current
    if (!source || !source.videoWidth) return
    const canvas = document.createElement('canvas')
    canvas.width = source.videoWidth
    canvas.height = source.videoHeight
    canvas.getContext('2d')!.drawImage(source, 0, 0)
    canvas.toBlob(
      (blob) => blob && onCapture(new File([blob], `photo-${Date.now()}.jpg`, { type: 'image/jpeg' })),
      'image/jpeg',
      0.92,
    )
  }

  const counting = countdown !== null

  return (
    <Modal
      title={title}
      onClose={onClose}
      footer={
        <>
          <div className="row">
            <button
              className="icon-btn"
              onClick={() => setFacing(facing === 'user' ? 'environment' : 'user')}
              disabled={counting}
              aria-label="Switch camera"
              title="Switch camera"
            >
              <SwitchCamera size={16} strokeWidth={1.5} />
            </button>
            <div className="chips" role="group" aria-label="Self-timer">
              {TIMERS.map((seconds) => (
                <button
                  key={seconds}
                  className="chip"
                  aria-pressed={timer === seconds}
                  disabled={counting}
                  onClick={() => setTimer(seconds)}
                >
                  {seconds ? `${seconds}s timer` : 'No timer'}
                </button>
              ))}
            </div>
          </div>
          {counting ? (
            <button className="btn btn--ghost" onClick={() => setCountdown(null)}>
              Cancel
            </button>
          ) : (
            <button className="btn" disabled={!ready} onClick={() => (timer ? setCountdown(timer) : shoot())}>
              Take photo
            </button>
          )}
        </>
      }
    >
      <div className="camera">
        {error ? (
          <p className="notice" role="alert">
            {error}
          </p>
        ) : (
          <>
            {/* The front camera is mirrored in the preview only; the saved photo is not flipped. */}
            <video
              ref={video}
              className={facing === 'user' ? 'camera__video camera__video--mirror' : 'camera__video'}
              autoPlay
              playsInline
              muted
              onLoadedMetadata={() => setReady(true)}
            />
            {!ready && <span className="spinner camera__wait" />}
            {counting && (
              <span className="camera__count" aria-live="assertive">
                {countdown}
              </span>
            )}
          </>
        )}
      </div>
    </Modal>
  )
}
