import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const package_dir = join(root, 'packages/test')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const readRows = <T>(path: string): Array<T> => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line) as T)
const path = 'test/language/expressions/coalesce/short-circuit-number-object.js'
const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')
const index = readRows<{ path: string; sha256: string }>(join(package_dir, 'upstream/index/language.jsonl'))
const cases = readRows<{ id: string; expected: { value: { value: number } } }>(join(package_dir, 'tests/language/expressions/coalesce/identity/object.jsonl'))

assert.equal(index.find(row => row.path === path)?.sha256, sha256)
assert.equal(cases.length, 12)

const review = {
	path, sha256, status: 'adapted',
	reason: '原十一项要求返回对象本身，其 toString/valueOf 返回 null 也不得使对象成为空值。ZX 不提供动态转换钩子，不能声称验证这两个方法调用规则；适用的借用对象选择由十二条真实编译案例验证。专用驱动分配三个地址不同的栈对象，包含全等内容和部分相同内容，检查 actual 指针等于按存在性选择的输入地址、结果内容及输入未改动，不能用深比较冒充身份。覆盖首层对象、首层 null 后对象及两个 null 后 fallback；原 undefined、非可选 lhs、null/异型 rhs 和任意类型左结合链明确不提供，使用显式可选类型与右括号嵌套。',
	contract: 'packages/zx/IR契约.md#所有权与集合回调',
	cases: cases.map(row => row.id),
	assertions: cases.map(row => ({ case: row.id, field: 'value', expected: row.expected.value })),
}

writeFileSync(join(package_dir, 'upstream/reviews/language/expressions/coalesce_identity.jsonl'), JSON.stringify(review) + '\n')
console.log('1 coalesce identity review written')
