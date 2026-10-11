import { api, isDemoMode } from '../api/client.js'
import { useApiResource } from '../hooks/useApiResource.js'
import { useEffect } from 'react'

export function ConnectionStatus({ database = 'Oracle' }) {
  const loader = database === 'Cassandra' ? api.testCassandraConnection : api.testConnection
  const { data, isError, isLoading, isRefreshing, reload } = useApiResource(loader, null)
  useEffect(() => {
    window.addEventListener('databases-refresh', reload)
    return () => window.removeEventListener('databases-refresh', reload)
  }, [reload])
  const checking = isLoading || isRefreshing
  const disabled = database === 'Cassandra' && data?.enabled === false
  const unavailable = isError || (database === 'Cassandra' && data?.connected === false && !disabled)
  const state = isDemoMode ? 'preview' : checking ? 'checking' : unavailable ? 'offline' : disabled ? 'preview' : 'online'
  const label = isDemoMode ? `${database} preview` : checking ? `Checking ${database}` : unavailable ? `${database} unavailable` : disabled ? `${database} not configured` : `${database} connected`

  return (
    <button
      className="connection-chip"
      type="button"
      data-state={state}
      onClick={isDemoMode || checking ? undefined : reload}
      aria-label={label}
      title={`${label}. Click to check again. Availability does not indicate the last data refresh.`}
    >
      <span className="connection-dot" aria-hidden="true" />
      <span>{label}</span>
    </button>
  )
}
