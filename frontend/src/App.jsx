import { Navigate, Route, Routes } from 'react-router-dom'
import { useEffect, useState } from 'react'
import { api, isDemoMode } from './api/client.js'
import { AppShell } from './components/AppShell.jsx'
import { LoginScreen } from './components/LoginScreen.jsx'
import { AppointmentsPage } from './pages/AppointmentsPage.jsx'
import { BillingPage } from './pages/BillingPage.jsx'
import { OverviewPage } from './pages/OverviewPage.jsx'
import { PatientsPage } from './pages/PatientsPage.jsx'
import { PrescriptionsPage } from './pages/PrescriptionsPage.jsx'
import { SystemFlowPage } from './pages/SystemFlowPage.jsx'

export default function App() {
  const [session, setSession] = useState(isDemoMode ? 'ready' : 'checking')

  useEffect(() => {
    if (isDemoMode) return
    api.getSession()
      .then((result) => setSession(result.authenticated ? 'ready' : 'login'))
      .catch(() => setSession('error'))
  }, [])

  if (session === 'checking') return <main className="login-screen">Checking session…</main>
  if (session === 'error') return (
    <main className="login-screen">
      <div className="login-card">
        <h1>Connection unavailable</h1>
        <p>Could not check the demo session.</p>
        <button type="button" onClick={() => window.location.reload()}>Try again</button>
      </div>
    </main>
  )
  if (session === 'login') return <LoginScreen onLogin={async (password) => {
    await api.login(password)
    setSession('ready')
  }} />

  return (
    <Routes>
      <Route element={<AppShell onLogout={async () => {
        await api.logout()
        setSession('login')
      }} />}>
        <Route path="/" element={<OverviewPage />} />
        <Route path="/patients" element={<PatientsPage />} />
        <Route path="/appointments" element={<AppointmentsPage />} />
        <Route path="/prescriptions" element={<PrescriptionsPage />} />
        <Route path="/billing" element={<BillingPage />} />
        <Route path="/system-flow" element={<SystemFlowPage />} />
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
