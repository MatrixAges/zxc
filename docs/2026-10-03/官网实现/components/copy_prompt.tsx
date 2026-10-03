'use client'

import { useState } from 'react'

export default function CopyPrompt() {
	const [status, setStatus] = useState('copy agent prompt')

	async function copyPrompt() {
		const docs_url = new URL('/llms-full.txt', window.location.origin).href
		const prompt = `Use zxc for this task. Read ${docs_url} first. Confirm the available compiler and host runtime capabilities. Separate RX orchestration from ZX logic, keep dependencies acyclic, and report only checks you actually ran. Ask for the business goal and expected inputs and outputs if they are missing.`

		try {
			await navigator.clipboard.writeText(prompt)
			setStatus('copied')
		} catch {
			setStatus('copy unavailable — open plain text')
		}
	}

	return (
		<button type='button' className='text-button' onClick={copyPrompt} aria-live='polite'>
			[ {status} ]
		</button>
	)
}
