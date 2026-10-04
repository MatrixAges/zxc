import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/property_remaining.jsonl'))
const base = 'language/expressions/property_whitespace'
const gaps = ['\t', '\v', '\f', ' ', '\n', '\r']
const branches = gaps.map((gap, index) => `    case ${index}:\n      return in${gap}.${gap}value`).join('\n')

writeOutput(`tests/${base}/cases.zx`, `export type Input = { kind: u64, value: i64 }\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  switch (in.kind) {\n${branches}\n    default:\n      return in.value\n  }\n}\n`)
writeCatalog(`tests/${base}/cases.jsonl`, gaps.flatMap((_, kind) => [-7, 9].map(value => ({ id: `${base}/${kind}/${value}`, input: { kind, value }, expected: { value } }))))

const rows = ['\u00a0', '\u2028', '\u2029', '\t\v\f \u00a0\n\r\u2028\u2029'].map((gap, index) => {
	const source = `export type Input = { value: i64 }\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  return in${gap}.${gap}value\n}\n`
	const character = [...gap].find(value => value.charCodeAt(0) > 127)!
	const start = Buffer.byteLength(source.slice(0, source.indexOf(character)))

	return { id: `${base}/unicode/${index}`, source, phase: 'parse', diagnostic: 'lexical', span: [start, start + 1] }
})

writeCatalog(`tests/${base}/unicode.jsonl`, rows)
writeCatalog('upstream/reviews/language/expressions/property_remaining.jsonl', samples.map(sample => ({
	...sample, status: 'excluded', contract: 'packages/core/IR契约.md', cases: [],
})))
