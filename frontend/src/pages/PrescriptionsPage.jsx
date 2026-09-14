import { CalendarClock, FileHeart, Pill, WalletCards } from 'lucide-react'
import { useMemo, useState } from 'react'
import { api } from '../api/client.js'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { SearchField } from '../components/SearchField.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatCurrency, getInitials } from '../utils/formatters.js'

function groupPrescriptions(rows) {
  const groups = new Map()

  rows.forEach((row) => {
    const key = `${row.appointment_id}:${row.prescription_no}`
    const current = groups.get(key) ?? {
      prescriptionNo: row.prescription_no,
      appointmentId: row.appointment_id,
      patientName: row.patient_name,
      medicines: [],
      total: 0,
    }

    current.medicines.push(row)
    current.total += Number(row.medicine_cost) || 0
    groups.set(key, current)
  })

  return [...groups.values()]
}

export function PrescriptionsPage() {
  const [query, setQuery] = useState('')
  const { data, error, isError, isLoading, reload } = useApiResource(api.getPrescriptions)
  const prescriptions = useMemo(() => {
    const grouped = groupPrescriptions(data)
    const normalizedQuery = query.trim().toLowerCase()
    if (!normalizedQuery) return grouped

    return grouped.filter((prescription) =>
      [prescription.patientName, prescription.prescriptionNo, prescription.appointmentId, ...prescription.medicines.map((item) => item.medicine_name)]
        .some((value) => value.toLowerCase().includes(normalizedQuery)),
    )
  }, [data, query])

  const totalMedicineCost = data.reduce((total, item) => total + (Number(item.medicine_cost) || 0), 0)

  return (
    <main className="page">
      <PageHeader eyebrow="Medication" title="A prescription is more than one row." description="Prescription items are grouped through their composite appointment and prescription keys, preserving each medicine and its dosage." />
      <div className="metric-strip">
        <div><FileHeart size={18} /><span><strong>{groupPrescriptions(data).length}</strong><small>Prescriptions</small></span></div>
        <div><Pill size={18} /><span><strong>{data.length}</strong><small>Medicine items</small></span></div>
        <div><WalletCards size={18} /><span><strong>{formatCurrency(totalMedicineCost)}</strong><small>Medicine value</small></span></div>
      </div>

      <Surface className="data-surface">
        <div className="surface-toolbar"><div><strong>Prescription registry</strong><small>{prescriptions.length} grouped records</small></div><SearchField value={query} onChange={setQuery} placeholder="Search patient, Rx or medicine" /></div>
        {isLoading && <LoadingState label="Loading prescriptions" />}
        {isError && <ErrorState error={error} onRetry={reload} />}
        {!isLoading && !isError && prescriptions.length === 0 && <EmptyState />}
        {!isLoading && !isError && prescriptions.length > 0 && (
          <div className="prescription-grid">
            {prescriptions.map((prescription) => (
              <article className="prescription-card" key={`${prescription.appointmentId}:${prescription.prescriptionNo}`}>
                <header>
                  <div className="appointment-person"><span className="avatar is-small">{getInitials(prescription.patientName)}</span><span><strong>{prescription.patientName}</strong><small>{prescription.appointmentId}</small></span></div>
                  <span className="rx-number">{prescription.prescriptionNo}</span>
                </header>
                <div className="medicine-list">
                  {prescription.medicines.map((medicine) => (
                    <div className="medicine-row" key={`${medicine.medicine_name}:${medicine.dosage}`}>
                      <span className="medicine-icon"><Pill size={15} /></span>
                      <span><strong>{medicine.medicine_name}</strong><small>{medicine.dosage}</small></span>
                      <span><strong>{medicine.quantity} units</strong><small><CalendarClock size={12} /> {medicine.duration_days} days</small></span>
                      <strong>{formatCurrency(medicine.medicine_cost)}</strong>
                    </div>
                  ))}
                </div>
                <footer><span>{prescription.medicines.length} medicine{prescription.medicines.length === 1 ? '' : 's'}</span><strong>{formatCurrency(prescription.total)}</strong></footer>
              </article>
            ))}
          </div>
        )}
      </Surface>
    </main>
  )
}
