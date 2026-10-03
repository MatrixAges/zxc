'use client'

import type { ReactNode } from 'react'
import { useEffect, useId, useRef, useState } from 'react'

export default function DocsDrawer({
	children,
	label,
	close_label
}: {
	children: ReactNode
	label: string
	close_label: string
}) {
	const dialog_ref = useRef<HTMLDialogElement>(null)
	const dialog_id = useId()
	const [open, setOpen] = useState(false)

	function openDrawer() {
		dialog_ref.current?.showModal()
		setOpen(true)
	}

	function closeDrawer() {
		dialog_ref.current?.close()
	}

	useEffect(() => {
		const desktop = window.matchMedia('(min-width: 801px)')

		function updateViewport() {
			if (desktop.matches) dialog_ref.current?.close()
		}

		desktop.addEventListener('change', updateViewport)
		return () => desktop.removeEventListener('change', updateViewport)
	}, [])

	return (
		<>
			<aside className='docs-desktop-navigation'>{children}</aside>
			<button
				type='button'
				className='docs-drawer-trigger text-button'
				aria-haspopup='dialog'
				aria-controls={dialog_id}
				aria-expanded={open}
				onClick={openDrawer}
			>
				<span aria-hidden='true'>☰</span> {label}
			</button>
			<dialog
				ref={dialog_ref}
				id={dialog_id}
				className='docs-drawer'
				aria-labelledby={`${dialog_id}-title`}
				onClose={() => setOpen(false)}
				onClick={event => {
					if (
						event.target === event.currentTarget ||
						(event.target instanceof Element && event.target.closest('a'))
					)
						closeDrawer()
				}}
			>
				<div className='docs-drawer-panel'>
					<header className='docs-drawer-header'>
						<span id={`${dialog_id}-title`}>{label}</span>
						<button type='button' className='text-button' aria-label={close_label} onClick={closeDrawer}>
							<span aria-hidden='true'>×</span>
						</button>
					</header>
					{children}
				</div>
			</dialog>
		</>
	)
}
