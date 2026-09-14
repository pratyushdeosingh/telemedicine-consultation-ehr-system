import { MapPin, ShieldCheck, ShieldX, UsersRound } from 'lucide-react'
import { useMemo, useState } from 'react'
import { api } from '../api/client.js'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { SearchField } from '../components/SearchField.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { getInitials } from '../utils/formatters.js'

export function PatientsPage() {
  const [query, setQuery] = useState('')
  const { data, error, isError, isLoading, reload } = useApiResource(api.getPatients)
  const filteredPatients = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase()
    if (!normalizedQuery) return data
    return data.filter((patient) => [patient.patient_id, patient.first_name, patient.last_name, patient.city, patient.policy_no]
      .filter(Boolean).some((value) => value.toLowerCase().includes(normalizedQuery)))
  }, [data, query])
  const insuredCount = data.filter((patient) => patient.policy_no).length

  return (
    <main className="page">
      <PageHeader eyebrow="Patient directory" title="People behind every record." description="Search patient identity, location, and insurance coverage returned by the Oracle patient endpoint." />
      <div className="metric-strip">
        <div><UsersRound size={18} /><span><strong>{data.length}</strong><small>Total patients</small></span></div>
        <div><ShieldCheck size={18} /><span><strong>{insuredCount}</strong><small>Insured</small></span></div>
        <div><ShieldX size={18} /><span><strong>{data.length - insuredCount}</strong><small>Without policy</small></span></div>
      </div>
      <Surface className="data-surface">
        <div className="surface-toolbar"><div><strong>Patient records</strong><small>{filteredPatients.length} visible</small></div><SearchField value={query} onChange={setQuery} placeholder="Search name, ID, city or policy" /></div>
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
