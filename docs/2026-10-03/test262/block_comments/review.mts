import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { readIndex } from '../../../../packages/test/src/shared/upstream.ts'
import { jsonLines, readRows } from '../../../../packages/test/src/shared/json.ts'

const indexed = readIndex()
const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd/'
const cases = readRows<{ id: string; phase: string; diagnostic: string | null; span?: Array<number> }>(
	'packages/test/tests/language/lexical/comments/block/structure.jsonl'
)
const reviews = []

for (const [file, name] of [
	['S7.4_A3.js', 'nested'],
	['S7.4_A4_T1.js', 'extra_close'],
	['S7.4_A4_T4.js', 'line_open']
]) {
	const path = 'test/language/comments/' + file
	const sha256 = createHash('sha256')
		.update(readFileSync(root + path))
		.digest('hex')
	if (indexed.get(path) !== sha256) throw new Error(path)

	const linked = cases.filter(row => row.id.startsWith(`language/lexical/comments/block/${name}/`))
	reviews.push({
		path,
		sha256,
		status: 'adapted',
		contract: 'packages/zx/IR契约.md#表达式与求值',
		reason: '原注释片段分别放在模块前和模板插值中。首个 */ 结束块注释，剩余代码在模块前以 parse/contract 拒绝，在插值中以 parse/syntax 拒绝；两者均检查精确字节位置。模块诊断类别来自 ZX 顶层只允许导入、类型和默认函数的契约，不冒充 JavaScript SyntaxError 类型。',
		cases: linked.map(row => row.id),
		diagnostics: linked.map(row => ({ case: row.id, phase: row.phase, code: row.diagnostic, span: row.span }))
	})
}

for (const [file, mode] of [
	['S7.4_A5.js', 'line'],
	['S7.4_A6.js', 'block']
]) {
	const path = 'test/language/comments/' + file
	const sha256 = createHash('sha256')
		.update(readFileSync(root + path))
		.digest('hex')
	if (indexed.get(path) !== sha256) throw new Error(path)

	reviews.push({
		path,
		sha256,
		status: 'adapted',
		contract: 'packages/zx/IR契约.md#表达式与求值',
		reason:
			mode === 'line'
				? '完整遍历原 0..FFFF 范围。63,486 个非 CR/LF BMP 标量在行注释内通过解析分析和 IR 校验；CR/LF 使后续 xx 赋值可见并触发精确顶层 contract 诊断。LS/PS 在 ZX 注释中不终止，与 JavaScript 不同。2,048 个 surrogate 对应非法 UTF-8 字节以 lexical 拒绝；未执行 JavaScript eval。整个范围仅计一个案例。'
				: '完整遍历原 0..FFFF 范围。63,488 个 BMP 标量放入原 /*var 字符 xx=1*/ 结构后全部通过解析分析和 IR 校验；2,048 个孤立 surrogate 无合法 UTF-8 表示，对应字节以 lexical 拒绝。明确区别 JavaScript UTF-16 码元与 ZX UTF-8 源码，不声称执行 eval。整个范围仅计一个案例。',
		cases: [`language/lexical/comments/unicode/${mode}_bmp`]
	})
}

writeFileSync('packages/test/upstream/reviews/language/expressions/block_comments.jsonl', jsonLines(reviews))
