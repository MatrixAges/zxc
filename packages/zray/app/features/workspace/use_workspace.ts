import type { Iteration, Run, Workspace } from '../../../shared/types'
import { useCallback, useEffect, useState } from 'react'
import rpc from '@/lib/rpc'

export default function useWorkspace() {
	const [versions, setVersions] = useState<{ zig: string | null; zxc: string | null }>()
	const [workspace, setWorkspace] = useState<Workspace>()
	const [runs, setRuns] = useState<Array<Run>>([])
	const [iterations, setIterations] = useState<Array<Iteration>>([])
	const [error, setError] = useState('')
	const [connection_error, setConnectionError] = useState('')

	const refresh = useCallback(async () => {
		try {
			const [data, versions] = await Promise.all([rpc.workspace.list.query(), rpc.workspace.versions.query()])
			setWorkspace(data)
			setVersions(versions)
			setError('')
		} catch (error) {
			setError(String(error))
		}
	}, [])

	useEffect(() => {
		const controller = new AbortController()
		let timer: ReturnType<typeof setTimeout>

		const poll = async () => {
			try {
				const [runs, iterations] = await Promise.all([
					rpc.execution.list.query(undefined, { signal: controller.signal }),
					rpc.iterations.list.query(undefined, { signal: controller.signal })
				])
				setRuns(runs)
				setIterations(iterations)
				setConnectionError('')
			} catch (error) {
				if (!controller.signal.aborted) setConnectionError(String(error))
			}
			if (!controller.signal.aborted) timer = setTimeout(poll, 1500)
		}

		Promise.all([
			rpc.workspace.list.query(undefined, { signal: controller.signal }),
			rpc.workspace.versions.query(undefined, { signal: controller.signal })
		])
			.then(([workspace, versions]) => {
				setWorkspace(workspace)
				setVersions(versions)
			})
			.catch(error => {
				if (!controller.signal.aborted) setError(String(error))
			})
		poll()
		return () => {
			controller.abort()
			clearTimeout(timer)
		}
	}, [])

	return { workspace, versions, runs, iterations, error: error || connection_error, refresh }
}
