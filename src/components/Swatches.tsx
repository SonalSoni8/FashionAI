import type { Palette, Shade } from '../data/palettes'

interface Props {
  shades: Shade[]
  small?: boolean
  avoid?: boolean
}

export function Swatches({ shades, small, avoid }: Props) {
  return (
    <ul className={small ? 'swatches swatches--small' : 'swatches'}>
      {shades.map((shade) => (
        <li key={shade.name} className={avoid ? 'swatch swatch--avoid' : 'swatch'}>
          <div className="swatch__colour" style={{ background: shade.hex }} />
          <div className="swatch__name">{shade.name}</div>
          {!small && <div className="swatch__hex">{shade.hex}</div>}
        </li>
      ))}
    </ul>
  )
}

/** A flat band of a palette's best colours, used as a compact preview. */
export function PaletteStrip({ palette }: { palette: Palette }) {
  return (
    <div className="strip" role="img" aria-label={`${palette.season} colours`}>
      {palette.best.map((shade) => (
        <span key={shade.name} style={{ background: shade.hex }} title={shade.name} />
      ))}
    </div>
  )
}
