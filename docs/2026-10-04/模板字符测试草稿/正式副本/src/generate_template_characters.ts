import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { expression: string; expected: string }
type Group = { path: string; sha256: string; reason: string; samples: Array<Sample> }

const groups = readRows<Group>(resolve(package_dir, 'src/data/template_characters.jsonl'))
const samples = groups.flatMap(group => group.samples)
const path = 'tests/language/expressions/template_characters/literals'
const branches = samples.map((sample, index) => `    case ${index}:\n      return ${sample.expression}`).join('\n')
const runtime = samples.map((sample, index) => ({ id: `language/expressions/template_characters/literals/${index}`, input: index, expected: { value: sample.expected } }))

writeOutput(`${path}.zx`, `export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in) {\n${branches}\n    default:\n      return ""\n  }\n}\n`)
writeCatalog(`${path}.jsonl`, runtime)

const dynamic_path = 'tests/language/expressions/template_characters/escaped_interpolation'
const expression = '`start \\${ignored} ${in} end`'

writeOutput(`${dynamic_path}.zx`, `export type Input = i64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`)
writeCatalog(`${dynamic_path}.jsonl`, [-1, 0, 1].map(input => ({ id: `language/expressions/template_characters/escaped_interpolation/${input}`, input, expected: { value: 'start ${ignored} ' + String(input) + ' end' } })))

let offset = 0

writeCatalog('upstream/reviews/language/expressions/template_characters.jsonl', groups.map(group => {
	const cases = runtime.slice(offset, offset + group.samples.length)

	offset += group.samples.length

	return {
		path: group.path, sha256: group.sha256, status: 'adapted', reason: group.reason,
		contract: 'packages/compiler/src/zx/frontend/template.zig',
		cases: cases.map(row => row.id),
		assertions: cases.map(row => ({ case: row.id, field: 'value', expected: row.expected.value })),
	}
}))
