import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/return_top_level.jsonl'))
const frontend = []
const ids: Record<string, Array<string>> = {}

for (const [name, statement, type] of [['empty', 'return\n', 'void'], ['value', 'return (0)\n', 'u64']]) {
	const header = `export type Input = void

export type Output = ${type}

`
	const program = `${header}export default function (in: Input): Output {\n  ${statement}\n}\n`
	ids[name] = []

	for (const [position, prefix] of [['bare', ''], ['after_types', header], ['after_function', program]]) {
		const source = prefix + statement + '\n'
		const id = `language/statements/return_top_level/${name}/${position}`

		frontend.push({ id, source, phase: 'parse', diagnostic: 'contract', span: [prefix.length, prefix.length + 6] })
		ids[name].push(id)
	}

	frontend.push({ id: `language/statements/return_top_level/${name}/inside`, source: program, phase: 'analyze', diagnostic: null })
}

writeCatalog('tests/language/statements/return_top_level/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/return_top_level.jsonl', samples.map(sample => {
	const name = sample.path.split('/').at(-1)!
	const cases = name === 'S12.9_A1_T4.js' ? ids.empty : name === 'S12.9_A1_T10.js' ? ids.value : []

	return { ...sample, status: cases.length ? 'adapted' : 'excluded', reason: cases.length ? '保留直接顶层return并在ZX解析阶段报contract，新增类型声明后/完整函数后的位置对照；诊断类别与JS SyntaxError明确不同，不把源文件包装成函数。' : name === 'tco.js' ? '原文要求严格模式十万次尾递归；ZX函数依赖无环，不提供一般递归，不减小次数或改成循环。' : '原文的var声明、顶层块、do循环或try/catch先超出ZX文件/语句语法；直接删除这些上下文会改变被验证结构，因此排除，不用更早的文件结构拒绝冒充完整return限制。', contract: 'packages/core/IR契约.md#表达式与求值', cases }
}))
