'use client'

import { useState } from 'react'

export default function CopyPrompt({
	labels,
	prompt,
	docs_href
}: {
	labels: { idle: string; success: string; error: string }
	prompt: string
	docs_href: string
}) {
	const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle')

	async function copyPrompt() {
		const docs_url = new URL(docs_href, window.location.origin).href

		try {
			await navigator.clipboard.writeText(prompt.replace('__DOCS_URL__', docs_url))
			setStatus('success')
		} catch {
			setStatus('error')
		}
	}

	return (
		<button type='button' className='text-button' onClick={copyPrompt} aria-live='polite'>
			[ {labels[status]} ]
		</button>
	)
}
