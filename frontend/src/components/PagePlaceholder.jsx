export function PagePlaceholder({ eyebrow, title, description }) {
  return (
    <main className="foundation-page">
      <section className="foundation-card">
        <small>{eyebrow}</small>
        <h1>{title}</h1>
        <p>{description}</p>
      </section>
    </main>
  )
}
