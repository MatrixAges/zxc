import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/if_statement.jsonl'))
const trace_ids: Record<string, Array<string>> = {}
const bodies = {
	conditional: '  if (readLeft(in.fail_left) == in.match_value) {\n    return readRight(in.fail_right)\n  } else {\n    return in.items[in.index]\n  }',
	early_return: '  if (readLeft(in.fail_left) == in.match_value) {\n    return in.items[in.index]\n  }\n\n  return readRight(in.fail_right)\n',
	discarded: '  if (in.choose) {\n    const value = readLeft(in.fail_left)\n  } else {\n    const value = readRight(in.fail_right)\n  }\n\n  return in.items[in.index]\n',
}

for (const [name, body] of Object.entries(bodies)) {
	const path = `tests/runtime/evaluation_order/if_statement/${name}`
	const rows = []

	writeOutput(`${path}.zx`, `import readLeft from "lib:probe-left"
import readRight from "lib:probe-right"

export type Input = { choose: bool
 match_value: f64
 fail_left: bool
 fail_right: bool
 items: f64[]
 index: u64 }

export type Output = f64

export default function (in: Input): Output {
${body.trimEnd()}\n}\n`)

	for (const choose of [false, true]) for (const fail_left of [false, true]) for (const fail_right of [false, true]) for (const index of [0, 1]) {
		const input = { choose, match_value: choose ? 2 : 0, fail_left, fail_right, items: [7], index }
		const right = name === 'discarded' ? !choose : name === 'conditional' ? choose : !choose
		const trace = name === 'discarded' ? choose ? 'L' : 'R' : fail_left ? 'L' : right ? 'LR' : 'L'
		const error = (name !== 'discarded' || choose) && fail_left ? 'LeftFailure' : right && fail_right ? 'RightFailure' : (name === 'discarded' || !right) && index === 1 ? 'IndexOutOfBounds' : null

		rows.push({ id: `if_statement/${name}/choose_${choose}/left_${fail_left}/right_${fail_right}/index_${index}`, input, expected: error ? { trace, error } : { trace, value: name === 'discarded' || !right ? 7 : 3 } })
	}

	writeCatalog(`${path}.jsonl`, rows)
	trace_ids[name] = rows.map(row => row.id)
}

const frontend: Array<Frontend> = []

for (const alternative of [false, true]) for (const operand of ['1', 'true', '"1"', '"A"']) {
	const source = `export type Input = void

export type Output = u64

export default function (in: Input): Output {
  if (!(${operand})) {
    return 1
  }${alternative ? ' else {\n    return 2\n  }' : '\n\n  return 2\n'}\n}\n`

	frontend.push({ id: `language/statements/if/truthiness/${alternative ? 'else' : 'plain'}/${frontend.length}`, source, phase: 'analyze', diagnostic: operand === 'true' ? null : 'type_mismatch' })
}

for (const statement of ['if true\n', 'if false\n', 'if()\n']) {
	const source = `export type Input = void

export type Output = u64

export default function (in: Input): Output {
  ${statement}

  return 1
}
`
	const token = statement === 'if()\n' ? ')' : statement.includes('true') ? 'true' : 'false'
	const start = source.indexOf(token, source.indexOf('  if'))

	frontend.push({ id: `language/statements/if/syntax/${frontend.length - 8}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + token.length] })
}

writeCatalog('tests/language/statements/if/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/if.jsonl', samples.map(sample => {
	const name = sample.path.split('/').at(-1)!
	const cases = name.includes('A1_T1') ? frontend.slice(0, 4).map(row => row.id) : name.includes('A1_T2') ? frontend.slice(4, 8).map(row => row.id) : name.includes('_A3.') ? [...trace_ids.conditional, ...trace_ids.early_return] : name.includes('_A4.') ? trace_ids.discarded : name.includes('A6_T1') ? [frontend[8].id] : name.includes('A6_T2') ? [frontend[9].id] : name.includes('_A8.') ? [frontend[10].id] : []
	const reason = name.includes('_A3.') ? '只适配条件调用错误先于分支/后续求值。以fallible原生调用替代IIFE throw，分支为可观察调用/越界；未定义名称的动态解析与catch不计覆盖。' : name.includes('_A4.') ? '适配选中分支失败阻断后续语句，未选中分支不执行。调用置于未使用const初始化以符合ZX语法；不适配字符串throw或IIFE。' : cases.length ? '保留!操作数的bool检查及缺括号/空条件的原始语法；非bool以type_mismatch记录，不声称JS隐式真值转换支持。' : '原文依赖动态eval或函数表达式真值和函数名称作用域；ZX不提供这些语义，不以常量条件替代。'

	return { ...sample, status: cases.length ? 'adapted' : 'excluded', reason, contract: 'packages/core/IR契约.md#表达式与求值', cases }
}))
