import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; boxed: boolean; alternative: boolean; expressions: Array<string> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/if_truthiness.jsonl'))
const frontend = []
const reviews = []

for (const sample of samples) {
	const cases: Array<string> = []

	for (const [index, expression] of sample.expressions.entries()) {
		const source = `export type Input = void

export type Output = u64

export default function (in: Input): Output {
  if (${expression}) {
    return 1
  }${sample.alternative ? ' else {\n    return 2\n  }' : '\n\n  return 2\n'}\n}\n`
		const diagnostic = sample.boxed ? 'syntax' : expression === 'false' ? null : ['undefined', 'NaN'].includes(expression) ? 'name' : 'type_mismatch'
		const token = sample.boxed ? 'new' : expression
		const start = source.indexOf(token, source.indexOf('  if'))
		const id = `language/statements/if_truthiness/${sample.boxed ? 'boxed' : 'falsy'}/${sample.alternative ? 'else' : 'plain'}/${index}`

		frontend.push({ id, source, phase: sample.boxed ? 'parse' : 'analyze', diagnostic, ...diagnostic === null ? {} : { span: [start, start + token.length] } })
		cases.push(id)
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: 'adapted', reason: sample.boxed ? '保留全部九个new装箱表达式及逻辑非，在new处核验语法拒绝；不拆箱为标量，不声称对象真值转换、构造器或可变计数器已支持。' : '保留六种直接条件。false分析成功；0/null/空字符串类型拒绝，undefined/NaN名称拒绝；保留if有无else，不声称JS非bool真值转换或原计数器已支持。', contract: 'packages/core/IR契约.md#表达式与求值', cases })
}

for (const type of ['bool', 'u64', 'f64', 'string', 'bool?', 'u64?', 'u64[]', '{ item: u64 }']) {
	const source = `export type Input = ${type}

export type Output = u64

export default function (in: Input): Output {
  if (in) {
    return 1
  } else {
    return 2
  }
}
`
	const start = source.indexOf('in)', source.indexOf('  if'))

	frontend.push({ id: `language/statements/if_truthiness/typed/${frontend.length - 30}`, source, phase: 'analyze', diagnostic: type === 'bool' ? null : 'type_mismatch', ...type === 'bool' ? {} : { span: [start, start + 2] } })
}

writeCatalog('tests/language/statements/if_truthiness/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/if_truthiness.jsonl', reviews)
