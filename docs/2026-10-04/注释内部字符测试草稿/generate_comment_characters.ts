import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; fragments: Array<string> }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/comment_characters.jsonl'))
const base = 'language/lexical/comments/characters'
const inputs = [0n, 42n, 18446744073709551615n]
const reviews = []

for (const sample of samples) {
	const cases: Array<string> = []
	const assertions = []

	for (const [index, fragment] of sample.fragments.entries()) {
		const path = `${base}/${sample.name}/${index}`
		const rows = inputs.map(input => ({ id: `${path}/${input}`, input, expected: { value: input } }))

		writeOutput(`tests/${path}.zx`, 'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const x = in\n\n  ' + fragment + '\n\n  return x\n}\n')
		writeCatalog(`tests/${path}.jsonl`, rows)
		cases.push(...rows.map(row => row.id))
		assertions.push(...rows.map(row => ({ case: row.id, field: 'value', expected: row.input })))
	}

	reviews.push({
		path: sample.path,
		sha256: sample.sha256,
		status: 'adapted',
		reason: '保留原注释片段及其控制或 Unicode 字符；eval 字符串解码后静态编译，不声称实现动态 eval。注释内赋值仍是原文本，运行变量由输入初始化并验证保持原值。分别验证每个原片段及 0、42、u64 最大值。',
		contract: 'packages/compiler/src/zx/frontend/lex.zig',
		cases,
		assertions
	})
}

writeCatalog('upstream/reviews/language/lexical/comment_characters.jsonl', reviews)
