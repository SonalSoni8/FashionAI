import { useState, type FormEvent } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../lib/auth'

export default function Auth({ mode }: { mode: 'login' | 'join' }) {
  const { user, signIn, signUp } = useAuth()
  const navigate = useNavigate()
  const from = (useLocation().state as { from?: string } | null)?.from ?? '/atelier'
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const joining = mode === 'join'

  if (user) return <Navigate to={from} replace />

  async function submit(e: FormEvent) {
    e.preventDefault()
    setError('')
    setBusy(true)
    try {
      if (joining) await signUp(name, email, password)
      else await signIn(email, password)
      navigate(from, { replace: true })
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Something went wrong. Please try again.')
      setBusy(false)
    }
  }

  return (
    <div className="auth">
      <div className="auth__art">
        <img src="/images/hero.png" alt="" />
        <blockquote>“Style is knowing who you are, and wearing it.”</blockquote>
      </div>

      <div className="auth__panel">
        <form className="stack auth__form" onSubmit={submit}>
          <Link to="/" className="wordmark">
            AURA
          </Link>
          <div className="stack" style={{ '--gap': '8px', margin: '20px 0 8px' } as React.CSSProperties}>
            <h1 className="display h-lg">{joining ? 'Create your atelier' : 'Welcome back'}</h1>
            <p className="muted">
              {joining
                ? 'One account for your colours, your fit and your wardrobe.'
                : 'Sign in to your colours, your fit and your wardrobe.'}
            </p>
          </div>

          {joining && (
            <label className="field">
              <span>Name</span>
              <input className="input" value={name} onChange={(e) => setName(e.target.value)} autoComplete="name" required />
            </label>
          )}
          <label className="field">
            <span>Email</span>
            <input
              className="input"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoComplete="email"
              required
            />
          </label>
          <label className="field">
            <span>Password</span>
            <input
              className="input"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete={joining ? 'new-password' : 'current-password'}
              minLength={joining ? 8 : undefined}
              required
            />
            {joining && <small className="muted">At least 8 characters.</small>}
          </label>

          {error && (
            <p className="notice" role="alert">
              {error}
            </p>
          )}

          <button className="btn" disabled={busy}>
            {busy ? 'One moment…' : joining ? 'Create account' : 'Sign in'}
          </button>

          <p className="small muted">
            {joining ? 'Already a member? ' : 'New to Aura? '}
            <Link to={joining ? '/login' : '/join'} className="link" state={{ from }}>
              {joining ? 'Sign in' : 'Create an account'}
            </Link>
          </p>
        </form>
      </div>
    </div>
  )
}
