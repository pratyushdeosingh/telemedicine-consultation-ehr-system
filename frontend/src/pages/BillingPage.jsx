import { useCallback, useState } from 'react'
import { api } from '../api/client.js'
import { ActionFeedback } from '../components/ActionFeedback.jsx'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { EntryForm } from '../components/EntryForm.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatCurrency, formatDate, toneForStatus } from '../utils/formatters.js'

async function loadBilling() {
  const [invoices, appointments] = await Promise.all([api.getBilling(), api.getAppointments()])
  return { invoices, appointments }
}

function InvoiceItems({ appointmentId }) {
  const loader = useCallback(() => api.getBillingItems(appointmentId), [appointmentId])
  const { data, isLoading, isError, error, reload } = useApiResource(loader)
  if (isLoading) return <LoadingState label="Loading invoice items" />
  if (isError) return <ErrorState error={error} onRetry={reload} />
  return <div className="invoice-breakdown">{!data.length ? <p>No charge items.</p> : <>
    <p>Current medicine and laboratory charges for this appointment.</p>
    {data.map((item, index) => <div key={index}><span>{item.item_name} <small>{item.item_type} · {item.quantity} × {formatCurrency(item.unit_price)}</small></span><strong>{formatCurrency(item.amount)}</strong></div>)}
    <div><strong>Current total</strong><strong>{formatCurrency(data.reduce((sum, item) => sum + Number(item.amount), 0))}</strong></div>
  </>}</div>
}

export function BillingPage() {
  const [filter, setFilter] = useState('All')
  const [expanded, setExpanded] = useState(null)
  const [busy, setBusy] = useState(false)
  const [feedback, setFeedback] = useState(null)
  const { data, isLoading, isError, error, reload } = useApiResource(loadBilling, { invoices: [], appointments: [] })
  const invoices = data.invoices.filter((item) => filter === 'All' || item.payment_status === filter)
  const available = data.appointments.filter((appointment) => !data.invoices.some((invoice) => invoice.appointment_id === appointment.appointment_id))
  async function update(invoice, action) {
    setBusy(true)
    setFeedback(null)
    try {
      await api.updateInvoice(invoice.appointment_id, invoice.invoice_no, action)
      setFeedback({ type: 'success', message: action === 'recalculate' ? 'Invoice total recalculated.' : action === 'pay' ? 'Invoice marked paid.' : 'Invoice marked refunded.' })
      await reload()
    } catch (requestError) {
      setFeedback({ type: 'error', message: requestError.message })
    } finally { setBusy(false) }
  }
  return <main className="page">
    <PageHeader eyebrow="Revenue cycle" title="Billing" description="Generate invoices, review charges, and record payment status." />
    <div className="metric-strip">
      {['Paid', 'Pending', 'Refunded'].map((status) => <div key={status}><span><strong>{formatCurrency(data.invoices.filter((i) => i.payment_status === status).reduce((sum, i) => sum + Number(i.stored_total), 0))}</strong><small>{status === 'Paid' ? 'Collected' : status === 'Pending' ? 'Outstanding' : 'Marked refunded'}</small></span></div>)}
    </div>
    <ActionFeedback feedback={feedback} />
    {isLoading && <LoadingState label="Loading invoices" />}
    {isError && <ErrorState error={error} onRetry={reload} />}
    {!isLoading && !isError && <>
      <Surface className="data-surface">
        <div className="surface-toolbar"><div><strong>Invoices and reconciliation</strong><small>{invoices.length} visible</small></div><div className="segmented-control">{['All', 'Pending', 'Paid', 'Refunded'].map((value) => <button type="button" key={value} className={filter === value ? 'is-active' : ''} onClick={() => setFilter(value)}>{value}</button>)}</div></div>
        {!invoices.length && <EmptyState title="No invoices in this state" />}
        <div className="clinical-list">{invoices.map((invoice) => {
          const key = `${invoice.appointment_id}:${invoice.invoice_no}`
          const mismatch = Math.round(Number(invoice.stored_total) * 100) !== Math.round(Number(invoice.calculated_total) * 100)
          return <article className="clinical-card" key={key}>
            <header><strong>{invoice.patient_name}</strong><StatusBadge tone={toneForStatus(invoice.payment_status)}>{invoice.payment_status}</StatusBadge></header>
            <small>{invoice.invoice_no} · {invoice.appointment_id} · {formatDate(invoice.billing_date)}</small>
            <p>Invoice: <strong>{formatCurrency(invoice.stored_total)}</strong> · Current calculated total: <strong>{formatCurrency(invoice.calculated_total)}</strong></p>
            {mismatch && <p className="allergy-conflict">Variance: {formatCurrency(Math.abs(Number(invoice.stored_total) - Number(invoice.calculated_total)))}{invoice.payment_status === 'Pending' ? '. Recalculate before marking paid.' : '. Review this settled invoice; its amount is locked.'}</p>}
            <div className="toolbar-actions invoice-actions">
              <button type="button" className="secondary-button" aria-expanded={expanded === key} onClick={() => setExpanded(expanded === key ? null : key)}>View charges</button>
              {invoice.payment_status === 'Pending' && <><button className="secondary-button" type="button" disabled={busy} onClick={() => update(invoice, 'recalculate')}>Recalculate</button><button className="primary-button" type="button" disabled={busy || mismatch} onClick={() => update(invoice, 'pay')}>Mark paid</button></>}
              {invoice.payment_status === 'Paid' && <button className="secondary-button" type="button" disabled={busy} onClick={() => update(invoice, 'refund')}>Mark refunded</button>}
            </div>
            {expanded === key && <InvoiceItems appointmentId={invoice.appointment_id} />}
          </article>
        })}</div>
      </Surface>
      <EntryForm title="Generate an invoice" description="One invoice per appointment. Totals include medicine quantities and ordered lab tests." buttonLabel="Generate invoice"
        initial={{ appointment_id: '', billing_date: '' }} fields={[
          { name: 'appointment_id', label: 'Appointment without an invoice', options: available.map((a) => ({ value: a.appointment_id, label: `${a.appointment_id} · ${a.patient_name}` })) },
          { name: 'billing_date', label: 'Billing date', type: 'date' },
        ]} onSubmit={async (values) => { const result = await api.createInvoice(values); await reload(); return `Invoice ${result.invoice_no} generated.` }} />
      <p className="page-help">Payment and refund buttons record status only. They do not transfer money. Paid and refunded appointments cannot receive additional medicine or lab charges.</p>
    </>}
  </main>
}
