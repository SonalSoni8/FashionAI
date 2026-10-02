import { ArrowRight, Shuffle } from 'lucide-react'
import { useState } from 'react'
import { Link } from 'react-router-dom'
import { PaletteStrip } from '../components/Swatches'
import { CATEGORIES, categoryLabel } from '../data/categories'
import { paletteFor } from '../data/palettes'
import { SHAPES } from '../data/shapes'
import { useAuth } from '../lib/auth'
import { useStudio } from '../lib/profile'
import { buildOutfit } from '../lib/styling'

function greeting() {
  const hour = new Date().getHours()
  return hour < 12 ? 'Good morning' : hour < 18 ? 'Good afternoon' : 'Good evening'
}

export default function Atelier() {
  const { user } = useAuth()
  const { profile, items } = useStudio()
  const { color, fit } = profile
  const palette = color && paletteFor(color.undertone, color.depth)
  const guide = fit && SHAPES[fit.line][fit.shape]
  const [outfit, setOutfit] = useState(() => buildOutfit(items, palette))

  const counts = CATEGORIES.map((c) => ({ ...c, count: items.filter((i) => i.category === c.id).length }))
    .filter((c) => c.count > 0)
    .slice(0, 4)

  return (
    <>
      <div className="page-head">
        <div className="stack" style={{ '--gap': '10px' } as React.CSSProperties}>
          <p className="eyebrow">Your atelier</p>
          <h1 className="display h-lg">
            {greeting()}, <em>{user!.name.split(' ')[0]}</em>
          </h1>
        </div>
        <p className="muted">
          {new Date().toLocaleDateString(undefined, { weekday: 'long', day: 'numeric', month: 'long' })}
        </p>
      </div>

      <div className="grid-3">
        <article className="card tile">
          <p className="eyebrow">01 · Colour</p>
          {palette ? (
            <>
              <h2 className="display h-md">{palette.season}</h2>
              <PaletteStrip palette={palette} />
              <p className="muted small">
                {color.depthLabel} skin, {color.undertone} undertone. {palette.mood}.
              </p>
            </>
          ) : (
            <>
              <h2 className="display h-md">Find the colours that suit you</h2>
              <p className="muted">Upload a selfie and get a palette built around your skin tone.</p>
            </>
          )}
          <Link to="/colour" className="link tile__foot" style={{ alignSelf: 'flex-start' }}>
            {palette ? 'See my palette' : 'Analyse my colours'} <ArrowRight size={14} strokeWidth={1.5} />
          </Link>
        </article>

        <article className="card tile">
          <p className="eyebrow">02 · Fit</p>
          {guide ? (
            <>
              <h2 className="display h-md">{guide.label}</h2>
              <p>{guide.goal}</p>
              <p className="muted small">{guide.summary}</p>
            </>
          ) : (
            <>
              <h2 className="display h-md">Find the cuts that flatter you</h2>
              <p className="muted">Upload a full-length photo and get advice for your shape and height.</p>
            </>
          )}
          <Link to="/fit" className="link tile__foot" style={{ alignSelf: 'flex-start' }}>
            {guide ? 'See my fit guide' : 'Analyse my fit'} <ArrowRight size={14} strokeWidth={1.5} />
          </Link>
        </article>

        <article className="card tile">
          <p className="eyebrow">03 · Wardrobe</p>
          {items.length ? (
            <>
              <h2 className="display h-md">
                {items.length} {items.length === 1 ? 'piece' : 'pieces'}
              </h2>
              <ul className="ticks">
                {counts.map((c) => (
                  <li key={c.id}>
                    {c.label} · {c.count}
                  </li>
                ))}
              </ul>
            </>
          ) : (
            <>
              <h2 className="display h-md">Bring your wardrobe in</h2>
              <p className="muted">Photograph your clothes and accessories so you always know what you own.</p>
            </>
          )}
          <Link to="/wardrobe" className="link tile__foot" style={{ alignSelf: 'flex-start' }}>
            {items.length ? 'Open my wardrobe' : 'Add my first pieces'} <ArrowRight size={14} strokeWidth={1.5} />
          </Link>
        </article>
      </div>

      <section className="stack" style={{ '--gap': '24px', marginTop: 72 } as React.CSSProperties}>
        <div className="row between">
          <div className="stack" style={{ '--gap': '8px' } as React.CSSProperties}>
            <p className="eyebrow">Today’s edit</p>
            <h2 className="display h-lg">
              An outfit from <em>your own</em> wardrobe
            </h2>
          </div>
          {outfit && (
            <button className="btn btn--ghost btn--small" onClick={() => setOutfit(buildOutfit(items, palette))}>
              <Shuffle size={14} strokeWidth={1.5} /> Another idea
            </button>
          )}
        </div>

        {outfit ? (
          <ul className="outfit">
            {outfit.pieces.map((piece) => (
              <li key={piece.id} className="piece">
                <div className="piece__img">
                  <img src={piece.image} alt={piece.name} />
                </div>
                <p className="piece__name" style={{ marginTop: 10 }}>
                  {piece.name}
                </p>
                <p className="small muted">{categoryLabel(piece.category)}</p>
              </li>
            ))}
          </ul>
        ) : (
          <div className="empty">
            <p className="muted">
              Add at least one top and one bottom, or a dress, to your wardrobe and outfit ideas will appear here.
            </p>
          </div>
        )}
      </section>
    </>
  )
}
