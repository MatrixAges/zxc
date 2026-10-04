import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const package_dir = join(root, 'packages/test')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const prefix = 'language/expressions/conditional'
type Case = { id: string; phase?: string; diagnostic?: string; span?: Array<number>; expected?: { value: unknown } }
const readRows = <T>(path: string): Array<T> => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line) as T)
const index = new Map(readRows<{ path: string; sha256: string }>(join(package_dir, 'upstream/index/language.jsonl')).map(row => [row.path, row.sha256]))
const cases = new Map(['boolean', 'number', 'string', 'optional', 'coalesce'].flatMap(name => readRows<Case>(join(package_dir, `tests/${prefix}/${name}.jsonl`))).concat(readRows<Case>(join(package_dir, 'tests/language/types/conditional/cases.jsonl'))).map(row => [row.id, row]))
const decisions: Array<{ file: string; reason: string; cases: Array<string>; excluded?: boolean }> = []
const caseIds = (part: string): Array<string> => [...cases.keys()].filter(id => id.startsWith(part))

decisions.push({ file: 'S11.12_A1.js', reason: '六种 ASCII 空白直接编译原 false ? true : true 表达式并断言 true；NBSP、行分隔符、段落分隔符及混合序列在精确首个非 ASCII 字节处 lexical 拒绝。eval 是上游测试载体，ZX 不提供运行动态求值，不能声称 Unicode 空白或 eval 等价。', cases: [...caseIds(`${prefix}/boolean/whitespace/`), ...caseIds('language/lexical/conditional/')] })
decisions.push({ file: 'S11.12_A2.1_T1.js', reason: '原前两项布尔字面量条件分别返回 false 与 true，实际编译执行。其余四项 new Boolean 的对象真值与包装对象身份不属于 ZX 值模型；不将解包后的 bool 当作同一对象。另有非 bool 条件及异型分支拒绝证据。', cases: [`${prefix}/boolean/true/false/true`, `${prefix}/boolean/false/false/true`, 'language/types/conditional/optional_condition', 'language/types/conditional/mixed_branches'] })

for (const selected of [false, true]) {
	const section = selected ? 'A4' : 'A3'

	decisions.push({ file: `S11.12_${section}_T1.js`, reason: `原 bool 条件为 ${selected} 时选择${selected ? '真' : '假'}分支的原始 bool 值，保留原字面量与期望值。new Boolean 包装身份不支持，${selected ? 'new Boolean(false) 仍作为对象为真也不提供' : '不把包装值解包冒充身份相等'}。`, cases: [`${prefix}/boolean/${selected}/false/true`] })
	decisions.push({ file: `S11.12_${section}_T2.js`, reason: `原数值条件 ${selected ? 1 : 0} 在 ZX 静态拒绝；明确改用 bool ${selected} 后，仍实际断言原数字分支结果 ${selected ? 0 : 1}。new Number 的对象身份不支持${selected ? '，含 Number(NaN) 对象真值；该原断言不是原始 NaN 位模式断言' : ''}。`, cases: [`${prefix}/number/${selected}/forward`, `language/types/conditional/${selected ? 'one' : 'zero'}`] })
	decisions.push({ file: `S11.12_${section}_T3.js`, reason: `原${selected ? '非空' : '空'}字符串条件静态拒绝；显式 bool ${selected} 选择原字符串分支，结果精确为 ${selected ? '空字符串' : '字符串 1'}。new String 包装对象真值与身份不支持，不声称完整 JS 真值转换等价。`, cases: [`${prefix}/string/${selected}/forward`, `language/types/conditional/${selected ? 'nonempty_string' : 'empty_string'}`] })
	decisions.push({ file: `S11.12_${section}_T4.js`, reason: '原 undefined 分支属于不支持的独立 JS 值，明确排除该断言；原 null 分支用显式 Output bool? 接收并实际断言 null，另一分支 true 按目标可选类型构造。没有把 undefined 与 null 混为同一值。', cases: [`${prefix}/optional/${selected}/${selected ? 'forward' : 'reverse'}`] })
}

decisions.push({ file: 'coalesce-expr-ternary.js', reason: '实际编译无括号 in.value ?? in.fallback ? 0 : 42；bool? 的 null/false/true 与两种 fallback 六组合逐个断言，覆盖 null 回退、非 null false 保留及条件优先级。原非可选 lhs、数值/字符串真值、异型合并不是 ZX 契约，静态拒绝非可选 lhs 与非 bool 合并条件；undefined、Symbol、对象真值明确不支持。原十二项不能宣称全部原样等价。', cases: [...caseIds(`${prefix}/coalesce/`), 'language/types/conditional/coalesce_nonoptional', 'language/types/conditional/coalesce_numeric'] })

for (const [file, reason] of [
	['in-branch-1.js', '核心是 for 初始化上下文第一分支允许 in 运算符，且观察两个函数调用计数；ZX 不提供该 for/[In] 语法与属性存在性运算符。普通条件短路测试不能证明此语法规则，明确排除。'],
	['in-branch-2.js', '核心是 for 初始化上下文第二分支禁止 in 的解析规则；ZX 不提供 for/[In] 语法。将整个不支持结构的一般语法失败登记为等价 SyntaxError 会产生伪覆盖，明确排除。'],
	['in-condition.js', '核心是 for 初始化中条件位置继承禁止 in 的文法参数；ZX 没有对应 for/[In] 语法，不把普通条件诊断当作同一文法规则，明确排除。'],
	['symbol-conditional-evaluation.js', '两项断言均依赖 Symbol 真值及逻辑非 Symbol；ZX 没有 Symbol 类型且条件/逻辑非仅接受 bool。普通布尔真值表不能替代 Symbol 语义，明确排除。'],
	['tco-cond.js', '核心是条件真分支中的递归调用在 MAX_ITERATIONS 深度保持尾调用，ZX 无环调用图不支持递归，普通分支选择不能证明 TCO，明确排除。'],
	['tco-pos.js', '核心是条件假分支中的递归调用在 MAX_ITERATIONS 深度保持尾调用，ZX 无环调用图不支持递归，不把有限分支执行当作尾调用保证，明确排除。'],
]) decisions.push({ file, reason, cases: [], excluded: true })

const reviews = decisions.map(decision => {
	const path = `test/${prefix}/${decision.file}`
	const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')

	assert.equal(index.get(path), sha256)
	for (const id of decision.cases) assert.ok(cases.has(id), id)

	const assertions = decision.cases.flatMap(id => cases.get(id)!.expected ? [{ case: id, field: 'value', expected: cases.get(id)!.expected!.value }] : [])
	const diagnostics = decision.cases.flatMap(id => {
		const row = cases.get(id)!

		return row.diagnostic ? [{ case: id, phase: row.phase, code: row.diagnostic, ...(row.span ? { span: row.span } : {}) }] : []
	})

	return { path, sha256, status: decision.excluded ? 'excluded' : 'adapted', reason: decision.reason, contract: decision.excluded ? 'docs/zx_design_doc.md' : 'packages/zx/IR契约.md#表达式与求值', cases: decision.cases, assertions, diagnostics }
})

writeFileSync(join(package_dir, 'upstream/reviews/language/expressions/conditional.jsonl'), reviews.map(row => JSON.stringify(row)).join('\n') + '\n')
console.log(`${reviews.length} conditional reviews written`)
