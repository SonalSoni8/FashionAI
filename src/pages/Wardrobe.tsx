import { Heart, ImagePlus, Search, Trash2 } from 'lucide-react'
import { useMemo, useState } from 'react'
import Modal from '../components/Modal'
import PhotoDrop from '../components/PhotoDrop'
import PieceForm from '../components/PieceForm'
import { CATEGORIES, categoryLabel } from '../data/categories'
import { paletteFor } from '../data/palettes'
import { useAuth } from '../lib/auth'
import { dominantColor, guessCategory, nameFromFile } from '../lib/garment'
import { loadPhoto, toJpegUrl } from '../lib/image'
import { useStudio } from '../lib/profile'
import { paletteFit } from '../lib/styling'
import type { Category, WardrobeItem } from '../lib/types'

const named = (item: WardrobeItem): WardrobeItem => ({
  ...item,
  name: item.name.trim() || `Untitled · ${categoryLabel(item.category)}`,
})

export default function Wardrobe() {
  const { user } = useAuth()
  const { profile, items, saveItems, removeItem } = useStudio()
  const palette = profile.color && paletteFor(profile.color.undertone, profile.color.depth)

  const [category, setCategory] = useState<Category | 'all'>('all')
  const [query, setQuery] = useState('')
  const [onlyFavourites, setOnlyFavourites] = useState(false)
  const [onlyPalette, setOnlyPalette] = useState(false)
  const [busy, setBusy] = useState(false)
  const [notice, setNotice] = useState('')
  const [drafts, setDrafts] = useState<WardrobeItem[]>([])
  const [editing, setEditing] = useState<WardrobeItem | null>(null)

  const fits = useMemo(
    () => new Map(items.map((i) => [i.id, palette ? paletteFit(i.colorHex, palette) : 'neutral'])),
    [items, palette],
  )

  const visible = items.filter(
    (i) =>
      (category === 'all' || i.category === category) &&
      (!onlyFavourites || i.favorite) &&
      (!onlyPalette || fits.get(i.id) === 'match') &&
      `${i.name} ${i.notes}`.toLowerCase().includes(query.trim().toLowerCase()),
  )

  async function onFiles(files: File[]) {
    setBusy(true)
    setNotice('')
    const made: WardrobeItem[] = []
    let failed = 0
    for (const [index, file] of files.entries()) {
      try {
        const canvas = await loadPhoto(file, 800)
        made.push({
          id: crypto.randomUUID(),
          userId: user!.id,
          name: nameFromFile(file.name),
          category: guessCategory(file.name),
          colorHex: dominantColor(canvas),
          image: toJpegUrl(canvas, 0.82),
          favorite: false,
          notes: '',
          createdAt: Date.now() + index,
        })
      } catch {
        failed++
      }
    }
    setBusy(false)
    setDrafts(made)
    if (failed) setNotice(`${failed} ${failed === 1 ? 'file' : 'files'} could not be read. Use JPG, PNG or WebP photos.`)
  }

  async function saveDrafts() {
    try {
      await saveItems(drafts.map(named))
      setDrafts([])
    } catch {
      setNotice('Your device is out of storage space for this site, so those pieces were not saved.')
      setDrafts([])
    }
  }

  async function saveEdit() {
    if (!editing) return
    await saveItems([named(editing)])
    setEditing(null)
  }

  async function remove() {
    if (!editing || !window.confirm(`Remove "${editing.name}" from your wardrobe?`)) return
    await removeItem(editing.id)
    setEditing(null)
  }

  return (
    <>
      <div className="page-head">
        <div className="stack" style={{ '--gap': '10px' } as React.CSSProperties}>
          <p className="eyebrow">Digital wardrobe</p>
          <h1 className="display h-lg">
            Everything you <em>own</em>
          </h1>
        </div>
        <p className="muted">
          {items.length === 0
            ? 'Nothing here yet.'
            : `${items.length} ${items.length === 1 ? 'piece' : 'pieces'} · ${items.filter((i) => i.favorite).length} favourites`}
        </p>
      </div>

      <div className="stack" style={{ '--gap': '16px', marginBottom: 36 } as React.CSSProperties}>
        <PhotoDrop
          icon={<ImagePlus size={22} strokeWidth={1.5} />}
          title="Add pieces"
          hint="Drop photos of clothes, shoes, bags or jewellery, or click to choose. You can add many at once."
          busy={busy}
          camera="environment"
          cameraLabel="Take a photo of a piece"
          busyLabel="Reading your photos…"
          multiple
          slim
          onFiles={onFiles}
        />
        {notice && (
          <p className="notice" role="alert">
            {notice}
          </p>
        )}
      </div>

      {items.length > 0 && (
        <div className="toolbar">
          <div className="chips">
            <button className="chip" aria-pressed={category === 'all'} onClick={() => setCategory('all')}>
              All<span className="count">{items.length}</span>
            </button>
            {CATEGORIES.map((c) => {
              const count = items.filter((i) => i.category === c.id).length
              return count ? (
                <button key={c.id} className="chip" aria-pressed={category === c.id} onClick={() => setCategory(c.id)}>
                  {c.label}
                  <span className="count">{count}</span>
                </button>
              ) : null
            })}
          </div>
          <div className="chips">
            <button className="chip" aria-pressed={onlyFavourites} onClick={() => setOnlyFavourites((v) => !v)}>
              Favourites
            </button>
            {palette && (
              <button className="chip" aria-pressed={onlyPalette} onClick={() => setOnlyPalette((v) => !v)}>
                In my palette
              </button>
            )}
          </div>
          <label className="search">
            <Search size={16} strokeWidth={1.5} />
            <input
              className="input"
              type="search"
              placeholder="Search your wardrobe"
              aria-label="Search your wardrobe"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </label>
        </div>
      )}

      {items.length === 0 ? (
        <div className="empty stack" style={{ alignItems: 'center' }}>
          <h2 className="display h-md">Start with what you wear most</h2>
          <p className="muted" style={{ maxWidth: '32rem' }}>
            Lay each piece flat or hang it against a plain wall, take a photo, and add it above. Aura picks out its
            colour and files it for you.
          </p>
        </div>
      ) : visible.length === 0 ? (
        <div className="empty">
          <p className="muted">No pieces match those filters.</p>
        </div>
      ) : (
        <ul className="closet">
          {visible.map((item) => (
            <li key={item.id} className="piece">
              <button className="piece__img" onClick={() => setEditing(item)} aria-label={`Edit ${item.name}`}>
                <img src={item.image} alt={item.name} loading="lazy" />
              </button>
              <button
                className="icon-btn piece__heart"
                aria-pressed={item.favorite}
                aria-label={item.favorite ? 'Remove from favourites' : 'Add to favourites'}
                onClick={() => saveItems([{ ...item, favorite: !item.favorite }])}
              >
                <Heart size={16} strokeWidth={1.5} />
              </button>
              <div className="piece__meta">
                <div>
                  <p className="piece__name">{item.name}</p>
                  <p className="small muted">{categoryLabel(item.category)}</p>
                </div>
                <span className="dot" style={{ background: item.colorHex }} title={item.colorHex} />
              </div>
              {fits.get(item.id) === 'match' && <span className="tag tag--ok">In your palette</span>}
              {fits.get(item.id) === 'clash' && <span className="tag tag--warn">Wear away from face</span>}
            </li>
          ))}
        </ul>
      )}

      {drafts.length > 0 && (
        <Modal
          title={`Review ${drafts.length} new ${drafts.length === 1 ? 'piece' : 'pieces'}`}
          onClose={() => setDrafts([])}
          footer={
            <>
              <button className="link" onClick={() => setDrafts([])}>
                Discard
              </button>
              <button className="btn" onClick={saveDrafts}>
                Add to wardrobe
              </button>
            </>
          }
        >
          {drafts.map((draft) => (
            <PieceForm
              key={draft.id}
              item={draft}
              onChange={(next) => setDrafts((all) => all.map((d) => (d.id === next.id ? next : d)))}
            />
          ))}
        </Modal>
      )}

      {editing && (
        <Modal
          title="Edit piece"
          onClose={() => setEditing(null)}
          footer={
            <>
              <button className="link" onClick={remove}>
                <Trash2 size={14} strokeWidth={1.5} /> Remove
              </button>
              <button className="btn" onClick={saveEdit}>
                Save
              </button>
            </>
          }
        >
          <PieceForm item={editing} onChange={setEditing} />
        </Modal>
      )}
    </>
  )
}
