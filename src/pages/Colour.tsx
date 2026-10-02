import { Camera } from 'lucide-react'
import { useRef, useState, type MouseEvent } from 'react'
import PhotoDrop from '../components/PhotoDrop'
import { Swatches } from '../components/Swatches'
import { paletteFor } from '../data/palettes'
import type { RGB } from '../lib/color'
import { loadPhoto, resizeCanvas, toJpegUrl } from '../lib/image'
import { useStudio } from '../lib/profile'
import { analyseSelfie, classifySkin, sampleSkin, type Point } from '../lib/skin'
import type { Depth, Undertone } from '../lib/types'

const UNDERTONES: { id: Undertone; label: string }[] = [
  { id: 'cool', label: 'Cool' },
  { id: 'neutral', label: 'Neutral' },
  { id: 'warm', label: 'Warm' },
]

const DEPTHS: { id: Depth; label: string; skin: string }[] = [
  { id: 'light', label: 'Light', skin: 'Fair' },
  { id: 'medium', label: 'Medium', skin: 'Medium' },
  { id: 'deep', label: 'Deep', skin: 'Brown' },
]

const TIPS = [
  'Face a window in daylight. Avoid yellow indoor bulbs and flash.',
  'No filters, and as little makeup as possible.',
  'Look straight at the camera with your hair off your face.',
]

interface Dot extends Point {
  /** Diameter as a fraction of the photo width; x and y are fractions too. */
  size: number
}

