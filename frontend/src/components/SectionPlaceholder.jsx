import { PageHeader } from './PageHeader.jsx'
import { Surface } from './Surface.jsx'

export function SectionPlaceholder({ eyebrow, title, description }) {
  return (
    <main className="page">
      <PageHeader eyebrow={eyebrow} title={title} description={description} />
      <Surface className="empty-canvas">
        <span>Interface module ready</span>
        <strong>Data view arrives in the next step.</strong>
      </Surface>
    </main>
  )
}
