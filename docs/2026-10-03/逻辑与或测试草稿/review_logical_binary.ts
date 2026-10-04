import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const index = new Map(readFileSync(join(root, 'packages/test/upstream/index/language.jsonl'), 'utf8').trim().split('\n').map(line => {
	const row = JSON.parse(line) as { path: string; sha256: string }

	return [row.path, row.sha256]
}))
const frontend = new Map(readFileSync(join(root, 'packages/test/tests/language/types/logical_binary/cases.jsonl'), 'utf8').trim().split('\n').map(line => {
	const row = JSON.parse(line) as { id: string; phase: string; diagnostic: string | null; span?: Array<number> }

	return [row.id, row]
}))
type Review = { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string>; diagnostics: Array<{ case: string; phase: string; code: string; span?: Array<number> }>; assertions: Array<{ case: string; field: string; expected: boolean | string }> }
const rows: Array<Review> = []

for (const [name, directory, section] of [['logical_and', 'logical-and', '11.11.1'], ['logical_or', 'logical-or', '11.11.2']]) {
	const and = name === 'logical_and'
	const runtime = (suffix: string) => `language/expressions/${name}/source/${suffix}`
	const rejected = (suffix: string) => `language/types/${name}/${suffix}`
	const primitives = [runtime('literal/false/false'), runtime('literal/false/true'), runtime('literal/true/false'), runtime('literal/true/true')]
	const scalarCases = (type: string) => ['left', 'right'].flatMap(side => [false, true].map(value => rejected(`${side}/${value}/${type}`)))
	const literalCases = (type: string) => ['left', 'right'].flatMap(side => [false, true].map(value => rejected(`literal/${type}/${side}/${value}`)))
	const skipped = `language/expressions/${name}/basic/${and ? 'false' : 'true'}/empty/index_0`
	const selected = `language/expressions/${name}/basic/${and ? 'true' : 'false'}/empty/index_0`
	const decisions: Array<{ file: string; reason: string; cases: Array<string>; excluded?: boolean }> = [
		{ file: `S${section}_A1.js`, reason: '逐项覆盖十种空白配置。六种 ASCII 空白在相同逻辑表达式中实际执行为 true；NBSP、LS、PS及混合串按 ZX 词法规则拒绝，并核验首个非法 UTF-8 字节位置。eval 仅改为预先编译源码，不声称动态 eval 兼容。', cases: ['tab', 'vertical_tab', 'form_feed', 'space', 'line_feed', 'carriage_return'].map(gap => runtime(`whitespace/${gap}`)).concat(['tab', 'vertical_tab', 'form_feed', 'space', 'nbsp', 'line_feed', 'carriage_return', 'line_separator', 'paragraph_separator', 'combined'].map(gap => `language/lexical/${name}/${gap}`)) },
		{ file: `S${section}_A2.1_T1.js`, reason: (and ? '八项断言中，#1/#2/#3/#5 的 bool 字面量与绑定读取保留实际执行；#4/#6 的 Boolean 包装身份属于设计不适用。' : '八项断言中，#1/#2 的 bool 运算保留实际执行；#3至#6 的 Boolean 包装对象 truthiness 与身份属于设计不适用。') + '#7/#8 的 bool/number 静态字段混合改为左右位置 type_mismatch；另执行 bool 字段读取。不以普通 record 冒充 Boolean 包装对象，因此整体不是等价执行。', cases: [...primitives, runtime('binding_left'), runtime('binding_both'), runtime('field_both'), rejected('numeric_field/left'), rejected('numeric_field/right')] },
		{ file: `S${section}_A3_T1.js`, reason: (and ? 'false 与两种 bool 右值保持原结果，并用合法越界 bool RHS 证明跳过。' : 'false 与两种 bool 右值保持原结果，并用 RHS 越界证明右侧确实执行。') + '另外两项 Boolean 构造/身份断言属于设计不适用；静态非 bool RHS 始终拒绝，不能把包装对象当 bool。', cases: [runtime('literal/false/false'), runtime('literal/false/true'), and ? skipped : selected, rejected('right/false/object')] },
		{ file: `S${section}_A3_T2.js`, reason: (and ? '上游 -0、+0、NaN 左值选择保留该数值；ZX 对 f64 逻辑左右操作数统一静态拒绝，因此这些值选择和有符号零保真不在此操作上成立。' : '上游 0/-0/NaN 的隐式转换决定右值选择并保留正负零；ZX 对 f64 逻辑左右操作数统一静态拒绝，不声称保留该值选择语义。') + 'Number 包装构造与身份断言另属设计不适用。', cases: scalarCases('number') },
		{ file: `S${section}_A3_T3.js`, reason: (and ? '上游空字符串左值返回空串。' : '上游空字符串左值选择普通或包装右值。') + 'ZX 显式编译空串和非空串位于两侧的表达式，全部 type_mismatch，不用 false 替换字符串伪称等价；String 包装构造与身份不适用。', cases: [...literalCases('empty_string'), ...literalCases('nonempty_string')] },
		{ file: `S${section}_A3_T4.js`, reason: (and ? '上游 undefined/null 左值选择自身；ZX 明确初始化为空的 bool? 左值不能作为逻辑操作数，分析期拒绝。' : '上游 false 左值选择 undefined/null 右值；ZX 明确为空的 bool? RHS 不能作为逻辑操作数，分析期拒绝。') + 'undefined 没有对应类型，单独记为设计不适用，不将其偷换成 null。', cases: and ? [rejected('literal/null_optional/left/false'), rejected('literal/null_optional/left/true')] : [rejected('literal/null_optional/right/false')] },
		{ file: `S${section}_A4_T1.js`, reason: (and ? 'true 左值对两种 bool RHS 的选择结果保持实际执行；右侧越界错误必须传播。' : 'true 左值对两种 bool RHS 都返回 true；右侧合法但越界表达式不执行。') + '其余四项 Boolean 包装身份断言不适用；普通对象静态拒绝只是 ZX 非 bool 契约证据，不是包装对象实现。', cases: [runtime('literal/true/false'), runtime('literal/true/true'), and ? selected : skipped, ...scalarCases('object')] },
		{ file: `S${section}_A4_T2.js`, reason: (and ? '非零 number 左值选择 ±0/NaN 右值的行为在 ZX 被静态 bool 要求拒绝，不声称验证相同值保真。' : '非零 number 左值保留自身，以及包装零/NaN对象仍 truthy 的行为，均不能用 bool 真值表替代；ZX 对数值逻辑操作静态拒绝。') + 'Number 包装构造与对象身份明确不适用。', cases: scalarCases('number') },
		{ file: `S${section}_A4_T3.js`, reason: (and ? '上游非空字符串左值返回右字符串。' : '上游非空字符串左值保留左字符串。') + 'ZX 空与非空字符串的左右逻辑操作均明确拒绝；四项 String 包装对象、构造参数转换及身份断言不适用，不以普通字符串相等冒充对象身份。', cases: [...literalCases('empty_string'), ...literalCases('nonempty_string')] },
		{ file: `S${section}_A4_T4.js`, reason: (and ? '上游 true && null/undefined 返回非 bool RHS；ZX 明确为空的 optional RHS 在分析期拒绝。' : '上游 true || null/undefined 跳过右值并成功；ZX 仍静态拒绝 optional RHS，同时用合法 bool 越界 RHS 验证真正的运行短路。') + 'undefined 类型不适用，未映射成 null。', cases: [rejected('literal/null_optional/right/true'), ...(and ? [] : [skipped])] },
		{ file: `symbol-${directory}-evaluation.js`, reason: '文件两项断言依赖 Symbol 的 ToBoolean 或返回 Symbol 身份。ZX 明确不提供 Symbol 与隐式 truthiness；bool 逻辑测试不能替代这些核心断言，因此逐文件记为设计不适用。', cases: [], excluded: true },
		{ file: 'tco-right.js', reason: '文件要求逻辑右操作数的深递归尾调用具备受限栈空间行为，并以最终调用计数验证。ZX 明确禁止递归与可逃逸函数，不承诺此尾调用模型；普通短路真值表不能替代栈空间性质，因此逐文件记为设计不适用。', cases: [], excluded: true },
	]

	for (const decision of decisions) {
		const path = `test/language/expressions/${directory}/${decision.file}`
		const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')

		if (index.get(path) !== sha256) throw new Error(`changed upstream source: ${path}`)

		const diagnostics = decision.cases.flatMap(id => {
			const row = frontend.get(id)

			return row?.diagnostic ? [{ case: id, phase: row.phase, code: row.diagnostic, ...(row.span ? { span: row.span } : {}) }] : []
		})
		const assertions = decision.cases.flatMap(id => {
			if (id === selected) return [{ case: id, field: 'error', expected: 'IndexOutOfBounds' as boolean | string }]
			if (id === skipped) return [{ case: id, field: 'value', expected: !and as boolean | string }]
			if (!id.startsWith(`language/expressions/${name}/source/`)) return []

			const suffix = id.split('/source/')[1]
			let expected: boolean

			if (suffix.startsWith('literal/')) {
				const [, left, right] = suffix.split('/')

				expected = and ? left === 'true' && right === 'true' : left === 'true' || right === 'true'
			} else if (suffix.startsWith('whitespace/')) expected = true
			else {
				assert.ok(['binding_left', 'binding_both', 'field_both'].includes(suffix))
				expected = !and
			}

			return [{ case: id, field: 'value', expected: expected as boolean | string }]
		})
		rows.push({ path, sha256, status: decision.excluded ? 'excluded' : 'adapted', reason: decision.reason, contract: decision.excluded ? 'docs/zx_design_doc.md' : 'packages/zx/IR契约.md#表达式与求值', cases: decision.cases, diagnostics, assertions })
	}
}

writeFileSync(join(root, 'packages/test/upstream/reviews/language/expressions/logical_binary.jsonl'), rows.map(row => JSON.stringify(row)).join('\n') + '\n')
console.log(`${rows.length} individually reviewed files written`)
