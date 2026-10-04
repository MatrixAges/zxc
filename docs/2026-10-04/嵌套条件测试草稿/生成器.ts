import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/if_nested.jsonl'))
const left = 'readLeft(in.fail_left) == in.left_value'
const right = 'readRight(in.fail_right) == in.right_value'
const bodies = {
	full: `  if (in.outer) {\n    if (${left}) {\n      return 1;\n    } else {\n      return 2;\n    }\n  } else {\n    if (${right}) {\n      return 3;\n    } else {\n      return 4;\n    }\n  }`,
	inner_partial: `  if (in.outer) {\n    if (${left}) {\n      return 1;\n    }\n  } else {\n    if (${right}) {\n      return 3;\n    }\n  }\n\n  return 5;`,
	outer_partial: `  if (in.outer) {\n    if (${left}) {\n      return 1;\n    } else {\n      return 2;\n    }\n  }\n\n  return 5;`,
	both_partial: `  if (in.outer) {\n    if (${left}) {\n      return 1;\n    }\n  }\n\n  return 5;`,
	else_if: `  if (${left}) {\n    return 1;\n  } else if (${right}) {\n    return 2;\n  } else {\n    return 3;\n  }`,
}
const trace_ids: Record<string, Array<string>> = {}

for (const [name, body] of Object.entries(bodies)) {
	const path = `tests/runtime/evaluation_order/if_statement/nested_${name}`
	const rows = []

	writeOutput(`${path}.zx`, `import readLeft from "lib:probe-left";\nimport readRight from "lib:probe-right";\n\nexport type Input = { outer: bool; left_value: f64; right_value: f64; fail_left: bool; fail_right: bool; };\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n${body}\n}\n`)

	for (const outer of [false, true]) for (const inner of [false, true]) for (const fail_left of [false, true]) for (const fail_right of [false, true]) {
		const input = { outer, left_value: (name === 'else_if' ? outer : inner) ? 2 : 0, right_value: inner ? 3 : 0, fail_left, fail_right }
		const skip = !outer && ['outer_partial', 'both_partial'].includes(name)
		const trace = skip ? '' : name === 'else_if' ? fail_left || outer ? 'L' : 'LR' : outer ? 'L' : 'R'
		const error = trace.includes('L') && fail_left ? 'LeftFailure' : trace.includes('R') && fail_right ? 'RightFailure' : null
		const value = name === 'else_if' ? outer ? 1 : inner ? 2 : 3 : skip ? 5 : inner ? outer ? 1 : 3 : name === 'full' ? outer ? 2 : 4 : name === 'outer_partial' ? 2 : 5

		rows.push({ id: `if_nested/${name}/outer_${outer}/inner_${inner}/left_${fail_left}/right_${fail_right}`, input, expected: error ? { trace, error } : { trace, value } })
	}

	writeCatalog(`${path}.jsonl`, rows)
	trace_ids[name] = rows.map(row => row.id)
}

const frontend = []

for (const condition of ['true', 'false']) for (const branch of ['yes', 'no']) for (const bound of [false, true]) {
	const declaration = bound ? '  const missing: u64 = 1;\n\n' : ''
	const source = `export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n${declaration}  if (${condition}) {\n    return ${branch === 'yes' ? 'missing' : '2'};\n  } else {\n    return ${branch === 'no' ? 'missing' : '2'};\n  }\n}\n`
	const start = source.indexOf('missing', source.indexOf('  if'))

	frontend.push({ id: `language/statements/if_nested/names/${condition}/${branch}/${bound ? 'bound' : 'unbound'}`, source, phase: 'analyze', diagnostic: bound ? null : 'name', ...bound ? {} : { span: [start, start + 7] } })
}

const paths = [
	{ name: 'constant_true', body: '  if (true) { return 1; }', valid: false },
	{ name: 'constant_false', body: '  if (false) { return 1; }', valid: false },
	{ name: 'unreachable', body: '  if (in) { return 1; } else { return 2; }\n\n  return 3;', valid: false },
	{ name: 'nested_missing', body: '  if (in) { if (in) { return 1; } } else { return 2; }', valid: false },
	{ name: 'nested_complete', body: '  if (in) { if (in) { return 1; } else { return 2; } } else { return 3; }', valid: true },
	{ name: 'followup', body: '  if (in) { return 1; }\n\n  return 2;', valid: true },
]

for (const path of paths) frontend.push({ id: `language/statements/if_nested/return/${path.name}`, source: `export type Input = bool;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n${path.body}\n}\n`, phase: 'analyze', diagnostic: path.valid ? null : 'return_path' })

const invalid_source = 'export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  if ({1}) { return 1; } else { return 2; }\n}\n'
const invalid_start = invalid_source.indexOf('1')
frontend.push({ id: 'language/statements/if_nested/invalid_object_condition', source: invalid_source, phase: 'parse', diagnostic: 'syntax', span: [invalid_start, invalid_start + 1] })

writeCatalog('tests/language/statements/if_nested/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/if_nested.jsonl', samples.map(sample => {
	const name = sample.path.split('/').at(-1)!
	const shape = name.includes('A12_T1') ? 'full' : name.includes('A12_T2') ? 'inner_partial' : name.includes('A12_T3') ? 'outer_partial' : name.includes('A12_T4') ? 'both_partial' : null
	const cases = shape ? trace_ids[shape] : name.includes('_A11.') ? [frontend.at(-1)!.id] : []

	return { ...sample, status: cases.length ? 'adapted' : 'excluded', reason: shape ? '保留内外层if/else有无的结构，按ZX要求显式加块，以叶子返回值和条件原生调用观察分支选择。扩展布尔输入与失败组合；不宣称无块dangling else语法、JS可变局部或throw支持。' : cases.length ? '保留if({1})的非法对象条件，在数字简写字段处检查parse syntax；原文描述不能推广为全部对象条件都非法。' : '原文分别检验函数对象为真与IIFE返回0为假，依赖函数表达式和隐式真值；ZX不支持，不改成常量bool冒充。', contract: 'packages/zx/IR契约.md#表达式与求值', cases }
}))
