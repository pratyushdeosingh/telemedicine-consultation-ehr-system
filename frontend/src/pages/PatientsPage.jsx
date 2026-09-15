import { MapPin, Plus, Save, ShieldCheck, ShieldX, UsersRound, X } from 'lucide-react'
import { useMemo, useState } from 'react'
import { api } from '../api/client.js'
import { ActionFeedback } from '../components/ActionFeedback.jsx'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { SearchField } from '../components/SearchField.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { getInitials } from '../utils/formatters.js'

export function PatientsPage() {
  const [query, setQuery] = useState('')
  const [isFormOpen, setIsFormOpen] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const [feedback, setFeedback] = useState(null)
  const [form, setForm] = useState({
    first_name: '', last_name: '', street: '', city: '', state: '', zip_code: '',
    dob: '', gender: '', emergency_contact: '', policy_no: '',
  })
  const { data, error, isError, isLoading, reload } = useApiResource(api.getPatients)
  const filteredPatients = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase()
    if (!normalizedQuery) return data
    return data.filter((patient) => [patient.patient_id, patient.first_name, patient.last_name, patient.city, patient.policy_no]
      .filter(Boolean).some((value) => value.toLowerCase().includes(normalizedQuery)))
  }, [data, query])
  const insuredCount = data.filter((patient) => patient.policy_no).length

  function updateField(event) {
    setForm((current) => ({ ...current, [event.target.name]: event.target.value }))
  }

  async function submitPatient(event) {
    event.preventDefault()
    setIsSaving(true)
    setFeedback(null)

    try {
      await api.createPatient({ ...form, policy_no: form.policy_no || null })
      setFeedback({ type: 'success', message: 'Patient registered in Oracle successfully.' })
      setForm({ first_name: '', last_name: '', street: '', city: '', state: '', zip_code: '', dob: '', gender: '', emergency_contact: '', policy_no: '' })
      await reload()
    } catch (requestError) {
      setFeedback({ type: 'error', message: requestError.message })
    } finally {
      setIsSaving(false)
    }
  }

  return (
    <main className="page">
      <PageHeader eyebrow="Patient directory" title="People behind every record." description="Search patient identity, location, and insurance coverage returned by the Oracle patient endpoint." />
      <div className="metric-strip">
        <div><UsersRound size={18} /><span><strong>{data.length}</strong><small>Total patients</small></span></div>
        <div><ShieldCheck size={18} /><span><strong>{insuredCount}</strong><small>Insured</small></span></div>
        <div><ShieldX size={18} /><span><strong>{data.length - insuredCount}</strong><small>Without policy</small></span></div>
      </div>
      {isFormOpen && (
        <Surface className="action-panel">
          <div className="action-panel-header">
            <div><strong>Register a patient</strong><small>Creates a new Oracle patient record through the PL/SQL registration procedure.</small></div>
            <button className="icon-button" type="button" onClick={() => setIsFormOpen(false)} aria-label="Close patient form"><X size={17} /></button>
          </div>
          <form className="record-form" onSubmit={submitPatient}>
            <label><span>First name *</span><input name="first_name" value={form.first_name} onChange={updateField} required /></label>
            <label><span>Last name *</span><input name="last_name" value={form.last_name} onChange={updateField} required /></label>
            <label><span>Date of birth *</span><input type="date" name="dob" value={form.dob} onChange={updateField} required /></label>
            <label><span>Gender</span><select name="gender" value={form.gender} onChange={updateField}><option value="">Select</option><option>Female</option><option>Male</option><option>Other</option></select></label>
            <label className="form-span-2"><span>Street</span><input name="street" value={form.street} onChange={updateField} /></label>
            <label><span>City</span><input name="city" value={form.city} onChange={updateField} /></label>
            <label><span>State</span><input name="state" value={form.state} onChange={updateField} /></label>
            <label><span>ZIP code</span><input name="zip_code" value={form.zip_code} onChange={updateField} /></label>
            <label><span>Emergency contact</span><input name="emergency_contact" value={form.emergency_contact} onChange={updateField} /></label>
            <label><span>Insurance policy</span><input name="policy_no" value={form.policy_no} onChange={updateField} placeholder="Optional" /></label>
            <div className="form-footer form-span-2">
              <ActionFeedback feedback={feedback} />
              <button className="primary-button" type="submit" disabled={isSaving}><Save size={15} /> {isSaving ? 'Saving…' : 'Register patient'}</button>
            </div>
          </form>
        </Surface>
      )}
      <Surface className="data-surface">
        <div className="surface-toolbar"><div><strong>Patient records</strong><small>{filteredPatients.length} visible</small></div><div className="toolbar-actions"><SearchField value={query} onChange={setQuery} placeholder="Search name, ID, city or policy" /><button className="primary-button" type="button" onClick={() => { setFeedback(null); setIsFormOpen(true) }}><Plus size={15} /> Register patient</button></div></div>
        {isLoading && <LoadingState label="Loading patient records" />}
        {isError && <ErrorState error={error} onRetry={reload} />}
        {!isLoading && !isError && filteredPatients.length === 0 && <EmptyState />}
        {!isLoading && !isError && filteredPatients.length > 0 && (
          <div className="record-list">
            {filteredPatients.map((patient) => {
              const fullName = `${patient.first_name} ${patient.last_name}`
              return (
                <article className="patient-row" key={patient.patient_id}>
                  <span className="avatar">{getInitials(fullName)}</span>
                  <div className="record-primary"><strong>{fullName}</strong><small>{patient.patient_id} · {patient.gender}</small></div>
                  <div className="record-detail"><MapPin size={15} /><span><strong>{patient.city}</strong><small>{patient.state}</small></span></div>
                  <StatusBadge tone={patient.policy_no ? 'positive' : 'neutral'}>{patient.policy_no ?? 'Self-pay'}</StatusBadge>
                </article>
              )
            })}
          </div>
        )}
      </Surface>
    </main>
  )
}
