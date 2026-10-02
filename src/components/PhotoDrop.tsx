import { Camera } from 'lucide-react'
import { useRef, useState, type ReactNode } from 'react'
import CameraCapture, { type Facing } from './CameraCapture'

interface Props {
  icon: ReactNode
  title: string
  hint: string
  busy?: boolean
  busyLabel?: string
  multiple?: boolean
  slim?: boolean
  /** Which camera the "take a photo" option opens first. */
  camera: Facing
  cameraLabel: string
  onFiles: (files: File[]) => void
}

/** Lets the user either upload a photo (click or drag) or take one with the camera. */
export default function PhotoDrop({
  icon,
  title,
  hint,
  busy,
  busyLabel,
  multiple,
  slim,
  camera,
  cameraLabel,
  onFiles,
}: Props) {
  const upload = useRef<HTMLInputElement>(null)
  const nativeCamera = useRef<HTMLInputElement>(null)
  const [over, setOver] = useState(false)
  const [shooting, setShooting] = useState(false)

  const accept = (list: FileList | null) => {
    const files = [...(list ?? [])].filter((f) => f.type.startsWith('image/'))
    if (files.length) onFiles(multiple ? files : files.slice(0, 1))
  }

  // Live preview needs a secure page (https or localhost). Elsewhere, hand over
  // to the phone's own camera app through a capture input.
  const openCamera = () => ('mediaDevices' in navigator ? setShooting(true) : nativeCamera.current?.click())

  return (
    <div className="stack" style={{ '--gap': '12px' } as React.CSSProperties}>
      <button
        type="button"
        className={slim ? 'drop drop--slim' : 'drop'}
        data-over={over}
        disabled={busy}
        onClick={() => upload.current?.click()}
        onDragOver={(e) => {
          e.preventDefault()
          setOver(true)
        }}
        onDragLeave={() => setOver(false)}
        onDrop={(e) => {
          e.preventDefault()
          setOver(false)
          accept(e.dataTransfer.files)
        }}
      >
        <span className="drop__icon">{busy ? <span className="spinner" /> : icon}</span>
        <span className="display h-sm">{busy ? (busyLabel ?? 'Working…') : title}</span>
        <span className="small muted">{hint}</span>
      </button>

      <button type="button" className="btn btn--ghost" disabled={busy} onClick={openCamera}>
        <Camera size={16} strokeWidth={1.5} /> {cameraLabel}
      </button>

      <input
        ref={upload}
        type="file"
        accept="image/*"
        multiple={multiple}
        hidden
        onChange={(e) => {
          accept(e.target.files)
          e.target.value = ''
        }}
      />
      <input
        ref={nativeCamera}
        type="file"
        accept="image/*"
        capture={camera}
        hidden
        onChange={(e) => {
          accept(e.target.files)
          e.target.value = ''
        }}
      />

      {shooting && (
        <CameraCapture
          title={cameraLabel}
          facing={camera}
          onClose={() => setShooting(false)}
          onCapture={(file) => {
            setShooting(false)
            onFiles([file])
          }}
        />
      )}
    </div>
  )
}
