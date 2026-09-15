export function ActionFeedback({ feedback }) {
  if (!feedback) return null

  return (
    <div className={`action-feedback is-${feedback.type}`} role={feedback.type === 'error' ? 'alert' : 'status'}>
      {feedback.message}
    </div>
  )
}
