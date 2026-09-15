import { Building2, CalendarDays, MonitorUp, Plus, Save, Stethoscope, X } from 'lucide-react'
import { useMemo, useState } from 'react'
import { api } from '../api/client.js'
import { ActionFeedback } from '../components/ActionFeedback.jsx'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatDate, getInitials, toneForStatus } from '../utils/formatters.js'

const filters = ['All', 'Scheduled', 'Completed', 'Cancelled']
const statuses = ['Scheduled', 'In-Progress', 'Completed', 'Cancelled']

function AppointmentStatusControl({ appointment, onSaved }) {
  const [status, setStatus] = useState(appointment.status)
  const [isSaving, setIsSaving] = useState(false)
  const [error, setError] = useState('')

  async function submitStatus(event) {
    event.preventDefault()
    if (status === appointment.status) return
    setIsSaving(true)
    setError('')

    try {
      await api.updateAppointmentStatus(appointment.appointment_id, status)
      await onSaved()
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setIsSaving(false)
    }
  }

  return (
    <form className="status-editor" onSubmit={submitStatus}>
      <select aria-label={`Status for ${appointment.appointment_id}`} value={status} onChange={(event) => setStatus(event.target.value)}>
        {statuses.map((value) => <option key={value}>{value}</option>)}
      </select>
      <button className="icon-button" type="submit" disabled={isSaving || status === appointment.status} aria-label={`Save status for ${appointment.appointment_id}`} title={error || 'Save status'}><Save size={14} /></button>
    </form>
  )
}

export function AppointmentsPage() {
  const [activeFilter, setActiveFilter] = useState('All')
  const [isFormOpen, setIsFormOpen] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const [feedback, setFeedback] = useState(null)
  const [form, setForm] = useState({ patient_id: '', doctor_id: '', appointment_date: '', appointment_time: '', status: 'Scheduled', consultation_mode: 'Virtual', meeting_link: '' })
  const { data, error, isError, isLoading, reload } = useApiResource(api.getAppointments)
  const { data: patients } = useApiResource(api.getPatients)
  const { data: doctors } = useApiResource(api.getDoctors)
  const appointments = useMemo(() => activeFilter === 'All' ? data : data.filter((item) => item.status === activeFilter), [activeFilter, data])
  const virtualCount = data.filter((item) => item.consultation_mode === 'Virtual').length

  function updateField(event) {
    setForm((current) => ({ ...current, [event.target.name]: event.target.value }))
  }

  async function submitAppointment(event) {
    event.preventDefault()
    setIsSaving(true)
    setFeedback(null)

    try {
      const result = await api.createAppointment({ ...form, meeting_link: form.meeting_link || null })
      setFeedback({ type: 'success', message: `Appointment ${result.appointment_id} booked successfully.` })
      setForm({ patient_id: '', doctor_id: '', appointment_date: '', appointment_time: '', status: 'Scheduled', consultation_mode: 'Virtual', meeting_link: '' })
      await reload()
    } catch (requestError) {
      setFeedback({ type: 'error', message: requestError.message })
    } finally {
      setIsSaving(false)
    }
  }

  return (
    <main className="page">
      <PageHeader eyebrow="Care schedule" title="Every consultation, in sequence." description="A timeline of appointments joined with patient, doctor, and department records." />
      <div className="metric-strip">
        <div><CalendarDays size={18} /><span><strong>{data.length}</strong><small>Appointments</small></span></div>
        <div><MonitorUp size={18} /><span><strong>{virtualCount}</strong><small>Virtual</small></span></div>
        <div><Building2 size={18} /><span><strong>{data.length - virtualCount}</strong><small>In-person</small></span></div>
      </div>
      {isFormOpen && (
        <Surface className="action-panel">
          <div className="action-panel-header">
            <div><strong>Book an appointment</strong><small>Creates a scheduled consultation and generates its appointment ID.</small></div>
            <button className="icon-button" type="button" onClick={() => setIsFormOpen(false)} aria-label="Close appointment form"><X size={17} /></button>
          </div>
          <form className="record-form" onSubmit={submitAppointment}>
            <label><span>Patient *</span><select name="patient_id" value={form.patient_id} onChange={updateField} required><option value="">Select patient</option>{patients.map((patient) => <option key={patient.patient_id} value={patient.patient_id}>{patient.patient_id} · {patient.first_name} {patient.last_name}</option>)}</select></label>
            <label><span>Doctor *</span><select name="doctor_id" value={form.doctor_id} onChange={updateField} required><option value="">Select doctor</option>{doctors.map((doctor) => <option key={doctor.doctor_id} value={doctor.doctor_id}>{doctor.doctor_id} · Dr. {doctor.first_name} {doctor.last_name}</option>)}</select></label>
            <label><span>Date *</span><input type="date" name="appointment_date" value={form.appointment_date} onChange={updateField} required /></label>
            <label><span>Time *</span><input name="appointment_time" value={form.appointment_time} onChange={updateField} placeholder="10:30 AM" required /></label>
            <label><span>Status *</span><select name="status" value={form.status} onChange={updateField}>{statuses.map((status) => <option key={status}>{status}</option>)}</select></label>
            <label><span>Consultation mode *</span><select name="consultation_mode" value={form.consultation_mode} onChange={updateField}><option>Virtual</option><option>In-Person</option></select></label>
            <label className="form-span-2"><span>Meeting link</span><input type="url" name="meeting_link" value={form.meeting_link} onChange={updateField} placeholder="Optional for virtual consultations" /></label>
            <div className="form-footer form-span-2"><ActionFeedback feedback={feedback} /><button className="primary-button" type="submit" disabled={isSaving}><Save size={15} /> {isSaving ? 'Booking…' : 'Book appointment'}</button></div>
          </form>
        </Surface>
      )}
      <Surface className="data-surface">
        <div className="surface-toolbar">
          <div><strong>Appointment timeline</strong><small>{appointments.length} visible</small></div>
          <div className="toolbar-actions"><div className="segmented-control" aria-label="Filter appointments">{filters.map((filter) => <button key={filter} type="button" className={activeFilter === filter ? 'is-active' : ''} onClick={() => setActiveFilter(filter)}>{filter}</button>)}</div><button className="primary-button" type="button" onClick={() => { setFeedback(null); setIsFormOpen(true) }}><Plus size={15} /> Book appointment</button></div>
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
                  <div className="appointment-status"><StatusBadge tone={toneForStatus(appointment.status)}>{appointment.status}</StatusBadge><small>{appointment.consultation_mode}</small><AppointmentStatusControl appointment={appointment} onSaved={reload} /></div>
                </article>
              )
            })}
          </div>
        )}
      </Surface>
    </main>
  )
}
