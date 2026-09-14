import { api } from '../api/client.js'
import { useApiResource } from '../hooks/useApiResource.js'

export function ConnectionStatus() {
  const { isError, isLoading, reload } = useApiResource(api.testConnection, null)
  const state = isLoading ? 'checking' : isError ? 'offline' : 'online'
  const label = isLoading ? 'Checking API' : isError ? 'API offline' : 'Oracle connected'

  return (
    <button
      className="connection-chip"
      type="button"
      data-state={state}
      onClick={reload}
      title="Click to check the database connection again"
    >
      <span className="connection-dot" aria-hidden="true" />
      <span>{label}</span>
    </button>
  )
}