export default function Colour() {
  const { profile, updateProfile } = useStudio()
  const color = profile.color
  const canvas = useRef<HTMLCanvasElement | null>(null)
  const [photoUrl, setPhotoUrl] = useState('')
  const [dots, setDots] = useState<Dot[]>([])
  const [busy, setBusy] = useState(false)
  const [notice, setNotice] = useState('')

  async function save(rgb: RGB, points: Point[], radius: number) {
    const source = canvas.current!
    setDots(points.map((p) => ({ x: p.x / source.width, y: p.y / source.height, size: (radius * 2) / source.width })))
    await updateProfile({
      color: {
        ...classifySkin(rgb),
        selfieThumb: toJpegUrl(resizeCanvas(source, 420), 0.8),
        analysedAt: Date.now(),
      },
    })
  }

  async function onFiles([file]: File[]) {
    setBusy(true)
    setNotice('')
    setDots([])
    try {
      const loaded = await loadPhoto(file, 1024)
      canvas.current = loaded
      setPhotoUrl(toJpegUrl(loaded))
      const sample = await analyseSelfie(loaded)
      if (sample) await save(sample.rgb, sample.points, sample.radius)
      else setNotice('No face was found in that photo. Tap your cheek in the photo to sample your skin yourself.')
    } catch (err) {
      const reason = err instanceof Error ? err.message : 'The photo could not be analysed.'
      setNotice(canvas.current ? `${reason} You can still tap your cheek in the photo to sample your skin.` : reason)
    } finally {
      setBusy(false)
    }
  }

  async function pick(e: MouseEvent<HTMLDivElement>) {
    const source = canvas.current
    if (!source || busy) return
    const box = e.currentTarget.getBoundingClientRect()
    const point = {
      x: ((e.clientX - box.left) / box.width) * source.width,
      y: ((e.clientY - box.top) / box.height) * source.height,
    }
    const radius = source.width * 0.02
    const rgb = sampleSkin(source, [point], radius)
    if (!rgb) return
    setNotice('')
    await save(rgb, [point], radius)
  }

  // A hand-picked depth replaces the measured label too, so the two never disagree.
  const tune = (patch: { undertone?: Undertone; depth?: Depth }) =>
    color &&
    updateProfile({
      color: {
        ...color,
        ...patch,
        ...(patch.depth && patch.depth !== color.depth && { depthLabel: DEPTHS.find((d) => d.id === patch.depth)!.skin }),
      },
    })

  const shownPhoto = photoUrl || color?.selfieThumb
  const palette = color && paletteFor(color.undertone, color.depth)

  return (
    <>
      <div className="page-head">
        <div className="stack" style={{ '--gap': '10px' } as React.CSSProperties}>
          <p className="eyebrow">Colour analysis</p>
          <h1 className="display h-lg">
            The colours that <em>suit you</em>
          </h1>
        </div>
        <p className="muted" style={{ maxWidth: '30rem' }}>
          Upload a selfie or take one now. Your skin tone is read on this device, and you get a palette built around it.
        </p>
      </div>

      <div className="split">
        <div className="stack" style={{ '--gap': '20px' } as React.CSSProperties}>
          {shownPhoto && (
            <div className={photoUrl ? 'photo photo--pick' : 'photo'} onClick={pick}>
              <img src={shownPhoto} alt="Your selfie" />
              {dots.map((d, i) => (
                <span
                  key={i}
                  className="photo__dot"
                  style={{ left: `${d.x * 100}%`, top: `${d.y * 100}%`, width: `${d.size * 100}%`, aspectRatio: '1' }}
                />
              ))}
            </div>
          )}
          {photoUrl && (
            <p className="small muted">
              The circles show where your skin was sampled. Tap anywhere on bare skin to sample from that spot instead.
            </p>
          )}
          {notice && (
            <p className="notice" role="alert">
              {notice}
            </p>
          )}
          <PhotoDrop
            icon={<Camera size={22} strokeWidth={1.5} />}
            title={shownPhoto ? 'Use a different selfie' : 'Upload your selfie'}
            hint="Drop a photo here or click to choose one. It stays on your device."
            camera="user"
            cameraLabel="Take a selfie"
            busy={busy}
            busyLabel="Reading your skin tone…"
            slim={Boolean(shownPhoto)}
            onFiles={onFiles}
          />
          <div className="card stack">
            <p className="eyebrow">For an accurate reading</p>
            <ul className="ticks">
              {TIPS.map((tip) => (
                <li key={tip}>{tip}</li>
              ))}
            </ul>
          </div>
        </div>

        {color && palette ? (
          <div className="stack" style={{ '--gap': '36px' } as React.CSSProperties}>
            <section className="card stack" style={{ '--gap': '22px' } as React.CSSProperties}>
              <div className="tone">
                <span className="tone__chip" style={{ background: color.skinHex }} />
                <div>
                  <p className="eyebrow">Your season</p>
                  <h2 className="display h-lg">{palette.season}</h2>
                  <p className="muted">
                    {color.depthLabel} skin · {color.undertone} undertone · {palette.mood.toLowerCase()}
                  </p>
                </div>
              </div>
              <p>{palette.about}</p>
              <div className="stack" style={{ '--gap': '10px' } as React.CSSProperties}>
                <p className="eyebrow">Fine-tune the reading</p>
                <p className="small muted">
                  Lighting shifts how skin photographs. If the veins on your wrist look green and gold jewellery suits
                  you, choose warm; if they look blue and silver suits you, choose cool.
                </p>
                <div className="chips">
                  {UNDERTONES.map((u) => (
                    <button
                      key={u.id}
                      className="chip"
                      aria-pressed={color.undertone === u.id}
                      onClick={() => tune({ undertone: u.id })}
                    >
                      {u.label}
                    </button>
                  ))}
                  <span style={{ width: 12 }} />
                  {DEPTHS.map((d) => (
                    <button
                      key={d.id}
                      className="chip"
                      aria-pressed={color.depth === d.id}
                      onClick={() => tune({ depth: d.id })}
                    >
                      {d.label}
                    </button>
                  ))}
                </div>
              </div>
            </section>

            <section className="stack">
              <h3 className="display h-md">Wear these near your face</h3>
              <Swatches shades={palette.best} />
            </section>

            <section className="stack">
              <h3 className="display h-md">Your neutrals</h3>
              <p className="muted">Build coats, trousers, shoes and bags from these.</p>
              <Swatches shades={palette.neutrals} />
            </section>

            <div className="guide">
              <section className="stack">
                <h3 className="display h-md">Jewellery & metals</h3>
                <Swatches shades={palette.metals} small />
              </section>
              <section className="stack">
                <h3 className="display h-md">Keep away from your face</h3>
                <Swatches shades={palette.avoid} small avoid />
              </section>
            </div>
          </div>
        ) : (
          <div className="card stack" style={{ '--gap': '18px' } as React.CSSProperties}>
            <p className="eyebrow">What you will get</p>
            <h2 className="display h-md">A palette made for your skin</h2>
            <ul className="ticks">
              <li>Your skin depth and undertone, measured from the photo</li>
              <li>Eight colours that flatter you most</li>
              <li>Neutrals to build your basics on</li>
              <li>The metals that suit you, and the shades to avoid</li>
            </ul>
          </div>
        )}
      </div>
    </>
  )
}
