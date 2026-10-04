import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; status: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/property_lookup.jsonl'))
const base = 'language/expressions/property_lookup'
const original = `${base}/own_field`
const invalid = `export type Input = void\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return unresolvableReference.""\n}\n`
const start = invalid.indexOf('""')
const rejected = { id: `${base}/dot_string`, source: invalid, phase: 'parse', diagnostic: 'syntax', span: [start, start + 2] }

writeOutput(`tests/${original}.zx`, 'export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  const map = { shape: "cube" }\n\n  return map.shape\n}\n')
writeCatalog(`tests/${original}.jsonl`, [{ id: original, input: 0, expected: { value: 'cube' } }])
writeCatalog(`tests/${base}/syntax.jsonl`, [rejected, {
	id: `${base}/dot_identifier`,
	source: 'export type Input = { shape: string }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return in.shape\n}\n',
	phase: 'analyze', diagnostic: null,
}])
writeCatalog('upstream/reviews/language/expressions/property_lookup.jsonl', samples.map(sample => ({
	path: sample.path, sha256: sample.sha256, status: sample.status, reason: sample.reason,
	contract: 'packages/compiler/src/zx/frontend/parser_expressions.zig',
	cases: sample.name === 'S8.12.3_A3' ? [original] : sample.name === 'non-identifier-name' ? [rejected.id] : [],
	...(sample.name === 'S8.12.3_A3' ? { assertions: [{ case: original, field: 'value', expected: 'cube' }] } : {}),
	...(sample.name === 'non-identifier-name' ? { diagnostics: [{ case: rejected.id, phase: rejected.phase, code: rejected.diagnostic, span: rejected.span }] } : {}),
})))
