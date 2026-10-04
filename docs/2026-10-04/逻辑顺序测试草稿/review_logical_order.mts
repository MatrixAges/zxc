import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const package_dir = join(root, 'packages/test')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
type Case = { id: string; phase?: string; diagnostic?: string; span?: Array<number>; expected?: Record<string, boolean | string> }
const readRows = <T>(path: string): Array<T> => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line) as T)
const index = new Map(readRows<{ path: string; sha256: string }>(join(package_dir, 'upstream/index/language.jsonl')).map(row => [row.path, row.sha256]))
const cases = new Map(['runtime/evaluation_order/logical', 'language/types/logical_assignment/cases', 'language/expressions/static_names/cases'].flatMap(path => readRows<Case>(join(package_dir, `tests/${path}.jsonl`))).map(row => [row.id, row]))
const reviews = []

for (const [name, directory, section] of [['and', 'logical-and', '11.11.1'], ['or', 'logical-or', '11.11.2']]) {
	const truth = name === 'and'
	const ordered = `logical_order/${name}/LR/left_${truth}/right_${truth}/fail_left_false/fail_right_false`
	const reversed = `logical_order/${name}/RL/left_${truth}/right_${truth}/fail_left_false/fail_right_false`
	const skipped = `logical_order/${name}/LR/left_${!truth}/right_${truth}/fail_left_false/fail_right_true`
	const first_error = `logical_order/${name}/LR/left_true/right_true/fail_left_true/fail_right_true`
	const reversed_error = `logical_order/${name}/RL/left_true/right_true/fail_left_true/fail_right_true`
	const second_error = `logical_order/${name}/LR/left_${truth}/right_true/fail_left_false/fail_right_true`
	const assignment = `language/types/logical_assignment/${name}`
	const decisions = [
		{
			file: `S${section}_A2.4_T1.js`,
			reason: '原两项赋值表达式在 ZX 语法阶段精确拒绝，不宣称执行共享变量写入。其适用的首操作数先求值、仅在需要时执行第二操作数，以 fallible 原生探针实际记录 LR/RL 和单次 L 调用，并检查结果；交换源码顺序也交换轨迹，避免仅按函数名固定先后。赋值状态变化本身是明确的设计差异。',
			cases: [ordered, reversed, skipped, `${assignment}/left_assignment`, `${assignment}/right_assignment`],
			assertions: [{ case: ordered, field: 'trace', expected: 'LR' }, { case: ordered, field: 'value', expected: truth }, { case: reversed, field: 'trace', expected: 'RL' }, { case: reversed, field: 'value', expected: truth }, { case: skipped, field: 'trace', expected: 'L' }, { case: skipped, field: 'value', expected: !truth }],
		},
		{
			file: `S${section}_A2.4_T2.js`,
			reason: '上游左右函数分别抛 x/y，必须观察左错误。ZX 不提供源级 throw；改用已声明 fallible 原生调用的 LeftFailure/RightFailure，实际断言首错误身份和只有 L 的轨迹。反转源码时必须是 RightFailure 与仅 R；首调用成功且需要右值时必须到达 RightFailure 与 LR。不是把两侧都替换成无法区分的越界错误。',
			cases: [first_error, reversed_error, second_error],
			assertions: [{ case: first_error, field: 'error', expected: 'LeftFailure' }, { case: first_error, field: 'trace', expected: 'L' }, { case: reversed_error, field: 'error', expected: 'RightFailure' }, { case: reversed_error, field: 'trace', expected: 'R' }, { case: second_error, field: 'error', expected: 'RightFailure' }, { case: second_error, field: 'trace', expected: 'LR' }],
		},
		{
			file: `S${section}_A2.4_T3.js`,
			reason: '原 x 读取加右侧赋值的整体表达式先在 ZX 解析期拒绝 =；另用不含非法赋值的未知左名称断言分析期 name，不能假称原表达式仍抛运行 ReferenceError。第二项通过赋值创建隐式全局的成功行为不支持，实际源码在 = 处拒绝。两项均有独立诊断，不把 undefined 或隐式全局偷换成局部绑定。',
			cases: [`${assignment}/unbound_then_assignment`, `${assignment}/implicit_global`, `language/expressions/static_names/logical_${name}/left/true/unbound`],
			assertions: [],
		},
	]

	for (const decision of decisions) {
		const path = `test/language/expressions/${directory}/${decision.file}`
		const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')

		assert.equal(index.get(path), sha256)
		for (const id of decision.cases) assert.ok(cases.has(id), id)
		for (const assertion of decision.assertions) assert.equal(cases.get(assertion.case)?.expected?.[assertion.field], assertion.expected, assertion.case)

		const diagnostics = decision.cases.flatMap(id => {
			const row = cases.get(id)!

			return row.diagnostic ? [{ case: id, phase: row.phase, code: row.diagnostic, ...(row.span ? { span: row.span } : {}) }] : []
		})
		reviews.push({ path, sha256, status: 'adapted', reason: decision.reason, contract: 'packages/zx/IR契约.md#表达式与求值', cases: decision.cases, assertions: decision.assertions, diagnostics })
	}
}

writeFileSync(join(package_dir, 'upstream/reviews/language/expressions/logical_order.jsonl'), reviews.map(row => JSON.stringify(row)).join('\n') + '\n')
console.log(`${reviews.length} reviewed order files written`)
