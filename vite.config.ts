import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  // The API server (server/index.ts) holds the provider keys; the browser reaches it through this proxy.
  server: { proxy: { '/api': 'http://localhost:8787' } },
})
