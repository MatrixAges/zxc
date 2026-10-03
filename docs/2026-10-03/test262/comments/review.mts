import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { readIndex } from '../../../../packages/test/src/shared/upstream.ts'
import { jsonLines, readRows } from '../../../../packages/test/src/shared/json.ts'

const indexed = readIndex()
const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd/'
type Review = {
	path: string
	sha256: string
	status: string
	reason: string
	contract: string
	cases: Array<string>
	diagnostics?: Array<{ case: string; phase: string; code: string; span?: Array<number> }>
}

function makeReview(args: { path: string; status: string; reason: string; cases: Array<string> }): Review {
	const { path, status, reason, cases } = args
	const sha256 = createHash('sha256')
		.update(readFileSync(root + path))
		.digest('hex')
	if (indexed.get(path) !== sha256) throw new Error('upstream hash mismatch: ' + path)

	return { path, sha256, status, reason, contract: 'packages/zx/IR契约.md#表达式与求值', cases }
}

const names = [
	'tab',
	'vertical_tab',
	'form_feed',
	'space',
	'nbsp',
	'line_feed',
	'carriage_return',
	'line_separator',
	'paragraph_separator',
	'combined'
]
const whitespace = makeReview({
	path: 'test/language/expressions/unary-minus/S11.4.7_A1.js',
	status: 'adapted',
	reason: '原十种间隔字符及组合分别放入普通取负、源码开头和模板插值。六种 ASCII 字符可解析并实际执行取负；NBSP、LS、PS 及含它们的组合以 lexical 诊断和精确字节位置拒绝。ZX 不执行 JavaScript eval，也不扩张现有 ASCII 空白集合。',
	cases: names.flatMap(name =>
		['unary', 'leading', 'interpolation'].map(context => `language/lexical/whitespace/${name}/${context}`)
	)
})
whitespace.cases.push(
	...names
		.filter(name => !['nbsp', 'line_separator', 'paragraph_separator', 'combined'].includes(name))
		.map(name => `language/lexical/comments/runtime/whitespace/${name}`)
)
const rows = readRows<{ id: string; phase: string; diagnostic: string | null; span?: Array<number> }>(
	'packages/test/tests/language/lexical/comments/cases.jsonl'
)
whitespace.diagnostics = rows
	.filter(row => whitespace.cases.includes(row.id) && row.diagnostic !== null)
	.map(row => ({ case: row.id, phase: row.phase, code: row.diagnostic!, span: row.span }))

const reviews = [whitespace]
for (const [file, name] of [
	['S7.4_A1_T2.js', 'triple_slash'],
	['S7.4_A4_T2.js', 'block_then_line'],
	['S7.4_A4_T3.js', 'line_in_block'],
	['S7.4_A4_T5.js', 'block_in_line'],
	['S7.4_A4_T6.js', 'extra_close_in_line'],
	['S7.4_A4_T7.js', 'blocks_in_lines']
]) {
	reviews.push(
		makeReview({
			path: 'test/language/comments/' + file,
			status: 'equivalent',
			reason: '保留上游注释文本，放在必需的 ZX 模块声明前。完整解析、分析和 IR 校验通过，证明注释中的斜杠、星号及伪代码未作为语法内容泄漏；不据此推断其他 JavaScript 语法兼容。',
			cases: ['language/lexical/comments/mixed/' + name]
		})
	)
}
reviews.push(
	makeReview({
		path: 'test/language/comments/S7.4_A2_T2.js',
		status: 'equivalent',
		reason: '原未闭合 /*CHECK#1/ 片段在普通源码与模板插值中均于 parse 的 lexical 阶段拒绝，并检查从注释开头到文件结束的 span。',
		cases: [
			'language/lexical/comments/unterminated/statement',
			'language/lexical/comments/unterminated/interpolation'
		]
	})
)

writeFileSync('packages/test/upstream/reviews/language/expressions/whitespace_comments.jsonl', jsonLines(reviews))
