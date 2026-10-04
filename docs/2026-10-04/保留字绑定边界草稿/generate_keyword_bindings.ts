import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; name: string; expected: number }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/keyword_bindings.jsonl'))
const base = 'language/lexical/identifiers/keywords'
const prefix = 'export type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const '
const start = Buffer.byteLength(prefix)
const rows = samples.flatMap(sample => [false, true].map(control => {
	const name = sample.name + (control ? '_value' : '')

	return {
		id: `${base}/${sample.name}/${control ? 'control' : 'reserved'}`,
		source: prefix + name + ' = ' + sample.expected + '\n\n  return ' + name + '\n}\n',
		phase: control ? 'analyze' : 'parse',
		diagnostic: control ? null : 'syntax',
		...(control ? {} : { span: [start, start + Buffer.byteLength(name)] })
	}
}))

writeCatalog(`tests/${base}/cases.jsonl`, rows)
writeCatalog('upstream/reviews/language/lexical/keyword_bindings.jsonl', samples.map(sample => ({
	path: sample.path,
	sha256: sample.sha256,
	status: 'adapted',
	reason: '保留原关键字名称和初始化值，var改const并去掉分号；验证名称位置的parse/syntax及完整span。另有加_value后缀的合法控制，不把前缀匹配当关键字规则。',
	contract: 'packages/core/src/syntax.zig',
	cases: [`${base}/${sample.name}/reserved`],
	diagnostics: [{ case: `${base}/${sample.name}/reserved`, phase: 'parse', code: 'syntax', span: [start, start + Buffer.byteLength(sample.name)] }]
})))
