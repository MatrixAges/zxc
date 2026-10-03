import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { readIndex } from '../../../../packages/test/src/shared/upstream.ts'
import { jsonLines } from '../../../../packages/test/src/shared/json.ts'

const prefix = 'test/language/expressions/unary-minus/'
const case_prefix = 'language/expressions/unary_minus/f64/'
const indexed = readIndex()
const entries = [
	{
		file: 'S11.4.7_A4.1.js',
		status: 'equivalent',
		reason: '两个 NaN 取负检查分别由直接输入和局部绑定程序执行；ZX 无 JavaScript NaN 全局名，宿主提供 NaN 位模式。验证数值行为，按 NaN 类别断言而非要求 payload。',
		cases: ['direct/nan', 'binding/nan'].map(name => case_prefix + name)
	},
	{
		file: 'S11.4.7_A4.2.js',
		status: 'equivalent',
		reason: '两个方向的零取负由直接和绑定程序执行。按结果位模式检查负零和正零，覆盖上游普通相等及倒数检查要区分的符号；这里不宣称执行了原 JavaScript 倒数表达式。',
		cases: ['direct/positive_zero', 'direct/negative_zero', 'binding/positive_zero', 'binding/negative_zero'].map(
			name => case_prefix + name
		)
	},
	{
		file: 'S11.4.7_A2.1_T1.js',
		status: 'adapted',
		reason: '五项 -1、-(-1)、-x、-(-x)、-object.prop 分别实际执行；ZX 用 f64 十进制字面量建立绑定，Object 构造与动态属性改为静态记录。数值与读取顺序保持，但不声明支持 JavaScript 对象机制。',
		cases: [0, 1, 2, 3, 4].map(index => case_prefix + 'source_values/' + index)
	},
	{
		file: 'S11.4.7_A2.1_T2.js',
		status: 'adapted',
		reason: '未知名称在 ZX 分析阶段被 name 诊断拒绝，检查精确名称 span；JavaScript 在运行时抛出 ReferenceError。没有以运行异常代替静态契约。',
		cases: ['language/types/unary_minus/name/unbound'],
		diagnostics: [{ case: 'language/types/unary_minus/name/unbound', phase: 'analyze', code: 'name' }]
	},
	{
		file: '11.4.7-4-1.js',
		status: 'adapted',
		reason: '原始空字符串取负在 ZX 分析阶段被 type_mismatch 拒绝；JavaScript 会先 ToNumber 再产生负零。此记录明确保存语义差异，不把静态拒绝称为 ToNumber 支持。',
		cases: ['language/types/unary_minus/literal/""'],
		diagnostics: [{ case: 'language/types/unary_minus/literal/""', phase: 'analyze', code: 'type_mismatch' }]
	}
]
const rows = entries.map(({ file, ...entry }) => {
	const path = prefix + file
	const source = readFileSync('/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd/' + path)
	const sha256 = createHash('sha256').update(source).digest('hex')

	if (indexed.get(path) !== sha256) throw new Error('upstream source mismatch: ' + path)

	return { path, sha256, contract: 'packages/zx/IR契约.md#数值', ...entry }
})

writeFileSync('packages/test/upstream/reviews/language/expressions/unary_minus.jsonl', jsonLines(rows))
