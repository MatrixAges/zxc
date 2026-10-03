import { parseArgs } from 'node:util'
import { jsonFiles } from './shared/files.ts'
import { readRows, stringify } from './shared/json.ts'
import { readIndex, readMetadata } from './shared/upstream.ts'

const { values } = parseArgs({
	options: {
		feature: { type: 'string', multiple: true, default: [] },
		phase: { type: 'string' },
		prefix: { type: 'string', default: 'test/' },
		limit: { type: 'string', default: '20' }
	}
})
const limit = Number(values.limit)

if (!Number.isSafeInteger(limit) || limit < 1) throw new Error('--limit must be a positive integer')
if (values.phase && !['parse', 'resolution', 'runtime', 'not-negative'].includes(values.phase))
	throw new Error('invalid --phase')

const reviewed = new Set(
	jsonFiles('upstream/reviews').flatMap(path => readRows<{ path: string }>(path).map(row => row.path))
)
const metadata_rows = readMetadata(readIndex())
let matched = 0

for (const row of metadata_rows) {
	if (reviewed.has(row.path) || !row.path.startsWith(values.prefix)) continue
	if (!values.feature.every(feature => row.features?.includes(feature))) continue
	if (values.phase && (row.negative?.phase ?? 'not-negative') !== values.phase) continue

	matched++
	if (matched <= limit) console.log(stringify(row))
}

console.error(JSON.stringify({ matched_unreviewed: matched, shown: Math.min(matched, limit), decisions_added: 0 }))
