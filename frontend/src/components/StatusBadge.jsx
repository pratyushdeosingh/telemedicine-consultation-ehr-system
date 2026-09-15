export function StatusBadge({ children, tone = 'neutral' }) {
  return (
    <span className="status-badge" data-tone={tone}>
      <span aria-hidden="true" />
      {children}
    </span>
  )
}
