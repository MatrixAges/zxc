import { globSync, readFileSync } from 'node:fs'
import { join } from 'node:path'
import { parseArgs } from 'node:util'
import { parseDocument } from 'yaml'
import { sha256, withArchive } from './shared/archive.ts'
import { writeOutput } from './shared/catalog.ts'
import { stringify } from './shared/json.ts'
import { readIndex } from './shared/upstream.ts'

type Metadata = {
	metadata_status: string
	metadata_error?: string
	features?: Array<string>
	negative?: { phase: string; type: string }
	[key: string]: unknown
}
type Entry = Metadata & { path: string; sha256: string }

export function metadata(source: Buffer): Metadata {
	const text = new TextDecoder('utf-8', { fatal: true })
	const start = source.indexOf('/*---')
	const end = source.indexOf('---*/', start + 5)

	if (start === -1 || end === -1) return { metadata_status: 'missing' }

	try {
		const document = parseDocument(text.decode(source.subarray(start + 5, end)).replace(/\r\n?/g, '\n'), {
			version: '1.1',
			uniqueKeys: true
		})
		if (document.errors.length) throw document.errors[0]

		const record: unknown = document.toJS()
		if (!record || typeof record !== 'object' || Array.isArray(record))
			throw new Error('frontmatter must be a mapping')

		const fields = record as Record<string, unknown>
		const selected: Record<string, unknown> = {}

		for (const key of ['description', 'esid', 'es5id', 'features', 'flags', 'includes', 'negative']) {
			if (key in fields) selected[key] = fields[key]
		}

		for (const key of ['features', 'flags', 'includes']) {
			if (
				key in selected &&
				(!Array.isArray(selected[key]) || !selected[key].every(item => typeof item === 'string'))
			)
				throw new Error(`${key} must be a string list`)
		}

		if ('negative' in selected) {
			const negative = selected.negative
			if (
				!negative ||
				typeof negative !== 'object' ||
				!('phase' in negative) ||
				!('type' in negative) ||
				typeof negative.phase !== 'string' ||
				typeof negative.type !== 'string'
			)
				throw new Error('negative must provide string phase and type')
		}

		stringify(selected)

		return { metadata_status: 'parsed', ...selected }
	} catch (error) {
		return { metadata_status: 'error', metadata_error: error instanceof Error ? error.message : String(error) }
	}
}

function main(): void {
	const { positionals } = parseArgs({ allowPositionals: true, options: { check: { type: 'boolean' } } })
	if (positionals.length !== 1) throw new Error('usage: node src/inventory_upstream.ts ARCHIVE [--check]')

	const indexed = readIndex()

	withArchive({
		path: positionals[0],
		visit(root) {
			const groups: Record<string, Array<Entry>> = {}
			const seen = new Set<string>()

			for (const path of globSync('test/**/*.js', { cwd: root }).sort()) {
				if (!indexed.has(path)) continue

				const source = readFileSync(join(root, path))
				const digest = sha256(source)
				if (seen.has(path) || digest !== indexed.get(path))
					throw new Error(`duplicate or changed upstream source: ${path}`)
				seen.add(path)

				const group = path.split('/')[1]
				;(groups[group] ??= []).push({ path, sha256: digest, ...metadata(source) })
			}

			if (seen.size !== indexed.size) throw new Error('metadata inventory is incomplete')

			const statuses: Record<string, number> = {}
			const features: Record<string, number> = {}
			const phases: Record<string, number> = {}

			for (const [group, rows] of Object.entries(groups)) {
				writeOutput(`upstream/metadata/${group}.jsonl`, rows.map(row => stringify(row) + '\n').join(''))

				for (const row of rows) {
					statuses[row.metadata_status] = (statuses[row.metadata_status] ?? 0) + 1
					for (const feature of new Set(row.features ?? [])) features[feature] = (features[feature] ?? 0) + 1

					const phase = row.negative?.phase ?? 'not-negative'
					phases[phase] = (phases[phase] ?? 0) + 1
				}
			}

			console.log(
				JSON.stringify(
					{
						files: seen.size,
						metadata_status: statuses,
						negative_phases: phases,
						largest_feature_groups: Object.entries(features)
							.sort((left, right) => right[1] - left[1])
							.slice(0, 15),
						review_decisions_added: 0,
						tests_executed: 0
					},
					null,
					2
				)
			)
		}
	})
}

if (import.meta.main) main()
