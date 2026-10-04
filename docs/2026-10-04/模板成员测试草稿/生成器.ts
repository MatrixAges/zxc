import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; kind: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_members.jsonl'))
const prefixes = ['foo ', '${0} ', '${0} ${1} ']
const texts = ['foo ', '0 ', '0 1 ']
const shapes = prefixes.flatMap((prefix, position) => (['number', 'string'] as const).map(field => ({ position, field, expression: '`' + prefix + '${object.' + field + '} bar`' })))
const runtime = shapes.flatMap((shape, kind) => [{ number: 5, string: 'stringValue' }, { number: -1, string: '' }].map((object, variant) => ({
	id: `language/expressions/template_members/${shape.position}/${shape.field}/${variant}`,
	input: { kind, object },
	expected: { value: texts[shape.position] + String(object[shape.field]) + ' bar' },
})))
const path = 'tests/language/expressions/template_members/cases'
const branches = shapes.map((shape, index) => `    case ${index}:\n      return ${shape.expression}`).join('\n')

writeOutput(`${path}.zx`, `export type Input = { kind: u64, object: { number: i64, string: string } }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  const object = in.object\n\n  switch (in.kind) {\n${branches}\n    default:\n      return ""\n  }\n}\n`)
writeCatalog(`${path}.jsonl`, runtime)

const frontend = prefixes.flatMap((prefix, position) => ['index', 'object'].map(kind => {
	const value = kind === 'index' ? 'in["string"]' : 'in'
	const expression = '`' + prefix + '${' + value + '} bar`'
	const source = `export type Input = { number: i64, string: string }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`
	const token = kind === 'index' ? value : expression
	const start = source.indexOf(token, source.indexOf('  return'))

	return { id: `language/types/template_members/${kind}/${position}`, source, phase: 'analyze', diagnostic: 'type_mismatch', span: [start, start + token.length] }
}))

writeCatalog('tests/language/types/template_members/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/template_members.jsonl', samples.map((sample, index) => {
	const cases = sample.kind === 'member-expr' ? runtime.filter(row => row.id.startsWith(`language/expressions/template_members/${index}/`) && row.id.endsWith('/0')) : []

	return {
		path: sample.path, sha256: sample.sha256, status: cases.length ? 'adapted' : 'excluded',
		reason: cases.length ? '保留数字/string两点号成员访问及原预期，对象改由显式输入提供；原文另外两方括号属性访问不适配，ZX对象索引拒绝不得声称兼容。' : sample.kind === 'obj' ? '原文检查普通对象默认文本与自定义toString，ZX模板仅接受标量，不把预先返回字符串冒充对象转换。' : '原文对象toString抛Test262Error验证隐式转换失败，ZX没有该转换阶段，静态类型拒绝不能替代运行异常。',
		contract: 'packages/compiler/src/zx/analysis/strings.zig', cases: cases.map(row => row.id),
		...cases.length ? { assertions: cases.map(row => ({ case: row.id, field: 'value', expected: row.expected.value })) } : {},
	}
}))
