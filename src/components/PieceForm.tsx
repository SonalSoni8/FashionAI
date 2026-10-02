import { CATEGORIES } from '../data/categories'
import type { Category, WardrobeItem } from '../lib/types'

interface Props {
  item: WardrobeItem
  onChange: (item: WardrobeItem) => void
}

/** Editable details for one wardrobe piece, shown beside its photo. */
export default function PieceForm({ item, onChange }: Props) {
  return (
    <div className="draft">
      <img src={item.image} alt="" />
      <div className="draft__fields">
        <label className="field wide">
          <span>Name</span>
          <input
            className="input"
            value={item.name}
            placeholder="e.g. White linen shirt"
            onChange={(e) => onChange({ ...item, name: e.target.value })}
          />
        </label>
        <label className="field">
          <span>Category</span>
          <select
            className="input"
            value={item.category}
            onChange={(e) => onChange({ ...item, category: e.target.value as Category })}
          >
            {CATEGORIES.map((c) => (
              <option key={c.id} value={c.id}>
                {c.label}
              </option>
            ))}
          </select>
        </label>
        <label className="field">
          <span>Main colour</span>
          <div className="colour-input">
            <input
              type="color"
              value={item.colorHex}
              onChange={(e) => onChange({ ...item, colorHex: e.target.value })}
              aria-label="Main colour"
            />
            <small className="muted">Detected from the photo. Click to correct it.</small>
          </div>
        </label>
        <label className="field wide">
          <span>Notes</span>
          <input
            className="input"
            value={item.notes}
            placeholder="Brand, size, where you wear it…"
            onChange={(e) => onChange({ ...item, notes: e.target.value })}
          />
        </label>
      </div>
    </div>
  )
}
