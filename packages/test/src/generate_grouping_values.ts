import type { Json } from './shared/json.ts'
import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; group: string | null }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/grouping_values.jsonl'))
const prefix = 'language/expressions/grouping_values'
const groups = [
	{ name: 'whitespace', type: 'u64', expressions: ['\t', '\v', '\f', ' ', '\n', '\r'].map(gap => '(' + gap + '1' + gap + ')'), values: [1, 1, 1, 1, 1, 1] },
	{ name: 'boolean', type: 'bool', expressions: ['(true)'], values: [true] },
	{ name: 'number', type: 'u64', expressions: ['(1)'], values: [1] },
	{ name: 'string', type: 'string', expressions: ['("1")', '("x")'], values: ['1', 'x'] },
	{ name: 'null', type: 'u64?', expressions: ['(null)'], values: [null] },
]

for (const group of groups) {
	const branches = group.expressions.map((expression, index) => `    case ${index}:\n      return ${expression}`).join('\n')

	writeOutput(`tests/${prefix}/original/${group.name}.zx`, `export type Input = u64\n\nexport type Output = ${group.type}\n\nexport default function (in: Input): Output {\n  switch (in) {\n${branches}\n    default:\n      return ${group.expressions[0]}\n  }\n}\n`)
	writeCatalog(`tests/${prefix}/original/${group.name}.jsonl`, group.values.map((value, input) => ({ id: `${prefix}/original/${group.name}/${input}`, input, expected: { value } })))
}

const dynamic: Array<{ name: string; type: string; inputs: Array<Json> }> = [
	{ name: 'boolean', type: 'bool', inputs: [false, true] },
	{ name: 'integer', type: 'i64', inputs: [-1, 0, 1] },
	{ name: 'string', type: 'string', inputs: ['', 'text', '中文'] },
	{ name: 'optional', type: 'bool?', inputs: [null, false, true] },
]

for (const group of dynamic) {
	writeOutput(`tests/${prefix}/dynamic/${group.name}.zx`, `export type Input = ${group.type}\n\nexport type Output = ${group.type}\n\nexport default function (in: Input): Output {\n  return (((in)))\n}\n`)
	writeCatalog(`tests/${prefix}/dynamic/${group.name}.jsonl`, group.inputs.map((input, index) => ({ id: `${prefix}/dynamic/${group.name}/${index}`, input, expected: { value: input } })))
}

const unsupported = ['\u00a0', '\u2028', '\u2029', '\t\v\f \u00a0\n\r\u2028\u2029'].map((gap, index) => {
	const source = `export type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return (${gap}1${gap})\n}\n`
	const character = [...gap].find(value => value.charCodeAt(0) > 127)!
	const start = Buffer.byteLength(source.slice(0, source.indexOf(character)))

	return { id: `${prefix}/unicode/${index}`, source, phase: 'parse', diagnostic: 'lexical', span: [start, start + 1] }
})

writeCatalog(`tests/${prefix}/unicode.jsonl`, unsupported)
writeCatalog('upstream/reviews/language/expressions/grouping_values.jsonl', samples.map(sample => {
	const group = groups.find(group => group.name === sample.group)
	const assertions = group?.values.map((value, index) => ({ case: `${prefix}/original/${group.name}/${index}`, field: 'value', expected: value })) ?? []

	return {
		path: sample.path, sha256: sample.sha256, status: group ? 'adapted' : 'excluded',
		reason: group ? '仅保留六ASCII空白或对应原始标量分组值；不覆盖eval、包装对象、undefined/void。null以明确optional上下文表示；Unicode空白差异单独拒绝测试不计通过。' : '原文检查typeof/delete的引用行为，ZX缺少这些运算和动态未声明标识符协议；不能以普通标量分组代替。',
		contract: 'packages/core/IR契约.md', cases: assertions.map(row => row.case), assertions,
	}
}))
