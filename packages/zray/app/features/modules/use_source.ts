import { useEffect, useState } from 'react'
import rpc from '@/lib/rpc'

export default function useSource(path: string) {
	const [source, setSource] = useState({ path: '', content: '', error: '' })

	useEffect(() => {
		if (!path) return
		const controller = new AbortController()
		rpc.workspace.source
			.query({ path }, { signal: controller.signal })
			.then(data => setSource({ path, content: data.content, error: '' }))
			.catch(error => {
				if (!controller.signal.aborted) setSource({ path, content: '', error: String(error) })
			})
		return () => controller.abort()
	}, [path])

	return { ...source, loaded: source.path === path }
}
