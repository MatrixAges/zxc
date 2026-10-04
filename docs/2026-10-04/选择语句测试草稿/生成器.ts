import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/switch_statement.jsonl'))
const selector = 'readLeft(in.fail_left) == in.match_value'
const bodies = {
	default_first: `  switch (${selector}) {\n    default: return 7;\n    case true: return readRight(in.fail_right);\n  }`,
	default_last: `  switch (${selector}) {\n    case true: return readRight(in.fail_right);\n    default: return 7;\n  }`,
	empty: `  switch (${selector}) {}\n\n  return 7;`,
	default_only: `  switch (${selector}) {\n    default: return readRight(in.fail_right);\n  }`,
	no_fallthrough: `  switch (${selector}) {\n    case true: const first = readRight(in.fail_right);\n    case false: const second = readRight(in.fail_right);\n  }\n\n  return 7;`,
}

for (const [name, body] of Object.entries(bodies)) {
	const path = `tests/runtime/evaluation_order/switch_statement/${name}`
	const rows = []
	writeOutput(`${path}.zx`, `import readLeft from "lib:probe-left";\nimport readRight from "lib:probe-right";\n\nexport type Input = { match_value: f64; fail_left: bool; fail_right: bool; };\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n${body}\n}\n`)

	for (const match_value of [0, 2]) for (const fail_left of [false, true]) for (const fail_right of name === 'empty' ? [false] : [false, true]) {
		const calls_right = name !== 'empty' && (['default_only', 'no_fallthrough'].includes(name) || match_value === 2)
		const trace = fail_left || !calls_right ? 'L' : 'LR'
		const error = fail_left ? 'LeftFailure' : calls_right && fail_right ? 'RightFailure' : null
		const value = calls_right && name !== 'no_fallthrough' ? 3 : 7
		rows.push({ id: `switch_statement/${name}/match_${match_value}/left_${fail_left}/right_${fail_right}`, input: { match_value, fail_left, fail_right }, expected: error ? { trace, error } : { trace, value } })
	}

	writeCatalog(`${path}.jsonl`, rows)
}

const shapes = [
	{ name: 'duplicate_default', type: 'u64', body: 'switch (in) { default: return 1; default: return 2; }', phase: 'analyze', diagnostic: 'name' },
	{ name: 'empty_condition', type: 'u64', body: 'switch () { default: return 1; }', phase: 'parse', diagnostic: 'syntax' },
	{ name: 'missing_parentheses', type: 'u64', body: 'switch { default: return 1; }', phase: 'parse', diagnostic: 'syntax' },
	{ name: 'duplicate_case', type: 'u64', body: 'switch (in) { case 1: return 1; case 1: return 2; default: return 3; }', phase: 'analyze', diagnostic: 'name' },
	{ name: 'dynamic_case', type: 'u64', body: 'switch (in) { case in: return 1; default: return 2; }', phase: 'analyze', diagnostic: 'type_mismatch' },
	...['f64', 'u64?', 'u64[]', '{ item: u64; }'].map((type, index) => ({ name: `subject_${index}`, type, body: 'switch (in) { default: return 1; }', phase: 'analyze', diagnostic: 'type_mismatch' })),
]
const frontend = shapes.map(shape => ({ id: `language/statements/switch/${shape.name}`, source: `export type Input = ${shape.type};\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  ${shape.body}\n}\n`, phase: shape.phase, diagnostic: shape.diagnostic }))

writeCatalog('tests/language/statements/switch/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/switch.jsonl', samples.map((sample, index) => ({ ...sample, status: 'adapted', reason: index === 0 ? '保留重复default，ZX分析阶段name拒绝；以return替代原文可变累加和break，不声称JS完整switch语义。' : '保留空subject或缺括号，ZX parse syntax拒绝；分支用合法return隔离首个语法错误。', contract: 'packages/core/IR契约.md#表达式与求值', cases: [frontend[index].id] })))
