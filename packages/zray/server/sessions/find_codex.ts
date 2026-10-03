import { access } from 'node:fs/promises'
import { homedir } from 'node:os'
import { join } from 'node:path'
import { constants } from 'node:fs'
import { execFileAsync } from '../processes.ts'

export default async function findCodex() {
	const candidates = ['codex']

	if (process.platform === 'darwin') {
		for (const directory of ['/Applications', join(homedir(), 'Applications')]) {
			for (const app of ['Codex.app', 'ChatGPT.app']) {
				for (const binary of ['codex', 'codex-cli/bin/codex']) {
					const path = join(directory, app, 'Contents/Resources', binary)
					try {
						await access(path, constants.X_OK)
						candidates.push(path)
					} catch {
						continue
					}
				}
			}
		}
	}

	let available: string | undefined

	for (const candidate of candidates) {
		try {
			await execFileAsync(candidate, ['--version'], { timeout: 5000 })
			available ??= candidate
			await execFileAsync(candidate, ['login', 'status'], { timeout: 5000 })
			return candidate
		} catch {
			continue
		}
	}

	return available ?? 'codex'
}
