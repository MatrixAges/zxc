import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const package_dir = join(root, 'packages/test')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
type Case = { id: string; phase?: string; diagnostic?: string; expected?: { value: boolean } }
const readRows = <T>(path: string): Array<T> => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line) as T)
const index = new Map(readRows<{ path: string; sha256: string }>(join(package_dir, 'upstream/index/language.jsonl')).map(row => [row.path, row.sha256]))
const frontend = readRows<Case>(join(package_dir, 'tests/language/types/coalesce_logical/cases.jsonl'))

const reviews = ['and', 'or'].map(name => {
	const path = `test/language/expressions/coalesce/chainable-if-parenthesis-covered-logical-${name}.js`
	const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')
	const runtime = readRows<Case>(join(package_dir, `tests/language/expressions/coalesce/logical/${name}.jsonl`))
	const diagnostics = frontend.filter(row => row.id.startsWith(`language/types/coalesce_logical/${name}/`))

	assert.equal(index.get(path), sha256)
	assert.equal(runtime.length, 36)
	assert.equal(diagnostics.length, name === 'and' ? 4 : 6)

	const reason = name === 'and'
		? '原四项允许括号混合，但数字 && 与非可选合并不属于 ZX 类型契约；四条原表达式分别分析期 type_mismatch，不能假称原数字 42 已执行。前三种合法结构 (optional??bool)&&bool、optional??(bool&&bool)、bool&&(optional??bool) 以 bool? 三态和两个 bool 全组合实际执行，明确检查括号分组。原 (41&&42)??null 没有合法可选 lhs，保持拒绝而不借用其他结构声称等价。'
		: '原六项数字真值、null 逻辑操作数与非可选合并均不满足 ZX 静态契约，各有原表达式分析期 type_mismatch。可适配结构 (optional??bool)||bool、optional??(bool||bool)、bool||(optional??bool) 以完整三态和 bool 组合实际执行，检查括号分组；原 (null||42)??43、null||(42??43)、(42||43)??null 明确不提供，不将 bool 输出冒充原数字 42。'

	return {
		path, sha256, status: 'adapted', reason,
		contract: 'packages/zx/IR契约.md#表达式与求值',
		cases: [...runtime, ...diagnostics].map(row => row.id),
		assertions: runtime.map(row => ({ case: row.id, field: 'value', expected: row.expected!.value })),
		diagnostics: diagnostics.map(row => ({ case: row.id, phase: row.phase, code: row.diagnostic })),
	}
})

writeFileSync(join(package_dir, 'upstream/reviews/language/expressions/coalesce_logical.jsonl'), reviews.map(row => JSON.stringify(row)).join('\n') + '\n')
console.log(`${reviews.length} parenthesized coalesce reviews written`)
