import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { readRows, jsonLines } from '../../../../packages/test/src/shared/json.ts'
import { readIndex } from '../../../../packages/test/src/shared/upstream.ts'

const path = 'test/language/expressions/unary-minus/bigint.js'
const source = readFileSync('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd/' + path)
const sha256 = createHash('sha256').update(source).digest('hex')
if (readIndex().get(path) !== sha256) throw new Error('source hash mismatch')

const large = 0x1fffffffffffff01n
const checks: Array<[string, string, bigint, bigint, bigint, boolean]> = [
	['-0n', 'negate', 0n, 0n, 0n, true],
	['-(0n)', 'negate', 0n, 0n, 0n, true],
	['-1n', 'negate', 1n, -1n, 1n, false],
	['-(1n)', 'negate', 1n, -1n, -1n, true],
	['-(1n)', 'negate', 1n, -1n, 1n, false],
	['-(-1n)', 'negate', -1n, 1n, 1n, true],
	['-(-1n)', 'negate', -1n, 1n, -1n, false],
	['- - 1n', 'double_negate', 1n, 1n, 1n, true],
	['- - 1n', 'double_negate', 1n, 1n, -1n, false],
	['-(0x1fffffffffffff01n)', 'negate', large, -large, -large, true],
	['-(0x1fffffffffffff01n)', 'negate', large, -large, large, false],
	['-(0x1fffffffffffff01n)', 'negate', large, -large, -0x1fffffffffffff00n, false]
]
if ([...source.toString().matchAll(/assert\.(?:sameValue|notSameValue)\(/g)].length !== checks.length)
	throw new Error('upstream assertion inventory mismatch')

const cases = new Map(
	readRows<{ id: string; expected: { value?: bigint | number } }>(
		'packages/test/tests/runtime/safety/integer/i64.jsonl'
	).map(row => [row.id, row])
)
const assertions = checks.map(([expression, operation, input, expected, compared, equal], index) => {
	const id = `runtime/safety/integer/i64/${operation}/${input}/0`
	const value = cases.get(id)?.expected.value

	if (value === undefined || BigInt(value) !== expected || (expected === compared) !== equal)
		throw new Error('case witness mismatch: ' + id)

	return {
		upstream_check: index + 1,
		expression,
		case: id,
		field: 'value',
		expected,
		upstream_assertion: equal ? 'sameValue' : 'notSameValue',
		compared_to: compared
	}
})

writeFileSync(
	'packages/test/upstream/reviews/language/expressions/unary_minus_integer.jsonl',
	jsonLines([
		{
			path,
			sha256,
			status: 'adapted',
			contract: 'packages/zx/IR契约.md#数值',
			reason: '逐项核对 12 条断言的精确整数结果及其比较值，映射到 i64 范围内的五个独立输入。ZX 不支持任意精度 BigInt、n 后缀或这里的十六进制字面量；宿主传入无损十进制 i64，括号和空白拼写也不据此声明兼容。另有最小负整数溢出案例明确验证固定宽度与 BigInt 的边界差异。',
			cases: [...new Set(assertions.map(row => row.case))],
			assertions
		}
	])
)
