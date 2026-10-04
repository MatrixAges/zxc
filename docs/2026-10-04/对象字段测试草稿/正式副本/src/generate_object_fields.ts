import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/object_fields.jsonl'))
const root = 'tests/language/expressions/object_construction/fields'
const groups = [
	{ name: 'bool', type: 'bool', values: [true, false] },
	{ name: 'number', type: 'u64', values: [1, 0, 255] },
	{ name: 'string', type: 'string', values: ['1', '', '字段'] },
	{ name: 'optional', type: 'u64?', values: [null, 0, 1] },
]
const value_ids: Array<string> = []
const named_ids: Array<string> = []

for (const group of groups) for (const mode of ['explicit', 'shorthand']) {
	const name = `${group.name}_${mode}`
	const expression = mode === 'explicit' ? '{ prop: prop }' : '{ prop }'
	const rows = group.values.map((input, index) => ({ id: `language/expressions/object_fields/${name}/${index}`, input, expected: { value: input } }))

	writeOutput(`${root}/${name}.zx`, `export type Input = ${group.type};\n\nexport type Output = ${group.type};\n\nexport default function (in: Input): Output {\n  const prop = in;\n  const object = ${expression};\n\n  return object.prop;\n}\n`)
	writeCatalog(`${root}/${name}.jsonl`, rows)
	if (mode === 'explicit') value_ids.push(...rows.map(row => row.id))
}

const named_rows = [true, false].map((input, index) => ({ id: `language/expressions/object_fields/name_undefined/${index}`, input, expected: { value: input } }))

writeOutput(`${root}/name_undefined.zx`, 'export type Input = bool;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  const object = { undefined: in };\n\n  return object.undefined;\n}\n')
writeCatalog(`${root}/name_undefined.jsonl`, named_rows)
named_ids.push(...named_rows.map(row => row.id))

const boundaries = [
	{ name: 'numeric', expression: '{1 : true}', token: '1' },
	{ name: 'quoted', expression: '{"x" : true}', token: '"x"' },
	{ name: 'mixed', expression: '{0 : 1, "1" : "x", o : {}}', token: '0' },
	{ name: 'quoted_true', expression: '{"true" : true}', token: '"true"' },
	{ name: 'quoted_null', expression: '{"null" : true}', token: '"null"' },
	{ name: 'keyword_true', expression: '{true : 1}', token: 'true' },
	{ name: 'keyword_null', expression: '{null : true}', token: 'null' },
]
const frontend = boundaries.map(boundary => {
	const source = `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  const object = ${boundary.expression};\n\n  return true;\n}\n`
	const start = source.indexOf(boundary.token, source.indexOf('const object'))

	return { id: `language/types/object_fields/${boundary.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + boundary.token.length] }
})

writeCatalog('tests/language/types/object_fields/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/object_fields.jsonl', samples.map(sample => {
	const name = sample.path.split('/').at(-1)!
	const cases = name.includes('A1.2') ? [frontend[0].id] : name.includes('A1.3') ? [frontend[1].id] : name.includes('A1.4') ? value_ids.filter(id => id.includes('bool')) : name.includes('_A2.') ? value_ids : name.includes('_A3.') ? [frontend[2].id] : name.includes('A4.1') ? [frontend[5].id] : name.includes('A4.2') ? [frontend[6].id] : name.includes('A4.3') ? [...named_ids.filter(id => id.includes('name_undefined')), frontend[3].id, frontend[4].id] : []

	return { ...sample, status: cases.length ? 'adapted' : 'excluded', reason: cases.length ? '仅适配普通标量/optional字段值、标识符名称或保留原文字面量名称的语法拒绝。A2只对应CHECK1/3/5/8；不包含装箱、undefined值、对象/列表/函数/this引用身份。其余原型、typeof、instanceof与字符串动态索引不计支持。额外输入为ZX扩展；简写测试不关联这些上游文件。' : '空对象原文全部断言涉及typeof、instanceof、继承的toString及其调用；仅能构造空对象不能证明这些协议，明确排除。', contract: 'packages/zx/IR契约.md#表达式与求值', cases }
}))
