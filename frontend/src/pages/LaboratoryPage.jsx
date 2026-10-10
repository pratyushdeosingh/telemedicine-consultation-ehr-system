import { useState } from 'react'
import { api } from '../api/client.js'
import { EmptyState, ErrorState, LoadingState } from '../components/DataState.jsx'
import { EntryForm } from '../components/EntryForm.jsx'
import { PageHeader } from '../components/PageHeader.jsx'
import { Surface } from '../components/Surface.jsx'
import { SearchField } from '../components/SearchField.jsx'
import { StatusBadge } from '../components/StatusBadge.jsx'
import { useApiResource } from '../hooks/useApiResource.js'
import { formatCurrency, formatDate } from '../utils/formatters.js'

async function loadLaboratory() {
  const [orders, results, catalog, appointments] = await Promise.all([api.getLabOrders(), api.getTestResults(), api.getLabCatalog(), api.getAppointments()])
  return { orders, results, catalog, appointments }
}

export function LaboratoryPage() {
  const [filter, setFilter] = useState('All')
  const [query, setQuery] = useState('')
  const { data, isLoading, isError, error, reload } = useApiResource(loadLaboratory, { orders: [], results: [], catalog: [], appointments: [] })
  const orders = data.orders.filter((order) => (filter === 'All' || (data.results.some((result) => result.order_id === order.order_id) ? 'Reported' : 'Awaiting result') === filter) && [order.patient_name, order.order_id, order.appointment_id, order.test_name].some((value) => value.toLowerCase().includes(query.trim().toLowerCase())))
  return <main className="page">
    <PageHeader eyebrow="Diagnostics" title="Laboratory" description="Order tests and record results for a patient's appointment." />
    {isLoading && <LoadingState label="Loading laboratory records" />}
    {isError && <ErrorState error={error} onRetry={reload} />}
    {!isLoading && !isError && <>
      <Surface className="data-surface">
        <div className="surface-toolbar"><div><strong>Lab orders and results</strong><small>{orders.length} visible</small></div><div className="toolbar-actions"><SearchField value={query} onChange={setQuery} placeholder="Search patient, test or order" /><div className="segmented-control">{['All', 'Awaiting result', 'Reported'].map((value) => <button type="button" key={value} className={filter === value ? 'is-active' : ''} onClick={() => setFilter(value)}>{value}</button>)}</div></div></div>
        {!orders.length && <EmptyState title="No lab orders in this state" />}
        <div className="clinical-list">{orders.map((order) => {
          const results = data.results.filter((result) => result.order_id === order.order_id).sort((a, b) => b.result_seq_no - a.result_seq_no)
          return <article className="clinical-card" key={order.order_id}>
            <header><strong>{order.test_name} · {order.patient_name}</strong><StatusBadge tone={results.length ? 'positive' : 'warning'}>{results.length ? 'Reported' : 'Awaiting result'}</StatusBadge></header>
            <small>{order.order_id} · {order.appointment_id} · {formatDate(order.order_date)} · {order.priority} · {formatCurrency(order.standard_cost)}</small>
            {results.map((result) => <div className="lab-result" key={result.result_seq_no}><strong>{result.result_value}</strong><small>Result {result.result_seq_no} · {formatDate(result.report_date)}</small>{result.technician_remarks && <p>{result.technician_remarks}</p>}{result.document_url && <small className="document-reference">Document reference: {result.document_url} {result.file_format && `(${result.file_format})`}</small>}</div>)}
          </article>
        })}</div>
      </Surface>
      <EntryForm title="Order a lab test" description="Test charges are included when the appointment invoice is calculated." buttonLabel="Create lab order"
        initial={{ appointment_id: '', test_catalog_id: '', order_date: '', priority: 'Routine' }}
        fields={[
          { name: 'appointment_id', label: 'Appointment', options: data.appointments.map((a) => ({ value: a.appointment_id, label: `${a.appointment_id} · ${a.patient_name}` })) },
          { name: 'test_catalog_id', label: 'Test', options: data.catalog.map((t) => ({ value: t.test_catalog_id, label: `${t.test_name} · ${formatCurrency(t.standard_cost)}` })) },
          { name: 'order_date', label: 'Order date', type: 'date' },
          { name: 'priority', label: 'Priority', options: ['Routine', 'Urgent', 'Stat'].map((value) => ({ value, label: value })) },
        ]}
        onSubmit={async (values) => { const result = await api.createLabOrder(values); await reload(); return `Lab order ${result.order_id} created.` }} />
      <EntryForm title="Record a test result" description="Additional results are retained as separate entries for the order." buttonLabel="Save test result"
        initial={{ order_id: '', report_date: '', result_value: '', technician_remarks: '', document_url: '', file_format: '' }}
        fields={[
          { name: 'order_id', label: 'Lab order', options: data.orders.map((o) => ({ value: o.order_id, label: `${o.order_id} · ${o.patient_name} · ${o.test_name}` })) },
          { name: 'report_date', label: 'Report date', type: 'date' },
          { name: 'result_value', label: 'Result (include units if applicable)', maxLength: 100, wide: true },
          { name: 'technician_remarks', label: 'Remarks', type: 'textarea', maxLength: 200, required: false, wide: true },
          { name: 'document_url', label: 'Document reference (no file upload)', required: false, maxLength: 2048 },
          { name: 'file_format', label: 'File format', required: false, maxLength: 10 },
        ]}
        onSubmit={async (values) => { await api.createTestResult(values); await reload(); return 'Test result saved.' }} />
    </>}
  </main>
}
