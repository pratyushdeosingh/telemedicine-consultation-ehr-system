import {
  Activity,
  CalendarDays,
  CircleDollarSign,
  FileHeart,
  GitBranch,
  LayoutDashboard,
  PanelLeftClose,
  PanelLeftOpen,
  UsersRound,
} from 'lucide-react'
import { useState } from 'react'
import { NavLink, Outlet, useLocation } from 'react-router-dom'
import { ConnectionStatus } from './ConnectionStatus.jsx'

const navigation = [
  { to: '/', label: 'Overview', icon: LayoutDashboard },
  { to: '/patients', label: 'Patients', icon: UsersRound },
  { to: '/appointments', label: 'Appointments', icon: CalendarDays },
  { to: '/prescriptions', label: 'Prescriptions', icon: FileHeart },
  { to: '/billing', label: 'Billing', icon: CircleDollarSign },
  { to: '/system-flow', label: 'System flow', icon: GitBranch },
]

function NavigationLink({ item, compact = false }) {
  const Icon = item.icon

  return (
    <NavLink
      to={item.to}
      end={item.to === '/'}
      className={({ isActive }) => `nav-link${isActive ? ' is-active' : ''}`}
      aria-label={compact ? item.label : undefined}
      title={compact ? item.label : undefined}
    >
      <Icon aria-hidden="true" size={19} strokeWidth={1.9} />
      {!compact && <span>{item.label}</span>}
    </NavLink>
  )
}

function Brand({ compact }) {
  return (
    <NavLink className="brand" to="/" aria-label="Care Continuum overview">
      <span className="brand-mark" aria-hidden="true">
        <Activity size={20} strokeWidth={2.2} />
      </span>
      {!compact && (
        <span className="brand-copy">
          <strong>Care Continuum</strong>
          <small>Telemedicine EHR</small>
        </span>
      )}
    </NavLink>
  )
}

export function AppShell({ onLogout }) {
  const [isCompact, setIsCompact] = useState(false)
  const location = useLocation()
  const activeItem = navigation.find((item) => item.to === location.pathname)
  const today = new Intl.DateTimeFormat('en-IN', {
    weekday: 'short',
    day: 'numeric',
    month: 'short',
  }).format(new Date())

  return (
    <div className={`app-shell${isCompact ? ' is-compact' : ''}`}>
      <aside className="sidebar">
        <Brand compact={isCompact} />
        <nav className="primary-nav" aria-label="Primary navigation">
          {navigation.map((item) => (
            <NavigationLink key={item.to} item={item} compact={isCompact} />
          ))}
        </nav>

        <div className="sidebar-footer">
          {!isCompact && (
            <div className="privacy-note">
              <span className="privacy-dot" />
              <span>
                <strong>Demo workspace</strong>
                <small>Academic prototype</small>
              </span>
            </div>
          )}
          <button
            className="sidebar-toggle"
            type="button"
            onClick={() => setIsCompact((current) => !current)}
            aria-label={isCompact ? 'Expand navigation' : 'Collapse navigation'}
          >
            {isCompact ? <PanelLeftOpen size={18} /> : <PanelLeftClose size={18} />}
          </button>
        </div>
      </aside>

      <section className="workspace">
        <header className="topbar">
          <div>
            <span className="topbar-context">Clinical operations</span>
            <strong>{activeItem?.label ?? 'Overview'}</strong>
          </div>
          <div className="topbar-actions">
            <span className="date-chip">{today}</span>
            <ConnectionStatus />
            <button className="logout-button" type="button" onClick={onLogout}>Sign out</button>
          </div>
        </header>
        <div className="page-frame">
          <Outlet />
        </div>
      </section>

      <nav className="mobile-nav" aria-label="Mobile navigation">
        {navigation.slice(0, 5).map((item) => (
          <NavigationLink key={item.to} item={item} compact />
        ))}
      </nav>
    </div>
  )
}
