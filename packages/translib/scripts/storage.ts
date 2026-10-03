import { randomUUID } from 'node:crypto'
import { existsSync, mkdirSync, readFileSync, renameSync, rmSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { readJson, record } from './values'

export function write(path: string, value: unknown) {
	mkdirSync(dirname(path), { recursive: true })

	const temporary = resolve(dirname(path), `.pending-${randomUUID()}`)

	try {
		writeFileSync(temporary, JSON.stringify(value, null, 2) + '\n', { flag: 'wx' })
		renameSync(temporary, path)
	} finally {
		rmSync(temporary, { force: true })
	}
}

export function read(path: string): Record<string, unknown> | null {
	return existsSync(path) ? record(readJson(readFileSync(path, 'utf8'))) : null
}
