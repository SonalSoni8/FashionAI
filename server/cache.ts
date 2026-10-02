import { mkdir, readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

// Generated looks, model images and shop results are kept on disk so a paid
// request is never made twice for the same thing, even across restarts.
const DIR = path.join(path.dirname(fileURLToPath(import.meta.url)), '.cache')

const file = (name: string) => path.join(DIR, name)

export async function readCached(name: string): Promise<Buffer | null> {
  return readFile(file(name)).catch(() => null)
}

export async function writeCached(name: string, data: Buffer | string): Promise<void> {
  await mkdir(path.dirname(file(name)), { recursive: true })
  await writeFile(file(name), data)
}

export async function readJson<T>(name: string): Promise<T | null> {
  const raw = await readCached(name)
  return raw ? (JSON.parse(raw.toString('utf8')) as T) : null
}

export const writeJson = (name: string, value: unknown) => writeCached(name, JSON.stringify(value))

const inFlight = new Map<string, Promise<unknown>>()

/** Run `work` once per key at a time; concurrent callers share the same promise. */
export function once<T>(key: string, work: () => Promise<T>): Promise<T> {
  const running = inFlight.get(key) as Promise<T> | undefined
  if (running) return running
  const started = work().finally(() => inFlight.delete(key))
  inFlight.set(key, started)
  return started
}
