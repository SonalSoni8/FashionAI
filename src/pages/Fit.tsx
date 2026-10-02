import { ScanLine } from 'lucide-react'
import { useState } from 'react'
import AiLooks from '../components/AiLooks'
import PhotoDrop from '../components/PhotoDrop'
import { HEIGHT_TIPS, LAYERS_TITLE, LEG_TIPS, SHAPE_ORDER, SHAPES } from '../data/shapes'
import { measureBody, type MeasureLine } from '../lib/body'
import { classifyLegLine, classifyShape, formatHeight, heightBand, toRatios } from '../lib/fit'
import { loadPhoto, toJpegUrl } from '../lib/image'
import { useStudio } from '../lib/profile'
import type { BodyShape, FitProfile, StyleLine } from '../lib/types'

const TIPS = [
  'Stand straight, facing the camera, with your whole body in the frame.',
  'Wear fitted clothes. Loose layers hide your outline.',
  'Hold your arms slightly away from your sides.',
  'Use a plain background and keep the camera at about waist height.',
  'Taking it yourself? Prop the device up, choose the 10s timer and step back.',
]

const LINES: { id: StyleLine; label: string }[] = [
  { id: 'womenswear', label: 'Womenswear' },
  { id: 'menswear', label: 'Menswear' },
]

const validHeight = (text: string) => {
  const cm = Number(text)
  return cm >= 120 && cm <= 230 ? Math.round(cm) : undefined
}

