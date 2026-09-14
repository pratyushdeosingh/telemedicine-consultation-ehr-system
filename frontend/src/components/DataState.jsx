import { AlertCircle, RefreshCw } from 'lucide-react'

export function LoadingState({ label = 'Loading records' }) {
  return (
    <div className="loading-state" role="status">
      <span className="loading-orbit" aria-hidden="true" />
      <strong>{label}</strong>
      <small>Requesting the latest data from the API.</small>
    </div>
  )
}

export function ErrorState({ error, onRetry }) {
  return (
    <div className="error-state" role="alert">
      <span className="state-icon"><AlertCircle size={21} /></span>
      <div><strong>Couldn’t load this view</strong><small>{error?.message ?? 'The API did not respond.'}</small></div>
      <button className="secondary-button" type="button" onClick={onRetry}><RefreshCw size={15} /> Retry</button>
    </div>
  )
}

export function EmptyState({ title = 'No records found', message = 'Try changing your search or filters.' }) {
  return <div className="empty-state"><strong>{title}</strong><small>{message}</small></div>
}
