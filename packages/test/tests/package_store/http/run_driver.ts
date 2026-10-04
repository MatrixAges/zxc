import { spawn } from 'node:child_process'
import { resolve } from 'node:path'

const executable = resolve(process.argv[2])

export default function runDriver(args: { source: string, sha256: string, cache: string, offline?: boolean }): Promise<{ status: number | null, output: string, error: string }> {
	const { source, sha256, cache, offline = false } = args

	return new Promise((resolve, reject) => {
		const child = spawn(executable, [source, sha256, cache, String(offline)], { timeout: 15_000 })
		let output = ''
		let error = ''

		child.stdout.on('data', (data: Buffer) => { output += data.toString() })
		child.stderr.on('data', (data: Buffer) => { error += data.toString() })
		child.on('error', reject)
		child.on('close', (status, signal) => {
			if (signal !== null) reject(new Error(`driver terminated by ${signal}: ${error}`))
			else resolve({ status, output: output.trim(), error })
		})
	})
}
