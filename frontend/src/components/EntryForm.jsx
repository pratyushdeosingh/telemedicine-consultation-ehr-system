import { useState } from 'react'
import { ActionFeedback } from './ActionFeedback.jsx'
import { Surface } from './Surface.jsx'

export function EntryForm({ title, description, fields, initial, onSubmit, buttonLabel }) {
  const [values, setValues] = useState(initial)
  const [saving, setSaving] = useState(false)
  const [feedback, setFeedback] = useState(null)
  async function submit(event) {
    event.preventDefault()
    setSaving(true)
    setFeedback(null)
    try {
      const message = await onSubmit(values)
      setValues(initial)
      setFeedback({ type: 'success', message })
    } catch (error) {
      setFeedback({ type: 'error', message: error.message })
    } finally {
      setSaving(false)
    }
  }
  return (
    <Surface className="action-panel">
      <div className="action-panel-header"><div><strong>{title}</strong><small>{description}</small></div></div>
      <form className="record-form" onSubmit={submit}>
        <fieldset className="entry-fields" disabled={saving}>
          {fields.map((field) => {
            const props = { name: field.name, value: values[field.name] ?? (field.multiple ? [] : ''), required: field.required !== false,
              maxLength: field.maxLength, onChange: (event) => setValues((current) => ({ ...current, [field.name]: field.multiple ? Array.from(event.target.selectedOptions, (option) => option.value) : event.target.value })) }
            return <label key={field.name} className={field.wide ? 'form-span-2' : undefined}>
              <span>{field.label}{field.required !== false ? ' *' : ''}</span>
              {field.options ? <select {...props} multiple={field.multiple} size={field.multiple ? Math.max(2, Math.min(4, field.options.length)) : undefined}>{!field.multiple && <option value="">Select {field.label.toLowerCase()}</option>}{field.options.map((option) => <option key={option.value} value={option.value}>{option.label}</option>)}</select>
                : field.type === 'textarea' ? <textarea {...props} rows="3" /> : <input {...props} type={field.type ?? 'text'} list={field.list} />}
              {field.help && <small className="field-help">{field.help}</small>}
            </label>
          })}
        </fieldset>
        <div className="form-footer form-span-2"><ActionFeedback feedback={feedback} /><button className="primary-button" type="submit" disabled={saving}>{saving ? 'Saving…' : buttonLabel}</button></div>
      </form>
    </Surface>
  )
}
