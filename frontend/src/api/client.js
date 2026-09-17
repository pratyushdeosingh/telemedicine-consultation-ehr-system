import { demoData } from './demoData.js'

const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api'
export const isDemoMode = import.meta.env.VITE_USE_DEMO_DATA === 'true'

async function request(path, options = {}) {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    credentials: 'same-origin',
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

function sendJson(path, method, body) {
  if (isDemoMode) {
    return Promise.reject(new Error('Writing is disabled while preview data is active. Switch to the live Oracle API first.'))
  }

  return request(path, {
    method,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
}

export const api = {
  getSession: () => isDemoMode ? Promise.resolve({ authenticated: true }) : request('/session'),
  login: (password) => request('/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ password }),
  }),
  logout: () => request('/logout', { method: 'POST' }),
  testConnection: () => isDemoMode ? Promise.resolve({ success: true }) : request('/test-db'),
  getPatients: () => isDemoMode ? Promise.resolve(demoData.patients) : request('/patients'),
  getAppointments: () => isDemoMode ? Promise.resolve(demoData.appointments) : request('/appointments'),
  getPrescriptions: () => isDemoMode ? Promise.resolve(demoData.prescriptions) : request('/prescriptions'),
  getBilling: () => isDemoMode ? Promise.resolve(demoData.billing) : request('/billing'),
  getDoctors: () => isDemoMode ? Promise.resolve([]) : request('/doctors'),
  getMedicines: () => isDemoMode ? Promise.resolve([]) : request('/medicines'),
  getPharmacies: () => isDemoMode ? Promise.resolve([]) : request('/pharmacies'),
  getTestResults: () => isDemoMode ? Promise.resolve([]) : request('/test-results'),
  createPatient: (patient) => sendJson('/patients', 'POST', patient),
  createAppointment: (appointment) => sendJson('/appointments', 'POST', appointment),
  createPrescription: (prescription) => sendJson('/prescriptions', 'POST', prescription),
  updateAppointmentStatus: (appointmentId, status) => sendJson(`/appointments/${encodeURIComponent(appointmentId)}/status`, 'PUT', { status }),
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
