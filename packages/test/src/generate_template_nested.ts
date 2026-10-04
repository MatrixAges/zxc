import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; expression: string; expected: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_nested.jsonl'))

for (const sample of samples) {
	const path = `tests/language/expressions/template_nested/${sample.name}`

	writeOutput(`${path}.zx`, `export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${sample.expression}\n}\n`)
	writeCatalog(`${path}.jsonl`, [{ id: `language/expressions/template_nested/${sample.name}`, input: 0, expected: { value: sample.expected } }])
}

const path = 'tests/language/expressions/template_nested/dynamic'
const expression = '`${in.left} ${in.right} ${`bar ${in.inner} baz`} qux`'
const runtime = [-1, 0].flatMap(left => [-1, 0].flatMap(right => [-1, 0].map(inner => ({
	id: `language/expressions/template_nested/dynamic/${left}/${right}/${inner}`,
	input: { left, right, inner },
	expected: { value: [String(left), String(right), 'bar', String(inner), 'baz', 'qux'].join(' ') },
}))))

writeOutput(`${path}.zx`, `export type Input = { left: i64, right: i64, inner: i64 }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`)
writeCatalog(`${path}.jsonl`, runtime)
writeCatalog('upstream/reviews/language/expressions/template_nested.jsonl', samples.map(sample => ({
	path: sample.path, sha256: sample.sha256, status: 'adapted',
	reason: '完整保留原文模板表达式和ASCII字符串预期，包装ZX显式函数后实际编译运行；仅证明本例嵌套与小整数插值，不扩展到tagged/raw、动态对象ToString或一般数值格式。',
	contract: 'packages/compiler/src/zx/analysis/strings.zig',
	cases: [`language/expressions/template_nested/${sample.name}`],
	assertions: [{ case: `language/expressions/template_nested/${sample.name}`, field: 'value', expected: sample.expected }],
})))
