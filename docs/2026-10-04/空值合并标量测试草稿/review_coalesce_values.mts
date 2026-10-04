import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const package_dir = join(root, 'packages/test')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
type Case = { id: string; phase?: string; diagnostic?: string; expected?: Record<string, unknown> }
const readRows = <T>(path: string): Array<T> => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line) as T)
const index = new Map(readRows<{ path: string; sha256: string }>(join(package_dir, 'upstream/index/language.jsonl')).map(row => [row.path, row.sha256]))
const base = 'language/expressions/coalesce/values'
const paths = ['number', 'boolean', 'string'].flatMap(type => ['direct', 'nested', 'index'].map(layout => `${base}/${type}/${layout}`))
const cases = new Map([...paths, 'language/types/coalesce_values/cases', 'language/types/coalesce_chain/cases'].flatMap(path => readRows<Case>(join(package_dir, `tests/${path}.jsonl`))).map(row => [row.id, row]))
const decisions: Array<{ file: string; reason: string; cases: Array<string> }> = []

for (const [suffix, type, value_name, value] of [
	['0', 'number', 'zero', 0],
	['42', 'number', 'forty_two', 42],
	['empty-string', 'string', 'empty', ''],
	['string', 'string', 'undefined_text', 'undefined'],
	['false', 'boolean', 'false', false],
	['true', 'boolean', 'true', true],
] as const) {
	const prefix = `${base}/${type}`
	const selected = [...cases.values()].filter(row => row.id.startsWith(prefix + '/') && row.expected?.value === value).map(row => row.id)
	const boundary_prefix = type === 'boolean' ? 'language/types/coalesce_chain' : `language/types/coalesce_values/${type}`
	const boundaries = ['nonoptional_head', 'optional_fallback', 'unparenthesized_chain'].map(name => `${boundary_prefix}/${name}`)

	assert.ok(selected.some(id => id.startsWith(`${prefix}/direct/${value_name}/`)))
	assert.ok(selected.some(id => id.startsWith(`${prefix}/nested/null/${value_name}/`)))
	assert.ok(selected.includes(`${prefix}/index/${value_name}/empty/0`))
	decisions.push({
		file: `short-circuit-number-${suffix}.js`,
		reason: `原十一项以 ${JSON.stringify(value)} 为首个非空值。实际以显式 ${type === 'number' ? 'f64?' : type === 'boolean' ? 'bool?' : 'string?'} 输入保留该值，直接位置与前一层 null 后的位置均检查原精确值；空数组回退在该值非空时不执行，不能把零、空串或 false 当作空值。原非可选 lhs、可选/null rhs、左结合任意类型链有独立静态拒绝；含 undefined 的各项不提供，合法嵌套使用显式右括号。异型 fallback 不支持，不宣称原十一条 JS 原样执行。`,
		cases: [...selected, ...boundaries, `language/types/coalesce_values/${type}/null_fallback`],
	})
}

decisions.push({
	file: 'follows-null.js',
	reason: '原 null??42 与 null??false 用显式 f64?/bool? 空输入实际执行并返回 42/false；不能推断 null 字面量具有独立动态类型。null??null 在载荷回退契约下拒绝 null rhs，关联 f64?/bool?/string? 的独立诊断；null??undefined 因无独立 undefined 值明确不提供。四项分别说明，不把两个未支持结果偷换为其他值。',
	cases: [`${base}/number/direct/null/forty_two`, `${base}/boolean/direct/null/false`, ...['number', 'boolean', 'string'].map(type => `language/types/coalesce_values/${type}/null_fallback`)],
})
decisions.push({
	file: 'chainable.js',
	reason: '原四项中 null??null??42 的适用回退语义用两个显式 f64? 空输入与右括号嵌套实际返回 42；左右非空位置另有精确值证据。ZX ?? 返回载荷，原无括号可选右值链有独立类型拒绝，不声称保留原左结合语法。其余三项含 undefined 的表达式不提供，不将 undefined 视为 ZX null。',
	cases: [`${base}/number/nested/null/null/forty_two`, `${base}/number/nested/zero/forty_two/forty_two`, `${base}/number/nested/null/zero/forty_two`, 'language/types/coalesce_values/number/unparenthesized_chain'],
})

const reviews = decisions.map(decision => {
	const path = `test/language/expressions/coalesce/${decision.file}`
	const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')

	assert.equal(index.get(path), sha256)
	for (const id of decision.cases) assert.ok(cases.has(id), id)

	return {
		path, sha256, status: 'adapted', reason: decision.reason,
		contract: 'packages/zx/IR契约.md#表达式与求值', cases: decision.cases,
		assertions: decision.cases.flatMap(id => cases.get(id)!.expected ? [{ case: id, field: 'value', expected: cases.get(id)!.expected!.value }] : []),
		diagnostics: decision.cases.flatMap(id => cases.get(id)!.diagnostic ? [{ case: id, phase: cases.get(id)!.phase, code: cases.get(id)!.diagnostic }] : []),
	}
})

writeFileSync(join(package_dir, 'upstream/reviews/language/expressions/coalesce_values.jsonl'), reviews.map(row => JSON.stringify(row)).join('\n') + '\n')
console.log(`${reviews.length} coalesce value reviews written`)
