export function Surface({ as: Element = 'section', className = '', children, ...props }) {
  return (
    <Element className={`surface ${className}`.trim()} {...props}>
      {children}
    </Element>
  )
}
