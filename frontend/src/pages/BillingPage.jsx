import { BadgeIndianRupee, CircleCheck, CircleDashed, TriangleAlert } from 'lucide-react'
import { useMemo, useState } from 'react'
import { api } from '../api/client.js'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { Surface } from '../components/Surface.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatCurrency, formatDate, toneForStatus } from '../utils/formatters.js'

const filters = ['All', 'Paid', 'Pending']

export function BillingPage() {
  const [activeFilter, setActiveFilter] = useState('All')
  const { data, error, isError, isLoading, reload } = useApiResource(api.getBilling)
  const invoices = useMemo(() => activeFilter === 'All' ? data : data.filter((item) => item.payment_status === activeFilter), [activeFilter, data])
  const collected = data.filter((item) => item.payment_status === 'Paid').reduce((total, item) => total + Number(item.stored_total), 0)
  const outstanding = data.filter((item) => item.payment_status === 'Pending').reduce((total, item) => total + Number(item.stored_total), 0)
  const mismatchCount = data.filter((item) => Number(item.stored_total) !== Number(item.calculated_total)).length

  return (
    <main className="page">
      <PageHeader eyebrow="Revenue cycle" title="Every rupee should reconcile." description="Stored invoice values are compared with totals calculated by the Oracle PL/SQL function from medicine and laboratory costs." />
      <div className="metric-strip">
        <div><CircleCheck size={18} /><span><strong>{formatCurrency(collected)}</strong><small>Collected</small></span></div>
        <div><CircleDashed size={18} /><span><strong>{formatCurrency(outstanding)}</strong><small>Outstanding</small></span></div>
        <div><TriangleAlert size={18} /><span><strong>{mismatchCount}</strong><small>Variance flags</small></span></div>
      </div>

      <Surface className="data-surface">
        <div className="surface-toolbar">
          <div><strong>Invoice reconciliation</strong><small>{invoices.length} visible</small></div>
          <div className="segmented-control" aria-label="Filter invoices">{filters.map((filter) => <button key={filter} type="button" className={activeFilter === filter ? 'is-active' : ''} onClick={() => setActiveFilter(filter)}>{filter}</button>)}</div>
        </div>
        {isLoading && <LoadingState label="Loading invoices" />}
        {isError && <ErrorState error={error} onRetry={reload} />}
        {!isLoading && !isError && invoices.length === 0 && <EmptyState title="No invoices in this state" />}
        {!isLoading && !isError && invoices.length > 0 && (
          <div className="invoice-list">
            {invoices.map((invoice) => {
              const variance = Number(invoice.stored_total) - Number(invoice.calculated_total)
              return (
                <article className="invoice-row" key={`${invoice.appointment_id}:${invoice.invoice_no}`}>
                  <span className="invoice-icon"><BadgeIndianRupee size={18} /></span>
                  <div className="record-primary"><strong>{invoice.patient_name}</strong><small>{invoice.invoice_no} · {invoice.appointment_id}</small></div>
                  <div className="invoice-date"><strong>{formatDate(invoice.billing_date)}</strong><small>Billing date</small></div>
                  <div className="invoice-amount"><strong>{formatCurrency(invoice.stored_total)}</strong><small>Stored total</small></div>
                  <div className="invoice-calculated"><strong>{formatCurrency(invoice.calculated_total)}</strong><small>Calculated total</small></div>
                  <div className="invoice-state"><StatusBadge tone={toneForStatus(invoice.payment_status)}>{invoice.payment_status}</StatusBadge>{variance !== 0 && <small data-negative={variance < 0}>Variance {formatCurrency(Math.abs(variance))}</small>}</div>
                </article>
              )
            })}
          </div>
        )}
      </Surface>
    </main>
  )
}
