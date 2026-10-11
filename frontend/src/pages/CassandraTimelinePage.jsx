import { useEffect, useRef, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { api, isDemoMode } from '../api/client.js'
import { PageHeader } from '../components/PageHeader.jsx'
import { Surface } from '../components/Surface.jsx'
import { PatientTimeline } from '../components/PatientTimeline.jsx'
import { ErrorState, LoadingState } from '../components/DataState.jsx'
import { useApiResource } from '../hooks/useApiResource.js'

function currentMonth() {
  const parts = new Intl.DateTimeFormat('en', { year: 'numeric', month: '2-digit', timeZone: 'Asia/Kolkata' }).formatToParts(new Date())
  return `${parts.find(p => p.type === 'year').value}-${parts.find(p => p.type === 'month').value}`
}

export function CassandraTimelinePage() {
  const [params, setParams] = useSearchParams()
  const selected = params.get('patient') || ''
  const monthParam = params.get('month') || ''
  const [todayMonth] = useState(currentMonth)
  const month = /^\d{4}-(0[1-9]|1[0-2])$/.test(monthParam) && !monthParam.startsWith('0000') ? monthParam : todayMonth
  const { data: patients, isLoading, isError, error, reload } = useApiResource(api.getPatients, [])
  const [refreshing, setRefreshing] = useState(false)
  const [result, setResult] = useState(null)
  const [failure, setFailure] = useState(null)
  const [revision, setRevision] = useState(0)
  const busy = useRef(false)
  const mounted = useRef(true)
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])

  async function refreshFromOracle() {
    if (busy.current || isDemoMode) return
    busy.current = true
    setRefreshing(true)
    setResult(null)
    setFailure(null)
    try {
      const response = await api.refreshTimeline()
      if (!mounted.current) return
      setResult(response)
      setRevision(value => value + 1)
      await reload()
    } catch (requestError) {
      if (mounted.current) setFailure(requestError)
    } finally {
      busy.current = false
      if (mounted.current) {
        setRefreshing(false)
        window.dispatchEvent(new Event('databases-refresh'))
      }
    }
  }

  return <main className="page">
    <PageHeader eyebrow="D.A. 3 · Modern database" title="Cassandra Timeline" description="Astra DB, powered by Cassandra. Explore clinical events copied from Oracle and grouped by patient and month." />
    <Surface className="data-surface">
      <div className="surface-toolbar">
        <div><strong>Refresh clinical records</strong><small>Oracle → Cassandra · all patients</small></div>
        <div className="toolbar-actions"><button className="primary-button" type="button" disabled={refreshing || isDemoMode} onClick={refreshFromOracle}>{refreshing ? 'Refreshing from Oracle…' : 'Refresh from Oracle'}</button></div>
      </div>
      <p className="timeline-note">Click Refresh after adding or changing Oracle records. This copies new and updated events for all patients; it does not change Oracle records or remove old timeline entries.</p>
      {isDemoMode && <p className="clinical-notice">Refresh is available on the live website. Preview mode does not connect to Cassandra.</p>}
      {refreshing && <p role="status">Reading Oracle and refreshing Cassandra. Please keep this page open.</p>}
      {failure && <ErrorState error={failure} onRetry={refreshFromOracle} />}
      {result && <div className="clinical-notice" role="status"><strong>{result.failed ? 'Refresh partially completed — retry to finish' : 'Refresh completed'}</strong><p>{result.written} of {result.attempted} records refreshed. Source snapshot: {result.partitions} patient/month groups. {result.failed} could not be refreshed.{result.timed_out ? ' The refresh time limit was reached.' : ''}</p><small>This request finished at {new Date(result.completed_at).toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' })}. This is the result of your current refresh.</small>{!!result.failed && <button type="button" className="secondary-button" disabled={refreshing} onClick={refreshFromOracle}>Retry refresh</button>}</div>}
    </Surface>
    <Surface className="data-surface"><div className="surface-toolbar"><div><strong>Patient records</strong><small>Choose a patient to explore their timeline</small></div><label className="status-editor">Patient <select value={selected} onChange={event => setParams(event.target.value ? { patient: event.target.value, month } : { month })}><option value="">Select patient</option>{patients.map(patient => <option key={patient.patient_id} value={patient.patient_id}>{patient.first_name} {patient.last_name} · {patient.patient_id}</option>)}</select></label></div>
      {isLoading && <LoadingState label="Loading patient options from Oracle" />}
      {isError && <ErrorState error={error} onRetry={reload} />}
    </Surface>
    <PatientTimeline key={`${selected}:${month}`} patientId={selected} defaultMonth={month} revision={revision} onMonthChange={value => setParams(selected ? { patient: selected, month: value } : { month: value })} />
    <p className="page-help">Connection status checks availability. Data freshness depends on a completed refresh. A patient/date change or source deletion can leave an earlier imported entry; this timeline is not a live replica or an immutable audit log.</p>
  </main>
}
