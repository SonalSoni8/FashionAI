import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'
import * as db from './db'
import type { User } from './types'

const SESSION_KEY = 'aura.session'

interface AuthValue {
  user: User | null
  ready: boolean
  signUp: (name: string, email: string, password: string) => Promise<void>
  signIn: (email: string, password: string) => Promise<void>
  signOut: () => void
}

const AuthContext = createContext<AuthValue | null>(null)

const toBase64 = (bytes: Uint8Array) => btoa(String.fromCharCode(...bytes))
const fromBase64 = (text: string) => Uint8Array.from(atob(text), (c) => c.charCodeAt(0))

async function hashPassword(password: string, salt: Uint8Array): Promise<string> {
  const key = await crypto.subtle.importKey('raw', new TextEncoder().encode(password), 'PBKDF2', false, ['deriveBits'])
  const bits = await crypto.subtle.deriveBits(
    { name: 'PBKDF2', hash: 'SHA-256', salt: salt as BufferSource, iterations: 150_000 },
    key,
    256,
  )
  return toBase64(new Uint8Array(bits))
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [ready, setReady] = useState(false)

  useEffect(() => {
    const id = localStorage.getItem(SESSION_KEY)
    if (!id) return setReady(true)
    db.users
      .get(id)
      .then((found) => setUser(found ?? null))
      .finally(() => setReady(true))
  }, [])

  const start = useCallback((next: User) => {
    localStorage.setItem(SESSION_KEY, next.id)
    setUser(next)
  }, [])

  const signUp = useCallback(
    async (name: string, rawEmail: string, password: string) => {
      const email = rawEmail.trim().toLowerCase()
      if (await db.users.byEmail(email)) throw new Error('An account with that email already exists. Sign in instead.')
      const salt = crypto.getRandomValues(new Uint8Array(16))
      const next: User = {
        id: crypto.randomUUID(),
        name: name.trim(),
        email,
        salt: toBase64(salt),
        hash: await hashPassword(password, salt),
        createdAt: Date.now(),
      }
      await db.users.add(next)
      start(next)
    },
    [start],
  )

  const signIn = useCallback(
    async (rawEmail: string, password: string) => {
      const found = await db.users.byEmail(rawEmail.trim().toLowerCase())
      if (!found || (await hashPassword(password, fromBase64(found.salt))) !== found.hash) {
        throw new Error('That email and password do not match an account on this device.')
      }
      start(found)
    },
    [start],
  )

  const signOut = useCallback(() => {
    localStorage.removeItem(SESSION_KEY)
    setUser(null)
  }, [])

  const value = useMemo(() => ({ user, ready, signUp, signIn, signOut }), [user, ready, signUp, signIn, signOut])
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth(): AuthValue {
  const value = useContext(AuthContext)
  if (!value) throw new Error('useAuth must be used inside AuthProvider')
  return value
}
