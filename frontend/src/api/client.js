import { demoData } from './demoData.js'

const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api'
export const isDemoMode = import.meta.env.VITE_USE_DEMO_DATA === 'true'

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
  testConnection: () => isDemoMode ? Promise.resolve({ success: true }) : request('/test-db'),
  getPatients: () => isDemoMode ? Promise.resolve(demoData.patients) : request('/patients'),
  getAppointments: () => isDemoMode ? Promise.resolve(demoData.appointments) : request('/appointments'),
  getPrescriptions: () => isDemoMode ? Promise.resolve(demoData.prescriptions) : request('/prescriptions'),
  getBilling: () => isDemoMode ? Promise.resolve(demoData.billing) : request('/billing'),
  getDashboardData: async () => {
    const [patients, appointments, prescriptions, billing] = await Promise.all([
      isDemoMode ? Promise.resolve(demoData.patients) : request('/patients'),
      isDemoMode ? Promise.resolve(demoData.appointments) : request('/appointments'),
      isDemoMode ? Promise.resolve(demoData.prescriptions) : request('/prescriptions'),
      isDemoMode ? Promise.resolve(demoData.billing) : request('/billing'),
    ])

    return { patients, appointments, prescriptions, billing }
  },
}
