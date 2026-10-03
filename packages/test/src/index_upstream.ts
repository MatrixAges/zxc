import type { IndexEntry } from './shared/upstream.ts'
import { globSync, readFileSync } from 'node:fs'
import { basename, join } from 'node:path'
import { parseArgs } from 'node:util'
import { sha256, withArchive } from './shared/archive.ts'
import { writeOutput } from './shared/catalog.ts'
import { jsonLines } from './shared/json.ts'

const { positionals } = parseArgs({ allowPositionals: true, options: { check: { type: 'boolean' } } })
if (positionals.length !== 1) throw new Error('usage: node src/index_upstream.ts ARCHIVE [--check]')

withArchive({
	path: positionals[0],
	visit(root) {
		const groups: Record<string, Array<IndexEntry>> = {}

		for (const path of globSync('test/**/*.js', { cwd: root }).sort()) {
			if (basename(path).includes('_FIXTURE')) continue

			const group = path.split('/')[1]
			;(groups[group] ??= []).push({ path, sha256: sha256(readFileSync(join(root, path))) })
		}

		writeOutput('upstream/LICENSE', readFileSync(join(root, 'LICENSE')))

		for (const [name, entries] of Object.entries(groups)) {
			if (new Set(entries.map(row => row.path)).size !== entries.length)
				throw new Error(`duplicate upstream path in ${name}`)
			writeOutput(`upstream/index/${name}.jsonl`, jsonLines(entries))
		}

		console.log(
			JSON.stringify(Object.fromEntries(Object.entries(groups).map(([name, entries]) => [name, entries.length])))
		)
		console.log(
			`indexed files: ${Object.values(groups).reduce((sum, entries) => sum + entries.length, 0)}; executed tests: 0`
		)
	}
})
