import { useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { api } from '../api/client.js'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { EntryForm } from '../components/EntryForm.jsx'
import { PatientTimeline } from '../components/PatientTimeline.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatDate } from '../utils/formatters.js'

async function loadHistory() {
  const [patients, logs, allergies, medicines] = await Promise.all([api.getPatients(), api.getMedicalLogs(), api.getAllergies(), api.getMedicines()])
  return { patients, logs, allergies, medicines }
}
const initial = { patient_id: '', log_date: '', diagnosis: '', known_allergies: [], other_allergies: '', attachment_path: '' }

export function MedicalHistoryPage() {
  const [today] = useState(() => new Date())
  const [params, setParams] = useSearchParams()
  const selected = params.get('patient') ?? ''
  const { data, isLoading, isError, error, reload } = useApiResource(loadHistory, { patients: [], logs: [], allergies: [], medicines: [] })
  const logs = data.logs.filter((log) => !selected || log.patient_id === selected).sort((a, b) => new Date(b.log_date) - new Date(a.log_date) || b.log_seq_no - a.log_seq_no)
  const allergies = [...new Set(data.allergies.filter((item) => !selected || item.patient_id === selected).map((item) => item.allergy_name))]
  const classes = [...new Set(data.medicines.map((item) => item.allergen_class?.trim().toUpperCase()).filter(Boolean))].sort()
  const matchesCatalog = (value) => classes.includes(value.trim().toUpperCase())
  const monthParts = new Intl.DateTimeFormat('en', { year: 'numeric', month: '2-digit', timeZone: 'Asia/Kolkata' }).formatToParts(new Date(logs[0]?.log_date || today))
  const defaultMonth = `${monthParts.find((part) => part.type === 'year').value}-${monthParts.find((part) => part.type === 'month').value}`
  return <main className="page">
    <PageHeader eyebrow="Patient records" title="Medical history" description="Review diagnoses and recorded allergies, or add a dated history entry." />
    {isLoading && <LoadingState label="Loading medical history" />}
    {isError && <ErrorState error={error} onRetry={reload} />}
    {!isLoading && !isError && <>
      <Surface className="data-surface">
        <div className="surface-toolbar"><div><strong>Patient history</strong><small>{logs.length} entries</small></div>
          <label className="status-editor">Patient <select value={selected} onChange={(event) => setParams(event.target.value ? { patient: event.target.value } : {})}><option value="">All patients</option>{data.patients.map((patient) => <option key={patient.patient_id} value={patient.patient_id}>{patient.first_name} {patient.last_name} · {patient.patient_id}</option>)}</select></label>
        </div>
        <div className="clinical-notice"><strong>{selected ? 'Recorded patient allergies' : 'Recorded allergies across patients'}</strong><p>{allergies.length ? <>Known medicine classes: {allergies.filter(matchesCatalog).join(', ') || 'None recorded'}<br />Other recorded allergies (outside automatic matching): {allergies.filter((value) => !matchesCatalog(value)).join(', ') || 'None recorded'}</> : 'No allergies recorded. This does not establish that a patient has no allergies.'}</p></div>
        {!logs.length && <EmptyState title="No medical history recorded" />}
        <div className="clinical-list">{logs.map((log) => <article className="clinical-card" key={`${log.patient_id}:${log.log_seq_no}`}>
          <header><strong>{log.patient_name}</strong><small>{log.patient_id} · {formatDate(log.log_date)} · Entry {log.log_seq_no}</small></header>
          <p>{log.diagnosis}</p>
          <small>Allergies recorded in this entry: {data.allergies.filter((item) => item.patient_id === log.patient_id && item.log_seq_no === log.log_seq_no).map((item) => `${item.allergy_name}${matchesCatalog(item.allergy_name) ? ' (medicine class)' : ' (outside automatic matching)'}`).join(', ') || 'None recorded'}</small>
          {log.attachment_path && <small className="document-reference">Attachment reference: {log.attachment_path}</small>}
        </article>)}</div>
      </Surface>
      <PatientTimeline key={selected} patientId={selected} defaultMonth={defaultMonth} />
      <EntryForm key={selected} title="Add medical history" description="Record a diagnosis and any known allergies together. Earlier entries remain available."
        initial={{ ...initial, patient_id: selected }} buttonLabel="Save history entry"
        fields={[
          { name: 'patient_id', label: 'Patient', options: data.patients.map((p) => ({ value: p.patient_id, label: `${p.first_name} ${p.last_name} · ${p.patient_id}` })) },
          { name: 'log_date', label: 'Entry date', type: 'date' },
          { name: 'diagnosis', label: 'Diagnosis / history', type: 'textarea', maxLength: 150, wide: true },
          { name: 'known_allergies', label: 'Known medicine allergy classes', required: false, multiple: true, options: classes.map((value) => ({ value, label: value })), help: 'Optional. Select one or more classes; use Ctrl/Cmd-click on a computer to select multiple. These classes are checked against medicines.', wide: true },
          { name: 'other_allergies', label: 'Other allergies (comma-separated)', required: false, maxLength: 1000, help: 'For example, food or environmental allergies. Saved in the history; not covered by the current medicine-class matching.', wide: true },
          { name: 'attachment_path', label: 'Attachment reference (no file upload)', required: false, maxLength: 2048, wide: true },
        ]}
        onSubmit={async (values) => {
          await api.createMedicalLog({ ...values, other_allergies: values.other_allergies.split(',').map((value) => value.trim()).filter(Boolean) })
          await reload()
          return 'Medical history and allergies saved.'
        }} />
      <p className="page-help">Known classes come from the medicine catalog. Other allergies are retained for review; the system does not infer ingredients, synonyms, or cross-reactivity.</p>
    </>}
  </main>
}
