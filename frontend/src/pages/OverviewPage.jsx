import { ArrowUpRight, CalendarCheck, CircleDollarSign, FileHeart, UsersRound } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '../api/client.js'
import { CareContinuum } from '../components/CareContinuum.jsx'
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
  const counts = {
    patients: data.patients.length,
    appointments: data.appointments.length,
    prescriptions: prescriptionCount,
    billing: data.billing.length,
  }

  return (
    <main className="page">
      <PageHeader eyebrow="Care Continuum" title="Care, as one connected system." description="A live operational view across patient identity, consultations, treatment, and billing." />

      {isLoading && <Surface><LoadingState label="Building the clinical overview" /></Surface>}
      {isError && <Surface><ErrorState error={error} onRetry={reload} /></Surface>}
      {!isLoading && !isError && (
        <>
          <section className="overview-grid">
            <Surface className="pulse-panel">
              <div className="pulse-copy"><span>Scheduled care</span><strong>{scheduled.length}</strong><small>consultations ready</small></div>
              <div className="pulse-visual" aria-hidden="true"><span /><span /><span><CalendarCheck size={23} /></span></div>
              <Link to="/appointments">Open schedule <ArrowUpRight size={16} /></Link>
            </Surface>

            <div className="overview-metrics">
              <Link className="overview-metric" to="/patients"><span><UsersRound size={17} /></span><strong>{data.patients.length}</strong><small>Patient records</small><ArrowUpRight size={15} /></Link>
              <Link className="overview-metric" to="/prescriptions"><span><FileHeart size={17} /></span><strong>{prescriptionCount}</strong><small>Prescriptions</small><ArrowUpRight size={15} /></Link>
              <Link className="overview-metric" to="/billing"><span><CircleDollarSign size={17} /></span><strong>{formatCurrency(outstanding)}</strong><small>Outstanding</small><ArrowUpRight size={15} /></Link>
            </div>
          </section>

          <Surface className="continuum-panel">
            <header><div><span className="eyebrow">Relational journey</span><h2>One patient. Four connected records.</h2></div><Link to="/system-flow">How data moves <ArrowUpRight size={15} /></Link></header>
            <CareContinuum counts={counts} />
          </Surface>

          <section className="dashboard-lower-grid">
            <Surface className="upcoming-panel">
              <header><div><strong>Upcoming consultations</strong><small>Scheduled appointment records</small></div><Link to="/appointments">View all</Link></header>
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
              <p>The billing API currently reports {formatCurrency(outstanding)} in outstanding stored invoice value.</p>
              <Link to="/billing">Review reconciliation <ArrowUpRight size={16} /></Link>
            </Surface>
          </section>
        </>
      )}
    </main>
  )
}
