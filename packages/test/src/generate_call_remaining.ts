import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/call_remaining.jsonl'))

writeCatalog('upstream/reviews/language/expressions/call_remaining.jsonl', samples.map(sample => ({
	...sample, status: 'excluded', contract: 'packages/core/IR契约.md', cases: [],
})))
