import { useEffect, useRef, useState } from 'react'
import { api, isDemoMode } from '../api/client.js'
import { EmptyState, ErrorState, LoadingState } from './DataState.jsx'
import { Surface } from './Surface.jsx'
import { formatDate } from '../utils/formatters.js'

const labels = { MEDICAL_HISTORY: 'Medical history', APPOINTMENT: 'Appointment', PRESCRIPTION: 'Prescription', LAB_ORDER: 'Lab order', LAB_RESULT: 'Lab result', INVOICE: 'Invoice' }

function TimelineRecords({ patientId, month }) {
  const [events, setEvents] = useState([])
  const [cursor, setCursor] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [retry, setRetry] = useState(0)
  const paging = useRef(null)
  useEffect(() => {
    const controller = new AbortController()
    api.getTimeline(patientId, month, null, controller.signal).then((result) => {
      if (controller.signal.aborted) return
      setEvents(result.events)
      setCursor(result.next_cursor)
    }).catch((failure) => { if (!controller.signal.aborted) setError(failure) })
      .finally(() => { if (!controller.signal.aborted) setLoading(false) })
    return () => { controller.abort(); paging.current?.abort() }
  }, [patientId, month, retry])

  function restart() {
    setLoading(true)
    setError(null)
    setEvents([])
    setCursor(null)
    setRetry((current) => current + 1)
  }

  async function loadMore() {
    if (!cursor || loading) return
    const controller = new AbortController()
    paging.current = controller
    setLoading(true)
    setError(null)
    try {
      const result = await api.getTimeline(patientId, month, cursor, controller.signal)
      if (!controller.signal.aborted) {
        setEvents((current) => [...current, ...result.events])
        setCursor(result.next_cursor)
      }
    } catch (failure) { if (!controller.signal.aborted) setError(failure) }
    finally { if (!controller.signal.aborted) setLoading(false) }
  }

  return <>
    {loading && <LoadingState label={events.length ? 'Loading more timeline records' : 'Loading Cassandra timeline'} />}
    {error && <ErrorState error={error} onRetry={restart} />}
    {!loading && !error && !events.length && <EmptyState title="No imported records for this month" message="Choose another month, or use Refresh from Oracle after records change." />}
    <div className="clinical-list">{events.map((event) => <article className="clinical-card" key={`${event.event_time}:${event.event_id}`}>
      <header><strong>{labels[event.event_type] || event.event_type}</strong><small>{formatDate(event.event_time, { timeZone: 'UTC' })}</small></header>
      <p>{event.summary}</p>
      <small>{event.appointment_id ? `${event.appointment_id} · ` : ''}Source record: {event.source_record_id}</small>
    </article>)}</div>
    {!!events.length && <div className="timeline-footer"><small>{events.length} imported records loaded</small>{cursor && <button type="button" className="secondary-button" disabled={loading || !!error} onClick={loadMore}>Load more records</button>}</div>}
  </>
}

export function PatientTimeline({ patientId, defaultMonth, revision = 0, onMonthChange }) {
  const [month, setMonth] = useState(defaultMonth)
  const [refresh, setRefresh] = useState(0)
  function viewMonth(event) {
    event.preventDefault()
    const nextMonth = String(new FormData(event.currentTarget).get('month'))
    setMonth(nextMonth)
    onMonthChange?.(nextMonth)
    setRefresh((value) => value + 1)
  }
  return <Surface className="data-surface">
    <div className="surface-toolbar"><div><strong>Patient timeline</strong><small>{isDemoMode ? 'Unavailable in preview mode' : 'Imported from Oracle · stored in Cassandra'}</small></div>
      <form className="toolbar-actions" onSubmit={viewMonth}><label className="status-editor">Month <input type="month" name="month" defaultValue={month} required /></label><button type="submit" className="secondary-button">View timeline</button></form>
    </div>
    <p className="timeline-note">Showing {month}. Use Refresh from Oracle to copy new and updated records. Invoice summaries show current imported status, not payment-event timestamps.</p>
    {!patientId ? <EmptyState title="Select a patient to view their timeline" message="Use the patient selector above." />
      : isDemoMode ? <EmptyState title="Cassandra reads are disabled in preview mode" message="Switch to the live API to view imported records." />
        : !month ? <EmptyState title="Choose a month" message="Select the calendar month of the records you want to view." />
          : <TimelineRecords key={`${patientId}:${month}:${refresh}:${revision}`} patientId={patientId} month={month} />}
  </Surface>
}
