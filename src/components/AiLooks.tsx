import { RefreshCw, ShoppingBag, Sparkles, Star } from 'lucide-react'
import { useEffect, useMemo, useState } from 'react'
import {
  COUNTRIES,
  SKIN_DEPTHS,
  type ApiStatus,
  type CountryCode,
  type Look,
  type Product,
  type SkinDepth,
  type StyleBrief,
} from '../../shared/looks'
import { createLooks, getLookImage, getStatus, shopPiece } from '../lib/api'
import { useStudio } from '../lib/profile'
import type { FitProfile } from '../lib/types'

function guessCountry(): CountryCode {
  const region = navigator.language.split('-')[1]?.toLowerCase()
  return COUNTRIES.find((c) => c.code === region)?.code ?? 'us'
}

const message = (err: unknown) => (err instanceof Error ? err.message : 'Something went wrong. Please try again.')

/** The look worn by an AI model with the user's body shape. Generated on first view. */
function ModelPhoto({ look, enabled }: { look: Look; enabled: boolean }) {
  const [url, setUrl] = useState('')
  const [error, setError] = useState('')
  const [attempt, setAttempt] = useState(0)

  useEffect(() => {
    if (!enabled) return
    let live = true
    let made = ''
    setUrl('')
    setError('')
    getLookImage(look.id)
      .then((next) => {
        made = next
        if (live) setUrl(next)
        else URL.revokeObjectURL(next)
      })
      .catch((err) => live && setError(message(err)))
    return () => {
      live = false
      if (made) URL.revokeObjectURL(made)
    }
  }, [look.id, enabled, attempt])

  if (url) return <img className="look__photo" src={url} alt={`AI model wearing ${look.title}`} />

  return (
    <div className="look__photo look__photo--empty">
      {!enabled ? (
        <p className="small muted">Model photos are not set up yet. Add GEMINI_API_KEY to the .env file.</p>
      ) : error ? (
        <>
          <p className="small">{error}</p>
          <button className="link" onClick={() => setAttempt((n) => n + 1)}>
            Try again
          </button>
        </>
      ) : (
        <>
          <span className="spinner" />
          <p className="small muted">Dressing your model…</p>
        </>
      )}
    </div>
  )
}

/** Real products for one piece of a look, fetched when the shelf is opened. */
function ShopShelf({ lookId, index }: { lookId: string; index: number }) {
  const [products, setProducts] = useState<Product[] | null>(null)
  const [error, setError] = useState('')

  useEffect(() => {
    let live = true
    shopPiece(lookId, index)
      .then((found) => live && setProducts(found))
      .catch((err) => live && setError(message(err)))
    return () => {
      live = false
    }
  }, [lookId, index])

  if (error) return <p className="notice">{error}</p>
  if (!products) {
    return (
      <p className="row small muted">
        <span className="spinner" /> Searching the shops…
      </p>
    )
  }
  if (products.length === 0) return <p className="small muted">No matching products were found in your country.</p>

  return (
    <ul className="shelf">
      {products.map((product) => (
        <li key={product.link}>
          <a className="product" href={product.link} target="_blank" rel="noopener noreferrer">
            <img src={product.thumbnail} alt="" loading="lazy" referrerPolicy="no-referrer" />
            <span className="product__title">{product.title}</span>
            <span className="product__price">{product.price}</span>
            <span className="small muted">
              {product.source}
              {product.rating ? (
                <>
                  {' · '}
                  <Star size={11} strokeWidth={1.5} fill="currentColor" /> {product.rating}
                </>
              ) : null}
            </span>
          </a>
        </li>
      ))}
    </ul>
  )
}

function LookCard({ look, status }: { look: Look; status: ApiStatus }) {
  const [open, setOpen] = useState<number | null>(null)

  return (
    <article className="look">
      <ModelPhoto look={look} enabled={status.images} />
      <div className="stack" style={{ '--gap': '14px' } as React.CSSProperties}>
        <div>
          <span className="tag">{look.occasion}</span>
          <h4 className="display h-md" style={{ margin: '10px 0 6px' }}>
            {look.title}
          </h4>
          <p className="muted">{look.why}</p>
        </div>
        <ul className="look__pieces">
          {look.pieces.map((piece, index) => (
            <li key={piece.name}>
              <div className="look__piece">
                <span className="dot" style={{ background: piece.colourHex }} />
                <span>
                  {piece.name}
                  <span className="small muted"> · {piece.colour}</span>
                </span>
                {status.shop && (
                  <button
                    className="link"
                    aria-expanded={open === index}
                    onClick={() => setOpen(open === index ? null : index)}
                  >
                    <ShoppingBag size={13} strokeWidth={1.5} /> {open === index ? 'Hide' : 'Shop'}
                  </button>
                )}
              </div>
              {open === index && <ShopShelf lookId={look.id} index={index} />}
            </li>
          ))}
        </ul>
      </div>
    </article>
  )
}

