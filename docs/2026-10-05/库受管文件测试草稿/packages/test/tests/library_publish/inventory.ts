import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { snapshot } from './fixture.ts'

export type File = { path: string; sha256: string }
export type Inventory = { format_version: number; managed_files?: Array<File>; bundled_files: Array<File> }

export default function readInventory(directory: string): Inventory {
	return JSON.parse(readFileSync(join(directory, 'library.json'), 'utf8')) as Inventory
}

export function checkInventory(directory: string): Array<File> {
	const metadata = readInventory(directory)
	assert.equal(metadata.format_version, 2)
	assert.ok(metadata.managed_files)
	const files = metadata.managed_files
	const paths = files.map(file => file.path)
	assert.deepEqual(paths, [...paths].sort())
	assert.equal(new Set(paths).size, paths.length)
	assert.deepEqual(
		paths,
		Object.keys(snapshot(directory))
			.filter(path => path !== 'library.json')
			.sort()
	)

	for (const file of files) {
		assert.match(file.sha256, /^[0-9a-f]{64}$/)
		assert.equal(
			createHash('sha256')
				.update(readFileSync(join(directory, file.path)))
				.digest('hex'),
			file.sha256
		)
	}

	return files
}
