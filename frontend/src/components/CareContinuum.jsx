import { ArrowRight, CalendarDays, CircleDollarSign, FileHeart, UsersRound } from 'lucide-react'

const stages = [
  { key: 'patients', label: 'Patients', caption: 'Identity established', icon: UsersRound },
  { key: 'appointments', label: 'Appointments', caption: 'Care scheduled', icon: CalendarDays },
  { key: 'prescriptions', label: 'Prescriptions', caption: 'Treatment recorded', icon: FileHeart },
  { key: 'billing', label: 'Invoices', caption: 'Care reconciled', icon: CircleDollarSign },
]

export function CareContinuum({ counts }) {
  return (
    <div className="continuum" aria-label="Patient care data journey">
      {stages.map((stage, index) => {
        const Icon = stage.icon
        return (
          <div className="continuum-segment" key={stage.key}>
            <div className="continuum-node">
              <span><Icon size={18} /></span>
              <strong>{counts[stage.key]}</strong>
              <small>{stage.label}</small>
              <em>{stage.caption}</em>
            </div>
            {index < stages.length - 1 && <ArrowRight className="continuum-arrow" size={17} aria-hidden="true" />}
          </div>
        )
      })}
    </div>
  )
}
