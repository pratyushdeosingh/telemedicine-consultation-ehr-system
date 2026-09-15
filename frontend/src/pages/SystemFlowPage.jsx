import { ArrowDown, Braces, Code2, Database, GitBranch, ServerCog } from 'lucide-react'
import { PageHeader } from '../components/PageHeader.jsx'
import { Surface } from '../components/Surface.jsx'

const layers = [
  { icon: Code2, step: '01', title: 'React interface', text: 'Routes render focused views and user interactions update local component state.', tech: 'React · Router · CSS' },
  { icon: Braces, step: '02', title: 'Fetch request', text: 'The API client sends an HTTP GET request to a named Express endpoint.', tech: 'JSON · HTTP' },
  { icon: ServerCog, step: '03', title: 'Express API', text: 'A route executes parameterized Oracle SQL and maps result rows into readable objects.', tech: 'Express · node-oracledb' },
  { icon: Database, step: '04', title: 'Oracle database', text: 'Primary keys, foreign keys, joins, functions, procedures, and triggers protect the data model.', tech: 'SQL · PL/SQL · 18 tables' },
]

const endpoints = [
  ['/api/test-db', 'Connection health', 'DUAL'],
  ['/api/patients', 'Patient directory', 'PATIENT'],
  ['/api/appointments', 'Consultation schedule', 'APPOINTMENT + PATIENT + DOCTOR + DEPARTMENT'],
  ['/api/prescriptions', 'Medication details', 'PRESCRIPTION + PRESCRIPTION_ITEM + MEDICINE'],
  ['/api/billing', 'Invoice reconciliation', 'BILLING_INVOICE + Calculate_Invoice_Total'],
]

export function SystemFlowPage() {
  return (
    <main className="page">
      <PageHeader eyebrow="Architecture" title="From a click to an Oracle row." description="This screen explains the complete request cycle used by every live view in the application." />

      <div className="flow-stack">
        {layers.map((layer, index) => {
          const Icon = layer.icon
          return (
            <div className="flow-step" key={layer.step}>
              <Surface>
                <span className="flow-number">{layer.step}</span>
                <span className="flow-icon"><Icon size={21} /></span>
                <div><strong>{layer.title}</strong><p>{layer.text}</p><small>{layer.tech}</small></div>
              </Surface>
              {index < layers.length - 1 && <ArrowDown className="flow-arrow" size={18} />}
            </div>
          )
        })}
      </div>

      <Surface className="contract-panel">
        <header><span><GitBranch size={18} /></span><div><strong>Confirmed API contract</strong><small>The frontend depends only on routes already supplied by Member 2.</small></div></header>
        <div className="contract-table">
          {endpoints.map(([endpoint, purpose, source]) => <div key={endpoint}><code>GET {endpoint}</code><span>{purpose}</span><small>{source}</small></div>)}
        </div>
      </Surface>
    </main>
  )
}
