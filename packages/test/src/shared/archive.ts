import { execFileSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { mkdtempSync, readFileSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { readLock } from './upstream.ts'

export function sha256(content: Buffer): string {
	return createHash('sha256').update(content).digest('hex')
}

export function withArchive(args: { path: string; visit: (root: string) => void }): void {
	const { path, visit } = args
	const lock = readLock()
	const archive = resolve(path)

	if (sha256(readFileSync(archive)) !== lock.archive_sha256)
		throw new Error('archive SHA-256 does not match upstream/lock.json')

	const temporary = mkdtempSync(join(tmpdir(), 'zxc-test262-'))

	try {
		execFileSync('tar', ['-xzf', archive, '-C', temporary], { stdio: 'pipe' })
		visit(join(temporary, `test262-${lock.revision}`))
	} finally {
		rmSync(temporary, { recursive: true, force: true })
	}
}
