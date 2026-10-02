import { X } from 'lucide-react'
import { useEffect, type ReactNode } from 'react'

interface Props {
  title: string
  onClose: () => void
  footer: ReactNode
  children: ReactNode
}

export default function Modal({ title, onClose, footer, children }: Props) {
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose()
    document.addEventListener('keydown', onKey)
    document.body.style.overflow = 'hidden'
    return () => {
      document.removeEventListener('keydown', onKey)
      document.body.style.overflow = ''
    }
  }, [onClose])

  return (
    <div className="modal" onMouseDown={(e) => e.target === e.currentTarget && onClose()}>
      <div className="modal__box" role="dialog" aria-modal="true" aria-label={title}>
        <div className="modal__head">
          <h2 className="display h-md">{title}</h2>
          <button className="icon-btn" onClick={onClose} aria-label="Close">
            <X size={16} strokeWidth={1.5} />
          </button>
        </div>
        <div className="modal__body">{children}</div>
        <div className="modal__foot">{footer}</div>
      </div>
    </div>
  )
}
