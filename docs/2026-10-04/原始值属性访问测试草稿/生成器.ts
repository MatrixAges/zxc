import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; adapted: boolean; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/property_primitives.jsonl'))
const id = 'language/expressions/property_primitives/string_length'

writeOutput(`tests/${id}.zx`, 'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return "abc123".length\n}\n')
writeCatalog(`tests/${id}.jsonl`, [{ id, input: 0, expected: { value: 6 } }])
writeCatalog('upstream/reviews/language/expressions/property_primitives.jsonl', samples.map(sample => ({
	path: sample.path, sha256: sample.sha256, reason: sample.reason,
	status: sample.adapted ? 'adapted' : 'excluded',
	contract: 'packages/core/IR契约.md',
	cases: sample.adapted ? [id] : [],
	assertions: sample.adapted ? [{ case: id, field: 'value', expected: 6 }] : [],
})))
