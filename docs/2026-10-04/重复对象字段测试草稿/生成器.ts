import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/object_duplicate.jsonl'))
const path = 'tests/language/expressions/object_construction/duplicate'
const values = [[0, 1], [1, 0], [7, 7], [2, 255], [255, 2]]
const runtime = values.map(([first, last], index) => ({ id: `language/expressions/object_duplicate/${index}`, input: { first, last }, expected: { value: last } }))

writeOutput(`${path}.zx`, 'export type Input = { first: u64; last: u64; };\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const value = { foo: in.first, foo: in.last };\n\n  return value.foo;\n}\n')
writeCatalog(`${path}.jsonl`, runtime)

const types = [
	{ name: 'u64', source: 'u64', value: '1' },
	{ name: 'bool', source: 'bool', value: 'true' },
	{ name: 'string', source: 'string', value: '"text"' },
	{ name: 'list', source: 'u64[]', value: '[1]' },
]
const frontend = []

for (const first of types) for (const last of types) for (const mode of ['inferred', 'expected']) {
	const body = mode === 'inferred' ? '  const value = { foo: first, foo: last };\n\n  return value;' : '  return { foo: first, foo: last };'
	const source = `export type Input = void;\n\nexport type Output = { foo: ${last.source}; };\n\nexport default function (in: Input): Output {\n  const first: ${first.source} = ${first.value};\n  const last: ${last.source} = ${last.value};\n\n${body}\n}\n`

	frontend.push({ id: `language/types/object_duplicate/${mode}/${first.name}/${last.name}`, source, phase: 'analyze', diagnostic: mode === 'expected' && first.name !== last.name ? 'type_mismatch' : null })
}

writeCatalog('tests/language/types/object_duplicate/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/object_duplicate.jsonl', samples.map(sample => {
	const duplicate = sample.path.endsWith('11.1.5_4-4-a-3.js')

	return { ...sample, status: duplicate ? 'adapted' : 'excluded', reason: duplicate ? '保留重复foo字段后定义覆盖前定义的语义，将原0/1提升为输入并以(0,1)复现结果1。移除eval包装，不声称动态eval已支持；其余输入是ZX数值扩展。' : sample.path.endsWith('11.1.5_4-5-1.js') ? '原文设置Object.prototype.prop2为只读后，只断言新对象拥有自身prop2；ZX不提供JS原型/描述符，普通字段值不能代替该断言。' : sample.path.endsWith('11.1.5_4-4-b-1.js') ? '原文仅要求数据字段被同名getter替换时eval不抛SyntaxError，没有调用getter或检查其值。ZX没有访问器与动态eval，不以普通重复字段冒充。' : '原文通过eval构造getter/setter并检查读取及赋值副作用，ZX静态数据对象无此访问器协议，不生成替代通过用例。', contract: 'packages/zx/IR契约.md#表达式与求值', cases: duplicate ? runtime.map(row => row.id) : [] }
}))