export default function Fit() {
  const { profile, updateProfile } = useStudio()
  const fit = profile.fit
  const [line, setLine] = useState<StyleLine>(fit?.line ?? 'womenswear')
  const [height, setHeight] = useState(fit?.heightCm ? String(fit.heightCm) : '')
  const [photoUrl, setPhotoUrl] = useState('')
  const [lines, setLines] = useState<MeasureLine[]>([])
  const [busy, setBusy] = useState(false)
  const [notice, setNotice] = useState('')

  const save = (next: Omit<FitProfile, 'analysedAt'>) => updateProfile({ fit: { ...next, analysedAt: Date.now() } })

  async function onFiles([file]: File[]) {
    setBusy(true)
    setNotice('')
    setLines([])
    try {
      const canvas = await loadPhoto(file, 1024)
      setPhotoUrl(toJpegUrl(canvas))
      const measured = await measureBody(canvas)
      setLines(measured.lines)
      await save({
        shape: classifyShape(measured.widths, line),
        line,
        heightCm: validHeight(height),
        ratios: toRatios(measured.widths, measured.legToTorso),
        legLine: classifyLegLine(measured.legToTorso),
        source: 'photo',
      })
    } catch (err) {
      setNotice(err instanceof Error ? err.message : 'The photo could not be analysed.')
    } finally {
      setBusy(false)
    }
  }

  function changeLine(next: StyleLine) {
    setLine(next)
    if (!fit) return
    // The two lines use different thresholds, so a measured shape is re-read; a hand-picked one is kept.
    const shape =
      fit.source === 'photo' && fit.ratios
        ? classifyShape({ shoulders: fit.ratios.shoulderToHip, waist: fit.ratios.waistToHip, hips: 1 }, next)
        : fit.shape
    save({ ...fit, line: next, shape })
  }

  function changeHeight(text: string) {
    setHeight(text)
    const cm = validHeight(text)
    if (fit && cm !== fit.heightCm && (cm || text === '')) save({ ...fit, heightCm: cm })
  }

  const chooseShape = (shape: BodyShape) =>
    save({ ...fit, shape, line, heightCm: validHeight(height), source: 'manual' })

  const guide = fit && SHAPES[fit.line][fit.shape]
  const band = fit?.heightCm ? heightBand(fit.heightCm, fit.line) : undefined

  return (
    <>
      <div className="page-head">
        <div className="stack" style={{ '--gap': '10px' } as React.CSSProperties}>
          <p className="eyebrow">Fit analysis</p>
          <h1 className="display h-lg">
            The cuts that <em>flatter you</em>
          </h1>
        </div>
        <p className="muted" style={{ maxWidth: '30rem' }}>
          Upload a full-length photo or take one now, and add your height. Your proportions are measured on this device, and the photo
          is not saved.
        </p>
      </div>

      <div className="split">
        <div className="stack" style={{ '--gap': '20px' } as React.CSSProperties}>
          <div className="card stack" style={{ '--gap': '18px' } as React.CSSProperties}>
            <div className="field">
              <span>Style advice for</span>
              <div className="chips">
                {LINES.map((l) => (
                  <button key={l.id} className="chip" aria-pressed={line === l.id} onClick={() => changeLine(l.id)}>
                    {l.label}
                  </button>
                ))}
              </div>
            </div>
            <label className="field">
              <span>Your height in centimetres</span>
              <input
                className="input"
                type="number"
                inputMode="numeric"
                min={120}
                max={230}
                placeholder="e.g. 165"
                value={height}
                onChange={(e) => changeHeight(e.target.value)}
              />
              <small className="muted">
                {validHeight(height)
                  ? formatHeight(validHeight(height)!)
                  : 'A photo cannot show true height, so this is what your length advice is based on.'}
              </small>
            </label>
          </div>

          {photoUrl && (
            <div className="photo">
              <img src={photoUrl} alt="Your full-length photo" />
              {lines.map((l) => (
                <span
                  key={l.label}
                  className="photo__line"
                  style={{ top: `${l.y * 100}%`, left: `${l.x1 * 100}%`, width: `${(l.x2 - l.x1) * 100}%` }}
                >
                  <span>{l.label}</span>
                </span>
              ))}
            </div>
          )}
          {notice && (
            <p className="notice" role="alert">
              {notice}
            </p>
          )}
          <PhotoDrop
            icon={<ScanLine size={22} strokeWidth={1.5} />}
            title={photoUrl ? 'Use a different photo' : 'Upload a full-length photo'}
            hint="Drop a photo here or click to choose one. It stays on your device."
            camera="user"
            cameraLabel="Take a full-length photo"
            busy={busy}
            busyLabel="Measuring your proportions…"
            slim={Boolean(photoUrl)}
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

        <div className="stack" style={{ '--gap': '36px' } as React.CSSProperties}>
          <section className="card stack" style={{ '--gap': '20px' } as React.CSSProperties}>
            <div>
              <p className="eyebrow">Your shape</p>
              <h2 className="display h-lg">{guide ? guide.label : 'Not set yet'}</h2>
              <p className="muted">
                {guide ? guide.summary : 'Upload a photo to have it measured, or choose the shape closest to yours.'}
              </p>
            </div>

            {fit?.source === 'photo' && fit.ratios && (
              <div className="figures">
                <div>
                  <strong>{fit.ratios.shoulderToHip.toFixed(2)}</strong>
                  <span className="small muted">Shoulders to hips</span>
                </div>
                <div>
                  <strong>{fit.ratios.waistToHip.toFixed(2)}</strong>
                  <span className="small muted">Waist to hips</span>
                </div>
                <div>
                  <strong>{fit.ratios.legToTorso.toFixed(2)}</strong>
                  <span className="small muted">Legs to torso</span>
                </div>
              </div>
            )}

            <div className="stack" style={{ '--gap': '10px' } as React.CSSProperties}>
              <p className="small muted">
                {fit?.source === 'photo'
                  ? 'Measured from the outline in your photo. Clothing and camera angle affect it, so correct it here if it looks wrong.'
                  : 'Choose a shape yourself:'}
              </p>
              <div className="chips">
                {SHAPE_ORDER.map((shape) => (
                  <button
                    key={shape}
                    className="chip"
                    aria-pressed={fit?.shape === shape}
                    onClick={() => chooseShape(shape)}
                  >
                    {SHAPES[line][shape].label}
                  </button>
                ))}
              </div>
            </div>
          </section>

          {fit && guide && (
            <>
              <section className="stack">
                <p className="eyebrow">Your styling goal</p>
                <h3 className="display h-md">{guide.goal}</h3>
              </section>

              <AiLooks fit={fit} />

              <div className="guide">
                <section className="stack">
                  <h3 className="display h-sm">Tops</h3>
                  <ul className="ticks">{guide.tops.map((t) => <li key={t}>{t}</li>)}</ul>
                </section>
                <section className="stack">
                  <h3 className="display h-sm">Bottoms</h3>
                  <ul className="ticks">{guide.bottoms.map((t) => <li key={t}>{t}</li>)}</ul>
                </section>
                <section className="stack">
                  <h3 className="display h-sm">{LAYERS_TITLE[fit.line]}</h3>
                  <ul className="ticks">{guide.layers.map((t) => <li key={t}>{t}</li>)}</ul>
                </section>
                <section className="stack">
                  <h3 className="display h-sm">Better to skip</h3>
                  <ul className="ticks">{guide.skip.map((t) => <li key={t}>{t}</li>)}</ul>
                </section>
              </div>

              <section className="card stack" style={{ '--gap': '18px' } as React.CSSProperties}>
                <p className="eyebrow">Length & proportion</p>
                {band ? (
                  <div className="stack" style={{ '--gap': '8px' } as React.CSSProperties}>
                    <h3 className="display h-sm">
                      {HEIGHT_TIPS[band].label} · {formatHeight(fit.heightCm!)}
                    </h3>
                    <ul className="ticks">{HEIGHT_TIPS[band].tips.map((t) => <li key={t}>{t}</li>)}</ul>
                  </div>
                ) : (
                  <p className="muted">Add your height on the left to get advice on lengths and hemlines.</p>
                )}
                {fit.source === 'photo' && fit.legLine && (
                  <div className="stack" style={{ '--gap': '6px' } as React.CSSProperties}>
                    <h3 className="display h-sm">{LEG_TIPS[fit.legLine].label}</h3>
                    <p>{LEG_TIPS[fit.legLine].tip}</p>
                  </div>
                )}
              </section>
            </>
          )}
        </div>
      </div>
    </>
  )
}
