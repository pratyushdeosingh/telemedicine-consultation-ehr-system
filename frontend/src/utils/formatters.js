export function formatDate(value, options = {}) {
  if (!value) return 'Not available'
  return new Intl.DateTimeFormat('en-IN', { day: 'numeric', month: 'short', year: 'numeric', ...options }).format(new Date(value))
}

export function getInitials(name = '') {
  return name.split(' ').filter(Boolean).slice(0, 2).map((part) => part[0]).join('').toUpperCase()
}

export function formatCurrency(value) {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 2,
  }).format(Number(value) || 0)
}

export function toneForStatus(status = '') {
  const normalized = status.toLowerCase()
  if (normalized === 'completed' || normalized === 'paid') return 'positive'
  if (normalized === 'scheduled' || normalized === 'pending') return 'warning'
  if (normalized === 'cancelled') return 'danger'
  return 'neutral'
}
