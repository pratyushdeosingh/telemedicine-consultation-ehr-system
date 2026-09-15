import { Building2, CalendarDays, MonitorUp, Stethoscope } from 'lucide-react'
import { useMemo, useState } from 'react'
import { api } from '../api/client.js'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatDate, getInitials, toneForStatus } from '../utils/formatters.js'

const filters = ['All', 'Scheduled', 'Completed', 'Cancelled']

export function AppointmentsPage() {
  const [activeFilter, setActiveFilter] = useState('All')
  const { data, error, isError, isLoading, reload } = useApiResource(api.getAppointments)
  const appointments = useMemo(() => activeFilter === 'All' ? data : data.filter((item) => item.status === activeFilter), [activeFilter, data])
  const virtualCount = data.filter((item) => item.consultation_mode === 'Virtual').length

  return (
    <main className="page">
      <PageHeader eyebrow="Care schedule" title="Every consultation, in sequence." description="A timeline of appointments joined with patient, doctor, and department records." />
      <div className="metric-strip">
        <div><CalendarDays size={18} /><span><strong>{data.length}</strong><small>Appointments</small></span></div>
        <div><MonitorUp size={18} /><span><strong>{virtualCount}</strong><small>Virtual</small></span></div>
        <div><Building2 size={18} /><span><strong>{data.length - virtualCount}</strong><small>In-person</small></span></div>
      </div>
      <Surface className="data-surface">
        <div className="surface-toolbar">
          <div><strong>Appointment timeline</strong><small>{appointments.length} visible</small></div>
          <div className="segmented-control" aria-label="Filter appointments">
            {filters.map((filter) => <button key={filter} type="button" className={activeFilter === filter ? 'is-active' : ''} onClick={() => setActiveFilter(filter)}>{filter}</button>)}
          </div>
        </div>
        {isLoading && <LoadingState label="Loading appointments" />}
        {isError && <ErrorState error={error} onRetry={reload} />}
        {!isLoading && !isError && appointments.length === 0 && <EmptyState title="No appointments in this state" />}
        {!isLoading && !isError && appointments.length > 0 && (
          <div className="appointment-timeline">
            {appointments.map((appointment) => {
              const dateParts = formatDate(appointment.appointment_date, { year: undefined }).split(' ')
              return (
                <article className="appointment-card" key={appointment.appointment_id}>
                  <div className="date-tile"><strong>{dateParts[0]}</strong><small>{dateParts[1]}</small></div>
                  <div className="appointment-person"><span className="avatar is-small">{getInitials(appointment.patient_name)}</span><span><strong>{appointment.patient_name}</strong><small>{appointment.appointment_id} · {appointment.appointment_time}</small></span></div>
                  <div className="appointment-clinician"><Stethoscope size={16} /><span><strong>Dr. {appointment.doctor_name}</strong><small>{appointment.department}</small></span></div>
                  <div className="appointment-status"><StatusBadge tone={toneForStatus(appointment.status)}>{appointment.status}</StatusBadge><small>{appointment.consultation_mode}</small></div>
                </article>
              )
            })}
          </div>
        )}
      </Surface>
    </main>
  )
}
