import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; kind: string; reason: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/object_shorthand.jsonl'))
const frontend = []
const runtime = [2, 0, 255].map((input, index) => ({ id: `language/expressions/object_shorthand/duplicate/${index}`, input, expected: { value: input } }))

writeOutput('tests/language/expressions/object_construction/shorthand_duplicate.zx', 'export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const value = in;\n  const object = { value, value, };\n\n  return object.value;\n}\n')
writeCatalog('tests/language/expressions/object_construction/shorthand_duplicate.jsonl', runtime)

for (const sample of samples.filter(sample => ['computed', 'numeric'].includes(sample.kind))) {
	const expression = sample.kind === 'computed' ? '{[x]}' : '{0}'
	const declaration = sample.kind === 'computed' ? '  const x = "y";\n  const y: u64 = 42;\n\n' : ''
	const source = `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n${declaration}  const object = ${expression};\n\n  return true;\n}\n`
	const token = sample.kind === 'computed' ? '[' : '0'
	const start = source.indexOf(token, source.indexOf('const object'))

	frontend.push({ id: `language/types/object_shorthand/${sample.kind}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] })
}

const shapes = [
	{ name: 'single', expression: '{ missing }' },
	{ name: 'duplicate', expression: '{ missing, missing }' },
	{ name: 'overwritten', expression: '{ missing, missing: 1 }' },
	{ name: 'nested', expression: '{ outer: { missing } }' },
]

for (const shape of shapes) for (const bound of [false, true]) {
	const declaration = bound ? '  const missing: u64 = 2;\n\n' : ''
	const source = `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n${declaration}  const object = ${shape.expression};\n\n  return true;\n}\n`
	const start = source.indexOf('missing', source.indexOf('const object'))

	frontend.push({ id: `language/types/object_shorthand/${shape.name}/${bound ? 'bound' : 'unbound'}`, source, phase: 'analyze', diagnostic: bound ? null : 'name', ...bound ? {} : { span: [start, start + 7] } })
}

const proto_source = 'export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const __proto__ = in;\n  const object = { __proto__, __proto__, };\n\n  return object.__proto__;\n}\n'
const proto_start = proto_source.indexOf('__proto__')

frontend.push({ id: 'language/types/object_shorthand/proto_name', source: proto_source, phase: 'compile', diagnostic: 'naming', span: [proto_start, proto_start + 9] })
frontend.push({ id: 'language/types/object_shorthand/explicit_label', source: 'export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const object = { missing: 1 };\n\n  return object.missing;\n}\n', phase: 'compile', diagnostic: null })
writeCatalog('tests/language/types/object_shorthand/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/object_shorthand.jsonl', samples.map(sample => ({ path: sample.path, sha256: sample.sha256, status: sample.kind === 'excluded' ? 'excluded' : 'adapted', reason: sample.reason, contract: 'packages/zx/IR契约.md#表达式与求值', cases: sample.kind === 'proto' ? ['language/types/object_shorthand/proto_name'] : sample.kind === 'excluded' ? [] : [`language/types/object_shorthand/${sample.kind}`] })))
