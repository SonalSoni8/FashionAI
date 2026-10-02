import { ArrowRight } from 'lucide-react'
import { Link } from 'react-router-dom'
import { PALETTES } from '../data/palettes'
import { useAuth } from '../lib/auth'

const FEATURES = [
  {
    no: '01',
    title: 'Your colours',
    text: 'Upload a selfie. Aura reads your skin tone and undertone, then gives you the shades that light up your face, the neutrals to build on, and the ones to wear away from it.',
  },
  {
    no: '02',
    title: 'Your cut',
    text: 'Add a full-length photo and your height. Aura reads your proportions and tells you which silhouettes, necklines and lengths work for your shape.',
  },
  {
    no: '03',
    title: 'Your wardrobe',
    text: 'Photograph your clothes, shoes and accessories once. Everything you own lives in one place, sorted, searchable and ready to be styled into outfits.',
  },
]

const RIBBON = ['Colour analysis', 'Body proportions', 'Digital wardrobe', 'Outfit ideas', 'Private by design']

export default function Landing() {
  const { user } = useAuth()
  const start = user ? '/atelier' : '/join'
  const sample = PALETTES.find((p) => p.id === 'warm-medium')!

  return (
    <>
      <header className="topbar">
        <div className="wrap topbar__inner">
          <Link to="/" className="wordmark">
            AURA
          </Link>
          <div className="row" style={{ '--gap': '20px' } as React.CSSProperties}>
            {user ? (
              <Link to="/atelier" className="btn btn--small">
                Open my atelier
              </Link>
            ) : (
              <>
                <Link to="/login" className="link">
                  Sign in
                </Link>
                <Link to="/join" className="btn btn--small">
                  Join
                </Link>
              </>
            )}
          </div>
        </div>
      </header>

      <main>
        <section className="wrap hero">
          <div className="stack hero__copy">
            <p className="eyebrow">Personal atelier · Colour · Cut · Wardrobe</p>
            <h1 className="display h-xl">
              Dress like you <em>know</em> yourself.
            </h1>
            <p className="lede">
              Aura studies your colouring and your proportions, then keeps your whole wardrobe in one place, so getting
              dressed stops being a guess.
            </p>
            <div className="row" style={{ '--gap': '24px' } as React.CSSProperties}>
              <Link to={start} className="btn">
                Begin your analysis <ArrowRight size={16} strokeWidth={1.5} />
              </Link>
              {!user && (
                <Link to="/login" className="link">
                  I already have an account
                </Link>
              )}
            </div>
          </div>

          <figure className="hero__figure">
            <img src="/images/hero.png" alt="A woman in a white shirt and light jeans standing beside an arched mirror" />
            <figcaption className="hero__card">
              <p className="eyebrow">Sample result</p>
              <p className="display h-sm" style={{ marginTop: 6 }}>
                {sample.season}
              </p>
              <div className="strip">
                {sample.best.slice(0, 6).map((s) => (
                  <span key={s.name} style={{ background: s.hex }} />
                ))}
              </div>
            </figcaption>
          </figure>
        </section>

        <div className="ribbon" aria-hidden="true">
          <div className="ribbon__track">
            {[...RIBBON, ...RIBBON, ...RIBBON, ...RIBBON].map((word, i) => (
              <span key={i}>{word}</span>
            ))}
          </div>
        </div>

        <section className="wrap" style={{ padding: '96px 24px' }}>
          <div className="stack" style={{ '--gap': '14px', marginBottom: 56 } as React.CSSProperties}>
            <p className="eyebrow">How it works</p>
            <h2 className="display h-lg">
              Three steps to a wardrobe that <em>works</em>.
            </h2>
          </div>
          <div className="grid-3" style={{ gap: 40 }}>
            {FEATURES.map((f) => (
              <article key={f.no} className="stack feature">
                <span className="feature__no">{f.no}</span>
                <h3 className="display h-md">{f.title}</h3>
                <p className="muted">{f.text}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="band">
          <div className="wrap stack" style={{ '--gap': '28px', alignItems: 'center' } as React.CSSProperties}>
            <p className="eyebrow" style={{ color: '#cfc4b6' }}>
              Private by design
            </p>
            <h2 className="display h-lg" style={{ maxWidth: '20ch' }}>
              Your photos are analysed <em>on your device</em> and never uploaded.
            </h2>
            <Link to={start} className="btn">
              Create your profile
            </Link>
          </div>
        </section>
      </main>

      <footer className="wrap footer row between">
        <span className="wordmark" style={{ fontSize: '1rem' }}>
          AURA
        </span>
        <span>Colour and fit results are styling guidance, not a rule.</span>
      </footer>
    </>
  )
}
