import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const package_dir = join(root, 'packages/test')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
type Case = { id: string; phase?: string; diagnostic?: string; expected?: Record<string, boolean | string> }
const readRows = <T>(path: string): Array<T> => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line) as T)
const index = new Map(readRows<{ path: string; sha256: string }>(join(package_dir, 'upstream/index/language.jsonl')).map(row => [row.path, row.sha256]))
const cases = new Map(['runtime/evaluation_order/coalesce', 'language/types/coalesce_chain/cases'].flatMap(path => readRows<Case>(join(package_dir, `tests/${path}.jsonl`))).map(row => [row.id, row]))
const first_error = 'coalesce_order/LR/left_null/right_null/fallback_false/fail_left_true/fail_right_true'
const reversed_error = 'coalesce_order/RL/left_null/right_null/fallback_false/fail_left_true/fail_right_true'
const second_error = 'coalesce_order/LR/left_null/right_null/fallback_false/fail_left_false/fail_right_true'
const skip_false = 'coalesce_order/LR/left_false/right_null/fallback_true/fail_left_false/fail_right_true'
const skip_true = 'coalesce_order/LR/left_true/right_null/fallback_false/fail_left_false/fail_right_true'
const reversed_skip = 'coalesce_order/RL/left_null/right_false/fallback_true/fail_left_true/fail_right_false'
const fallback = 'coalesce_order/LR/left_null/right_null/fallback_true/fail_left_false/fail_right_false'
const second_value = 'coalesce_order/LR/left_null/right_false/fallback_true/fail_left_false/fail_right_false'
const boundary = ['language/types/coalesce_chain/unparenthesized_chain', 'language/types/coalesce_chain/optional_fallback', 'language/types/coalesce_chain/nonoptional_head']
const decisions = [
	{
		file: 'abrupt-is-a-short-circuit.js',
		reason: '原三项断言要求 poison 错误先发生并阻止 morePoison。ZX 没有 undefined 或源级 throw，改用可选返回的 fallible 原生调用；首调用失败仅 L/LeftFailure，反向源码仅 R/RightFailure，首调用返回 null 时再到达右错误并记录 LR。使用合法右括号嵌套，原左结合任意类型链、可选 fallback 和非可选 lhs 的类型限制另有真实诊断，不宣称原 JS 链可原样执行。',
		cases: [first_error, reversed_error, second_error, ...boundary],
		assertions: [
			{ case: first_error, field: 'trace', expected: 'L' }, { case: first_error, field: 'error', expected: 'LeftFailure' },
			{ case: reversed_error, field: 'trace', expected: 'R' }, { case: reversed_error, field: 'error', expected: 'RightFailure' },
			{ case: second_error, field: 'trace', expected: 'LR' }, { case: second_error, field: 'error', expected: 'RightFailure' },
		],
	},
	{
		file: 'short-circuit-prevents-evaluation.js',
		reason: '原四项将 42 放在不同链位置并跳过 poison。ZX 使用 bool? 有效载荷及合法右括号嵌套，非空 false/true 均应跳过会失败的另一调用；反向源码也只执行首调用。首项 null 则到达第二非空 false，两个 null 才使用 fallback。值改为 bool 是显式适配，不声称验证原数字 42 本身；undefined、源级 throw 与任意类型左结合链不提供，关联静态边界而不悄悄替换语法。',
		cases: [skip_false, skip_true, reversed_skip, fallback, second_value, ...boundary],
		assertions: [
			{ case: skip_false, field: 'trace', expected: 'L' }, { case: skip_false, field: 'value', expected: false },
			{ case: skip_true, field: 'trace', expected: 'L' }, { case: skip_true, field: 'value', expected: true },
			{ case: reversed_skip, field: 'trace', expected: 'R' }, { case: reversed_skip, field: 'value', expected: false },
			{ case: fallback, field: 'trace', expected: 'LR' }, { case: fallback, field: 'value', expected: true },
			{ case: second_value, field: 'trace', expected: 'LR' }, { case: second_value, field: 'value', expected: false },
		],
	},
]

const reviews = decisions.map(decision => {
	const path = `test/language/expressions/coalesce/${decision.file}`
	const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')

	assert.equal(index.get(path), sha256)
	for (const id of decision.cases) assert.ok(cases.has(id), id)
	for (const assertion of decision.assertions) assert.equal(cases.get(assertion.case)?.expected?.[assertion.field], assertion.expected)

	const diagnostics = decision.cases.flatMap(id => {
		const row = cases.get(id)!

		return row.diagnostic ? [{ case: id, phase: row.phase, code: row.diagnostic }] : []
	})

	return { path, sha256, status: 'adapted', reason: decision.reason, contract: 'packages/zx/IR契约.md#表达式与求值', cases: decision.cases, assertions: decision.assertions, diagnostics }
})

writeFileSync(join(package_dir, 'upstream/reviews/language/expressions/coalesce_order.jsonl'), reviews.map(row => JSON.stringify(row)).join('\n') + '\n')
console.log(`${reviews.length} coalesce order reviews written`)
