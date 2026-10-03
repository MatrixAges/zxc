import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { package_dir } from './catalog.ts'
import { jsonFiles } from './files.ts'
import { parseJson, readRows } from './json.ts'

export type IndexEntry = { path: string; sha256: string }
export type MetadataEntry = IndexEntry & {
	metadata_status: string
	features?: Array<string>
	negative?: { phase: string; type: string }
}
export type Lock = { revision: string; archive_sha256: string; test_files: Record<string, number> }

export function readLock(): Lock {
	return parseJson<Lock>(readFileSync(resolve(package_dir, 'upstream/lock.json'), 'utf8'))
}

export function readIndex(): Map<string, string> {
	const indexed = new Map<string, string>()

	for (const path of jsonFiles('upstream/index')) {
		for (const row of readRows<IndexEntry>(path)) {
			if (indexed.has(row.path)) throw new Error(`duplicate upstream path: ${row.path}`)
			indexed.set(row.path, row.sha256)
		}
	}

	return indexed
}

export function readMetadata(indexed: Map<string, string>): Array<MetadataEntry> {
	const files = jsonFiles('upstream/metadata')
	if (!files.length) throw new Error('metadata facts are absent; run inventory_upstream.ts first')

	const seen = new Set<string>()
	const rows = []

	for (const path of files) {
		for (const row of readRows<MetadataEntry>(path)) {
			if (seen.has(row.path) || indexed.get(row.path) !== row.sha256)
				throw new Error(`duplicate, missing or stale metadata: ${row.path}`)
			seen.add(row.path)
			rows.push(row)
		}
	}

	if (seen.size !== indexed.size) throw new Error('metadata inventory does not match the complete upstream index')

	return rows
}
