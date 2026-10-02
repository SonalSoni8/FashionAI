import { Navigate, Route, Routes } from 'react-router-dom'
import AppShell from './components/AppShell'
import { useAuth } from './lib/auth'
import Atelier from './pages/Atelier'
import Auth from './pages/Auth'
import Colour from './pages/Colour'
import Fit from './pages/Fit'
import Landing from './pages/Landing'
import Wardrobe from './pages/Wardrobe'

export default function App() {
  const { ready } = useAuth()
  if (!ready) return null

  return (
    <Routes>
      <Route path="/" element={<Landing />} />
      <Route path="/login" element={<Auth mode="login" />} />
      <Route path="/join" element={<Auth mode="join" />} />
      <Route element={<AppShell />}>
        <Route path="/atelier" element={<Atelier />} />
        <Route path="/colour" element={<Colour />} />
        <Route path="/fit" element={<Fit />} />
        <Route path="/wardrobe" element={<Wardrobe />} />
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
