import { CalendarClock, FileHeart, Pill, Plus, Save, WalletCards, X } from 'lucide-react'
import { useMemo, useState } from 'react'
import { api } from '../api/client.js'
import { ActionFeedback } from '../components/ActionFeedback.jsx'
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
  const [isFormOpen, setIsFormOpen] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const [feedback, setFeedback] = useState(null)
  const [form, setForm] = useState({ appointment_id: '', prescription_no: '', issue_date: '', notes: '', pharmacy_id: '', medicine_id: '', dosage: '', duration_days: '', quantity: '' })
  const { data, error, isError, isLoading, reload } = useApiResource(api.getPrescriptions)
  const { data: appointments } = useApiResource(api.getAppointments)
  const { data: medicines } = useApiResource(api.getMedicines)
  const { data: pharmacies } = useApiResource(api.getPharmacies)
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

  function updateField(event) {
    setForm((current) => ({ ...current, [event.target.name]: event.target.value }))
  }

  async function submitPrescription(event) {
    event.preventDefault()
    setIsSaving(true)
    setFeedback(null)

    try {
      await api.createPrescription({
        appointment_id: form.appointment_id,
        prescription_no: form.prescription_no,
        issue_date: form.issue_date,
        notes: form.notes || null,
        pharmacy_id: form.pharmacy_id || null,
        items: [{
          item_seq_no: 1,
          medicine_id: form.medicine_id,
          dosage: form.dosage,
          duration_days: Number(form.duration_days),
          quantity: Number(form.quantity),
        }],
      })
      setFeedback({ type: 'success', message: `Prescription ${form.prescription_no} created successfully.` })
      setForm({ appointment_id: '', prescription_no: '', issue_date: '', notes: '', pharmacy_id: '', medicine_id: '', dosage: '', duration_days: '', quantity: '' })
      await reload()
    } catch (requestError) {
      setFeedback({ type: 'error', message: requestError.message })
    } finally {
      setIsSaving(false)
    }
  }

  return (
    <main className="page">
      <PageHeader eyebrow="Medication" title="A prescription is more than one row." description="Prescription items are grouped through their composite appointment and prescription keys, preserving each medicine and its dosage." />
      <div className="metric-strip">
        <div><FileHeart size={18} /><span><strong>{groupPrescriptions(data).length}</strong><small>Prescriptions</small></span></div>
        <div><Pill size={18} /><span><strong>{data.length}</strong><small>Medicine items</small></span></div>
        <div><WalletCards size={18} /><span><strong>{formatCurrency(totalMedicineCost)}</strong><small>Medicine value</small></span></div>
      </div>

      {isFormOpen && (
        <Surface className="action-panel">
          <div className="action-panel-header">
            <div><strong>Create a prescription</strong><small>Adds a prescription and its first medicine item in one Oracle transaction.</small></div>
            <button className="icon-button" type="button" onClick={() => setIsFormOpen(false)} aria-label="Close prescription form"><X size={17} /></button>
          </div>
          <form className="record-form" onSubmit={submitPrescription}>
            <label><span>Appointment *</span><select name="appointment_id" value={form.appointment_id} onChange={updateField} required><option value="">Select appointment</option>{appointments.map((appointment) => <option key={appointment.appointment_id} value={appointment.appointment_id}>{appointment.appointment_id} · {appointment.patient_name}</option>)}</select></label>
            <label><span>Prescription number *</span><input name="prescription_no" value={form.prescription_no} onChange={updateField} placeholder="RX-09" required /></label>
            <label><span>Issue date *</span><input type="date" name="issue_date" value={form.issue_date} onChange={updateField} required /></label>
            <label><span>Pharmacy</span><select name="pharmacy_id" value={form.pharmacy_id} onChange={updateField}><option value="">No pharmacy</option>{pharmacies.map((pharmacy) => <option key={pharmacy.pharmacy_id} value={pharmacy.pharmacy_id}>{pharmacy.pharmacy_name}</option>)}</select></label>
            <label><span>Medicine *</span><select name="medicine_id" value={form.medicine_id} onChange={updateField} required><option value="">Select medicine</option>{medicines.map((medicine) => <option key={medicine.medicine_id} value={medicine.medicine_id}>{medicine.medicine_name} · {formatCurrency(medicine.unit_price)}</option>)}</select></label>
            <label><span>Dosage *</span><input name="dosage" value={form.dosage} onChange={updateField} placeholder="500mg Twice Daily" required /></label>
            <label><span>Duration in days *</span><input type="number" min="1" name="duration_days" value={form.duration_days} onChange={updateField} required /></label>
            <label><span>Quantity *</span><input type="number" min="1" name="quantity" value={form.quantity} onChange={updateField} required /></label>
            <label className="form-span-2"><span>Clinical notes</span><textarea name="notes" value={form.notes} onChange={updateField} rows="3" /></label>
            <div className="form-footer form-span-2"><ActionFeedback feedback={feedback} /><button className="primary-button" type="submit" disabled={isSaving}><Save size={15} /> {isSaving ? 'Saving…' : 'Create prescription'}</button></div>
          </form>
        </Surface>
      )}

      <Surface className="data-surface">
        <div className="surface-toolbar"><div><strong>Prescription registry</strong><small>{prescriptions.length} grouped records</small></div><div className="toolbar-actions"><SearchField value={query} onChange={setQuery} placeholder="Search patient, Rx or medicine" /><button className="primary-button" type="button" onClick={() => { setFeedback(null); setIsFormOpen(true) }}><Plus size={15} /> Create prescription</button></div></div>
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
