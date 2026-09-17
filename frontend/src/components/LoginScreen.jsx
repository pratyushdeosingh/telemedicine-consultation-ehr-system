import { useState } from 'react'

export function LoginScreen({ onLogin }) {
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [working, setWorking] = useState(false)

  async function submit(event) {
    event.preventDefault()
    setWorking(true)
    setError('')
    try {
      await onLogin(password)
      setPassword('')
    } catch (err) {
      setError(err.message)
    } finally {
      setWorking(false)
    }
  }

  return (
    <main className="login-screen">
      <form className="login-card" onSubmit={submit}>
        <span className="login-eyebrow">Academic demonstration</span>
        <h1>Care Continuum</h1>
        <p>Enter the demo password to view synthetic telemedicine records.</p>
        <label htmlFor="demo-password">Demo password</label>
        <input
          id="demo-password"
          type="password"
          autoComplete="current-password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          required
        />
        {error && <p className="login-error" role="alert">{error}</p>}
        <button type="submit" disabled={working}>{working ? 'Signing in…' : 'Sign in'}</button>
      </form>
    </main>
  )
}
