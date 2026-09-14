const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api'

async function request(path, options = {}) {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    headers: {
      Accept: 'application/json',
      ...options.headers,
    },
    ...options,
  })

  let payload

  try {
    payload = await response.json()
  } catch {
    payload = null
  }

  if (!response.ok) {
    const message = payload?.error ?? payload?.message ?? 'The API request failed.'
    throw new Error(message)
  }

  return payload
}

export const api = {
  testConnection: () => request('/test-db'),
  getPatients: () => request('/patients'),
  getAppointments: () => request('/appointments'),
  getPrescriptions: () => request('/prescriptions'),
  getBilling: () => request('/billing'),
}
