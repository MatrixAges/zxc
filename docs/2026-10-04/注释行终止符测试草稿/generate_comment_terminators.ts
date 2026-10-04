import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; fragment: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/comment_terminators.jsonl'))
const inputs = [0n, 42n, 18446744073709551615n]
const reviews = []

for (const sample of samples) {
	const path = `language/lexical/comments/terminators/${sample.name}`
	const rows = inputs.map(input => ({ id: `${path}/${input}`, input, expected: { value: input } }))

	writeOutput(`tests/${path}.zx`, 'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  ' + sample.fragment + 'return in\n}\n')
	writeCatalog(`tests/${path}.jsonl`, rows)
	reviews.push({
		path: sample.path,
		sha256: sample.sha256,
		status: 'adapted',
		reason: '保留原单行注释和真实LF/CR，其后紧邻return，无额外终止字符；原文通过预期Test262Error证明后续语句可达，ZX改为返回运行输入并校验值，不声称实现异常系统。',
		contract: 'packages/compiler/src/zx/frontend/lex.zig',
		cases: rows.map(row => row.id),
		assertions: rows.map(row => ({ case: row.id, field: 'value', expected: row.input }))
	})
}

writeCatalog('upstream/reviews/language/lexical/comment_terminators.jsonl', reviews)
