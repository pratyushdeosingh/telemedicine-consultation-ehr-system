import { Navigate, Route, Routes } from 'react-router-dom'
import { AppointmentsPage } from './pages/AppointmentsPage.jsx'
import { BillingPage } from './pages/BillingPage.jsx'
import { OverviewPage } from './pages/OverviewPage.jsx'
import { PatientsPage } from './pages/PatientsPage.jsx'
import { PrescriptionsPage } from './pages/PrescriptionsPage.jsx'
import { SystemFlowPage } from './pages/SystemFlowPage.jsx'

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<OverviewPage />} />
      <Route path="/patients" element={<PatientsPage />} />
      <Route path="/appointments" element={<AppointmentsPage />} />
      <Route path="/prescriptions" element={<PrescriptionsPage />} />
      <Route path="/billing" element={<BillingPage />} />
      <Route path="/system-flow" element={<SystemFlowPage />} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