/**
 * Outfits written by the AI stylist for the user's shape, height and palette,
 * each shown on a generated model of the same shape with products to buy.
 */
export default function AiLooks({ fit }: { fit: FitProfile }) {
  const { profile, updateProfile } = useStudio()
  const [status, setStatus] = useState<ApiStatus | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    getStatus()
      .then(setStatus)
      .catch((err) => setError(message(err)))
  }, [])

  const country = profile.country ?? guessCountry()
  const color = profile.color
  const brief = useMemo<StyleBrief>(
    () => ({
      shape: fit.shape,
      line: fit.line,
      heightCm: fit.heightCm,
      legLine: fit.source === 'photo' ? fit.legLine : undefined,
      paletteId: color && `${color.undertone}-${color.depth}`,
      skinDepth: SKIN_DEPTHS.find((d): d is SkinDepth => d === color?.depthLabel),
      country,
    }),
    [fit, color, country],
  )
  const basis = JSON.stringify(brief)
  const saved = profile.looks
  const stale = saved && saved.basis !== basis

  async function generate() {
    setBusy(true)
    setError('')
    try {
      const items = await createLooks(brief)
      await updateProfile({ country, looks: { basis, generatedAt: Date.now(), items } })
    } catch (err) {
      setError(message(err))
    } finally {
      setBusy(false)
    }
  }

  return (
    <section className="stack" style={{ '--gap': '22px' } as React.CSSProperties}>
      <div className="row between" style={{ alignItems: 'flex-end' }}>
        <div className="stack" style={{ '--gap': '6px' } as React.CSSProperties}>
          <p className="eyebrow">Styled for you by AI</p>
          <h3 className="display h-md">Outfits on a model with your shape</h3>
        </div>
        <label className="field">
          <span>Shopping in</span>
          <select
            className="input"
            value={country}
            disabled={busy}
            onChange={(e) => updateProfile({ country: e.target.value as CountryCode })}
          >
            {COUNTRIES.map((c) => (
              <option key={c.code} value={c.code}>
                {c.label}
              </option>
            ))}
          </select>
        </label>
      </div>

      {error && (
        <p className="notice" role="alert">
          {error}
        </p>
      )}
      {status && !status.stylist && (
        <p className="notice">
          The AI stylist is not set up yet. Add ANTHROPIC_API_KEY to the .env file and restart the server.
        </p>
      )}
      {status?.stylist && !status.shop && (
        <p className="small muted">Shopping is not set up yet. Add SERPAPI_KEY to the .env file to see products.</p>
      )}

      {busy ? (
        <div className="empty stack" style={{ alignItems: 'center' }}>
          <span className="spinner" />
          <p className="muted">Your stylist is putting outfits together. This takes about half a minute.</p>
        </div>
      ) : saved && status ? (
        <>
          {stale && (
            <p className="notice">
              Your shape, height, colours or country changed since these were styled. Style new outfits to match.
            </p>
          )}
          {saved.items.map((look) => (
            <LookCard key={look.id} look={look} status={status} />
          ))}
          <button className="btn btn--ghost" style={{ alignSelf: 'flex-start' }} onClick={generate} disabled={!status.stylist}>
            <RefreshCw size={14} strokeWidth={1.5} /> Style new outfits
          </button>
        </>
      ) : (
        <div className="card stack" style={{ '--gap': '16px', alignItems: 'flex-start' } as React.CSSProperties}>
          <p>
            Get three complete outfits chosen for your shape{fit.heightCm ? ', height' : ''}
            {color ? ' and colours' : ''}. Each one is shown on an AI-generated model with your body type, with real
            products you can buy.
          </p>
          <button className="btn" onClick={generate} disabled={!status?.stylist}>
            <Sparkles size={15} strokeWidth={1.5} /> Style my outfits
          </button>
        </div>
      )}

      <p className="small muted">
        Only your shape, height, skin depth, palette and country are sent to the AI services. Your photos never leave
        this device.
      </p>
    </section>
  )
}
