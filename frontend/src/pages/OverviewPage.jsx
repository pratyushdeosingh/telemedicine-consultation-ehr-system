import { ArrowUpRight, CalendarCheck, CircleDollarSign, FileHeart, UsersRound } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '../api/client.js'
import { ErrorState, LoadingState } from '../components/DataState.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatCurrency, formatDate, toneForStatus } from '../utils/formatters.js'

const initialDashboard = { patients: [], appointments: [], prescriptions: [], billing: [] }

export function OverviewPage() {
  const { data, error, isError, isLoading, reload } = useApiResource(api.getDashboardData, initialDashboard)
  const scheduled = data.appointments.filter((item) => item.status === 'Scheduled')
  const pendingInvoices = data.billing.filter((item) => item.payment_status === 'Pending')
  const outstanding = pendingInvoices.reduce((total, item) => total + Number(item.stored_total), 0)
  const prescriptionCount = new Set(data.prescriptions.map((item) => `${item.appointment_id}:${item.prescription_no}`)).size
  const nextAppointments = [...scheduled]
    .sort((first, second) => new Date(first.appointment_date) - new Date(second.appointment_date))
    .slice(0, 4)

  return (
    <main className="page">
      <PageHeader eyebrow="Care Continuum" title="Overview" description="Review scheduled appointments, patient records, prescriptions, and outstanding invoices." />

      {isLoading && <Surface><LoadingState label="Loading overview" /></Surface>}
      {isError && <Surface><ErrorState error={error} onRetry={reload} /></Surface>}
      {!isLoading && !isError && (
        <>
          <section className="overview-grid">
            <Surface className="pulse-panel">
              <div className="pulse-copy"><span>Scheduled care</span><strong>{scheduled.length}</strong><small>scheduled appointments</small></div>
              <div className="pulse-visual" aria-hidden="true"><span /><span /><span><CalendarCheck size={23} /></span></div>
              <Link to="/appointments">Open schedule <ArrowUpRight size={16} /></Link>
            </Surface>

            <div className="overview-metrics">
              <Link className="overview-metric" to="/patients"><span><UsersRound size={17} /></span><strong>{data.patients.length}</strong><small>Patient records</small><ArrowUpRight size={15} /></Link>
              <Link className="overview-metric" to="/prescriptions"><span><FileHeart size={17} /></span><strong>{prescriptionCount}</strong><small>Prescriptions</small><ArrowUpRight size={15} /></Link>
              <Link className="overview-metric" to="/billing"><span><CircleDollarSign size={17} /></span><strong>{formatCurrency(outstanding)}</strong><small>Outstanding</small><ArrowUpRight size={15} /></Link>
            </div>
          </section>

          <section className="dashboard-lower-grid">
            <Surface className="upcoming-panel">
              <header><div><strong>Scheduled consultations</strong><small>Scheduled appointment records</small></div><Link to="/appointments">View all</Link></header>
              <div>
                {nextAppointments.map((appointment) => (
                  <article key={appointment.appointment_id}>
                    <span className="upcoming-date"><strong>{formatDate(appointment.appointment_date, { day: '2-digit', year: undefined }).split(' ')[0]}</strong><small>{formatDate(appointment.appointment_date, { month: 'short', year: undefined }).split(' ')[1]}</small></span>
                    <span><strong>{appointment.patient_name}</strong><small>Dr. {appointment.doctor_name} · {appointment.department}</small></span>
                    <StatusBadge tone={toneForStatus(appointment.status)}>{appointment.consultation_mode}</StatusBadge>
                  </article>
                ))}
              </div>
            </Surface>

            <Surface className="attention-panel">
              <span className="eyebrow">Needs attention</span>
              <h2>{pendingInvoices.length} invoices are still pending.</h2>
              <p>{formatCurrency(outstanding)} is outstanding across pending invoices.</p>
              <Link to="/billing">Review invoices <ArrowUpRight size={16} /></Link>
            </Surface>
          </section>
        </>
      )}
    </main>
  )
}
