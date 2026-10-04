import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; kind: 'number' | 'string'; fragments: Array<string>; value: number | string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/whitespace_positions.jsonl'))
const reviews = []

for (const sample of samples) {
	const cases: Array<string> = []
	const assertions = []
	const numeric = sample.kind === 'number'

	for (const [index, fragment] of sample.fragments.entries()) {
		const path = `language/lexical/whitespace/positions/${sample.name}/${index}`
		const inputs = numeric ? [BigInt(sample.value), 0n, 42n, 18446744073709551615n] : [0n]
		const rows = inputs.map(input => ({ id: `${path}/${input}`, input, expected: { value: numeric ? input : sample.value } }))
		const body = numeric ? fragment + '\n\n  return x' : 'return ' + fragment

		writeOutput(`tests/${path}.zx`, 'export type Input = u64\n\nexport type Output = ' + (numeric ? 'u64' : 'string') + '\n\nexport default function (in: Input): Output {\n  ' + body + '\n}\n')
		writeCatalog(`tests/${path}.jsonl`, rows)
		cases.push(...rows.map(row => row.id))
		assertions.push(...rows.map(row => ({ case: row.id, field: 'value', expected: row.expected.value })))
	}

	reviews.push({
		path: sample.path,
		sha256: sample.sha256,
		status: 'adapted',
		reason: numeric ? '保留原 token 间实际空白序列，var 改 const、移除分号、初始化数字改为运行输入；包含原文数字及额外边界输入。' : '将 eval 解码后的字符串源码静态编译，仅将单引号改为 ZX 双引号，保留内部实际字符与完整期望值；不声称实现 eval。',
		contract: 'packages/compiler/src/zx/frontend/lex.zig',
		cases,
		assertions
	})
}

writeCatalog('upstream/reviews/language/lexical/whitespace_positions.jsonl', reviews)
