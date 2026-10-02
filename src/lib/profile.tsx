import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'
import * as db from './db'
import type { Profile, WardrobeItem } from './types'

interface StudioValue {
  profile: Profile
  items: WardrobeItem[]
  loaded: boolean
  updateProfile: (patch: Partial<Omit<Profile, 'userId'>>) => Promise<void>
  saveItems: (items: WardrobeItem[]) => Promise<void>
  removeItem: (id: string) => Promise<void>
}

const StudioContext = createContext<StudioValue | null>(null)

/** The signed-in user's style profile and wardrobe, loaded once and shared across pages. */
export function StudioProvider({ userId, children }: { userId: string; children: ReactNode }) {
  const [profile, setProfile] = useState<Profile>({ userId })
  const [items, setItems] = useState<WardrobeItem[]>([])
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    let live = true
    setLoaded(false)
    Promise.all([db.profiles.get(userId), db.wardrobe.list(userId)]).then(([p, list]) => {
      if (!live) return
      setProfile(p)
      setItems(list)
      setLoaded(true)
    })
    return () => {
      live = false
    }
  }, [userId])

  const updateProfile = useCallback(
    async (patch: Partial<Omit<Profile, 'userId'>>) => {
      const next = { ...(await db.profiles.get(userId)), ...patch }
      await db.profiles.put(next)
      setProfile(next)
    },
    [userId],
  )

  const saveItems = useCallback(async (changed: WardrobeItem[]) => {
    await Promise.all(changed.map(db.wardrobe.put))
    setItems((current) => {
      const ids = new Set(changed.map((i) => i.id))
      return [...changed, ...current.filter((i) => !ids.has(i.id))].sort((a, b) => b.createdAt - a.createdAt)
    })
  }, [])

  const removeItem = useCallback(async (id: string) => {
    await db.wardrobe.remove(id)
    setItems((current) => current.filter((i) => i.id !== id))
  }, [])

  const value = useMemo(
    () => ({ profile, items, loaded, updateProfile, saveItems, removeItem }),
    [profile, items, loaded, updateProfile, saveItems, removeItem],
  )
  return <StudioContext.Provider value={value}>{children}</StudioContext.Provider>
}

export function useStudio(): StudioValue {
  const value = useContext(StudioContext)
  if (!value) throw new Error('useStudio must be used inside StudioProvider')
  return value
}
