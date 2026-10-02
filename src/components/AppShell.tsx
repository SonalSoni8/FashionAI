import { LayoutGrid, LogOut, Palette, Ruler, Shirt } from 'lucide-react'
import { Link, NavLink, Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth } from '../lib/auth'
import { StudioProvider, useStudio } from '../lib/profile'

const LINKS = [
  { to: '/atelier', label: 'Atelier', icon: LayoutGrid },
  { to: '/colour', label: 'Colour', icon: Palette },
  { to: '/fit', label: 'Fit', icon: Ruler },
  { to: '/wardrobe', label: 'Wardrobe', icon: Shirt },
]

function Content() {
  const { loaded } = useStudio()
  return <main className="wrap page">{loaded && <Outlet />}</main>
}

/** Frame for the signed-in area: header, navigation, and the user's data. */
export default function AppShell() {
  const { user, signOut } = useAuth()
  const location = useLocation()
  if (!user) return <Navigate to="/login" replace state={{ from: location.pathname }} />

  return (
    <StudioProvider userId={user.id}>
      <header className="topbar">
        <div className="wrap topbar__inner">
          <Link to="/atelier" className="wordmark">
            AURA
          </Link>
          <nav className="nav" aria-label="Main">
            {LINKS.map(({ to, label, icon: Icon }) => (
              <NavLink key={to} to={to}>
                <Icon size={18} strokeWidth={1.5} />
                {label}
              </NavLink>
            ))}
          </nav>
          <div className="row">
            <span className="small muted">{user.name}</span>
            <button className="icon-btn" onClick={signOut} aria-label="Sign out" title="Sign out">
              <LogOut size={16} strokeWidth={1.5} />
            </button>
          </div>
        </div>
      </header>
      <Content />
    </StudioProvider>
  )
}
