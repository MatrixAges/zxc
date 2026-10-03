import type { ChildProcess } from 'node:child_process'
import { execFile } from 'node:child_process'
import { promisify } from 'node:util'

export const execFileAsync = promisify(execFile)

export function stopProcess(child: ChildProcess) {
	if (!child.pid) return

	try {
		process.kill(-child.pid, 'SIGTERM')
	} catch (error) {
		if ((error as NodeJS.ErrnoException).code !== 'ESRCH') throw error
	}

	const timeout = setTimeout(() => {
		try {
			process.kill(-child.pid!, 'SIGKILL')
		} catch (error) {
			if ((error as NodeJS.ErrnoException).code !== 'ESRCH') console.error(error)
		}
	}, 3000)

	child.once('close', () => clearTimeout(timeout))
	timeout.unref()
}
