import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { readIndex } from '../../../../packages/test/src/shared/upstream.ts'
import { jsonLines, readRows } from '../../../../packages/test/src/shared/json.ts'

const indexed = readIndex()
const frontend = new Map(
	readRows<{ id: string; phase: string; diagnostic: string | null; span?: Array<number> }>(
		'packages/test/tests/language/types/logical_not/cases.jsonl'
	).map(row => [row.id, row])
)
const source_rows = new Map(
	readRows<{ id: string; expected: { value: boolean } }>(
		'packages/test/tests/language/expressions/logical_not/source.jsonl'
	).map(row => [row.id, row])
)
const sourceId = (index: number) => `language/expressions/logical_not/source/${index}`
const literalId = (literal: string) => 'language/types/logical_not/literal/' + literal
const entries = [
	{
		file: 'S11.4.9_A2.1_T1.js',
		status: 'adapted',
		reason: '五项布尔表达式 !true、!(!true)、!x、!(!x)、!object.prop 均实际执行；ZX 用静态记录代替 new Object 与动态属性赋值。',
		cases: [0, 1, 2, 3, 4].map(sourceId)
	},
	{
		file: 'S11.4.9_A2.1_T2.js',
		status: 'adapted',
		reason: '未知名称在 ZX 分析阶段以 name 和精确名称位置拒绝，而非 JavaScript 运行时 ReferenceError。',
		cases: ['language/types/logical_not/name/unbound']
	},
	{
		file: 'S9.2_A2_T2.js',
		status: 'adapted',
		reason: '保留 !(null) 表达式，ZX 以 type_mismatch 拒绝，不执行 JavaScript null 到布尔的转换。',
		cases: [literalId('null')]
	},
	{
		file: 'S9.2_A3_T2.js',
		status: 'equivalent',
		reason: '原 !(true) 与 !(false) 表达式分别实际编译执行，结果为 false 与 true。',
		cases: [6, 7].map(sourceId)
	},
	{
		file: 'S9.2_A5_T2.js',
		status: 'adapted',
		reason: '原 !("") 在 ZX 分析阶段以 type_mismatch 拒绝，不把空字符串隐式转换为 false。',
		cases: [literalId('""')]
	},
	{
		file: 'S9.2_A5_T4.js',
		status: 'adapted',
		reason: '两个原始非空字符串表达式均在分析阶段以 type_mismatch 拒绝，明确区别 JavaScript 的真值转换。',
		cases: ['" "', '"Nonempty String"'].map(literalId)
	},
	{
		file: 'S9.2_A4_T2.js',
		status: 'adapted',
		reason: 'ZX 对 Number 对应 f64 类型统一拒绝逻辑非，结果不依赖正零、负零或 NaN 的值；补充原零和负零字面量的拒绝。上游 +0 与 Number.NaN 的 JavaScript 表达形式没有伪装成 ZX 支持。',
		cases: ['language/types/logical_not/f64', literalId('0'), literalId('-0')]
	},
	{
		file: 'S9.2_A4_T4.js',
		status: 'adapted',
		reason: '四个有限数字字面量的原始 !(value) 均实际分析并拒绝。四个 Number 常量对应的 f64 类型同样不允许逻辑非；这是类型层适配，不声称实现 Number 全局对象或对非有限值执行 ToBoolean。',
		cases: ['language/types/logical_not/f64', ...['13', '-13', '1.3', '-1.3'].map(literalId)]
	}
]
const whitespace = [...frontend.keys()].filter(id => id.startsWith('language/lexical/logical_not/'))
entries.push({
	file: 'S11.4.9_A1.js',
	status: 'adapted',
	reason: '十种间隔字符和组合原样放在 ! 与 true 之间；ASCII 空白通过并实际执行，NBSP/LS/PS 及组合以精确 lexical 位置拒绝。没有使用 eval 或扩张 ZX ASCII 空白规则。',
	cases: [...whitespace, ...[...source_rows.keys()].filter(id => id.includes('/whitespace/'))]
})

const reviews = entries.map(({ file, ...entry }) => {
	const path = 'test/language/expressions/logical-not/' + file
	const sha256 = createHash('sha256')
		.update(readFileSync('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd/' + path))
		.digest('hex')
	if (sha256 !== indexed.get(path)) throw new Error(path)

	const diagnostics = entry.cases
		.filter(id => frontend.get(id)?.diagnostic)
		.map(id => {
			const row = frontend.get(id)!
			return { case: id, phase: row.phase, code: row.diagnostic, ...(row.span ? { span: row.span } : {}) }
		})
	const assertions = entry.cases
		.filter(id => source_rows.has(id))
		.map(id => ({ case: id, field: 'value', expected: source_rows.get(id)!.expected.value }))

	return { path, sha256, contract: 'packages/zx/IR契约.md#表达式与求值', ...entry, diagnostics, assertions }
})

writeFileSync('packages/test/upstream/reviews/language/expressions/logical_not.jsonl', jsonLines(reviews))
