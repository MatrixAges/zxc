import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; expression: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/coalesce_mixing.jsonl'))
const rows = []
const reviews = []

for (const sample of samples) {
	const [left, first, middle, second, right] = sample.expression.split(' ')
	const shapes = [
		{ name: 'original', expression: sample.expression, rejected: true },
		{ name: 'outer_group', expression: '(' + sample.expression + ')', rejected: true },
		{ name: 'left_group', expression: `(${left} ${first} ${middle}) ${second} ${right}`, rejected: false },
		{ name: 'right_group', expression: `${left} ${first} (${middle} ${second} ${right})`, rejected: false },
	]
	const cases = shapes.map(shape => {
		const source = `export type Input = void\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n  return ${shape.expression}\n}\n`
		const start = source.indexOf(second)

		return {
			id: `language/expressions/coalesce_mixing/${sample.name}/${shape.name}`,
			source, phase: 'parse', diagnostic: shape.rejected ? 'syntax' : null,
			...(shape.rejected ? { span: [start, start + second.length] } : {}),
		}
	})
	const rejected = cases.filter(row => row.diagnostic !== null)

	rows.push(...cases)
	reviews.push({
		path: sample.path, sha256: sample.sha256, status: 'adapted',
		reason: '保留原始操作数与混合顺序，仅加ZX函数壳；直接及整式括号均在parse阶段拒绝，检查syntax和混合运算符位置。子式括号对照只证明解析通过，不声称JS动态类型转换。',
		contract: 'packages/compiler/src/zx/frontend/parser_expressions.zig',
		cases: rejected.map(row => row.id),
		diagnostics: rejected.map(row => ({ case: row.id, phase: row.phase, code: row.diagnostic, span: row.span })),
	})
}

writeCatalog('tests/language/expressions/coalesce_mixing/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/coalesce_mixing.jsonl', reviews)
