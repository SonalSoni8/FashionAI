import { openDB, type DBSchema, type IDBPDatabase } from 'idb'
import type { Profile, User, WardrobeItem } from './types'

interface AuraDB extends DBSchema {
  users: { key: string; value: User; indexes: { email: string } }
  profiles: { key: string; value: Profile }
  wardrobe: { key: string; value: WardrobeItem; indexes: { userId: string } }
}

let db: Promise<IDBPDatabase<AuraDB>> | undefined

const open = () =>
  (db ??= openDB<AuraDB>('aura', 1, {
    upgrade(database) {
      database.createObjectStore('users', { keyPath: 'id' }).createIndex('email', 'email', { unique: true })
      database.createObjectStore('profiles', { keyPath: 'userId' })
      database.createObjectStore('wardrobe', { keyPath: 'id' }).createIndex('userId', 'userId')
    },
  }))

export const users = {
  get: async (id: string) => (await open()).get('users', id),
  byEmail: async (email: string) => (await open()).getFromIndex('users', 'email', email),
  add: async (user: User) => void (await (await open()).add('users', user)),
}

export const profiles = {
  get: async (userId: string): Promise<Profile> => (await (await open()).get('profiles', userId)) ?? { userId },
  put: async (profile: Profile) => void (await (await open()).put('profiles', profile)),
}

export const wardrobe = {
  list: async (userId: string) => {
    const items = await (await open()).getAllFromIndex('wardrobe', 'userId', userId)
    return items.sort((a, b) => b.createdAt - a.createdAt)
  },
  put: async (item: WardrobeItem) => void (await (await open()).put('wardrobe', item)),
  remove: async (id: string) => (await open()).delete('wardrobe', id),
}
