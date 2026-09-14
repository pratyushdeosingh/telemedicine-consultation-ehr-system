import { Search, X } from 'lucide-react'

export function SearchField({ value, onChange, placeholder = 'Search records' }) {
  return (
    <label className="search-field">
      <Search size={17} aria-hidden="true" />
      <span className="sr-only">{placeholder}</span>
      <input value={value} onChange={(event) => onChange(event.target.value)} placeholder={placeholder} />
      {value && <button type="button" onClick={() => onChange('')} aria-label="Clear search"><X size={15} /></button>}
    </label>
  )
}
