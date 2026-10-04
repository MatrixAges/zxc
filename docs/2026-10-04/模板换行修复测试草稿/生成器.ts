import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_newlines.jsonl'))
const shapes = [
	{ name: 'lf', expression: '`A\nB`', expected: 'A\nB' },
	{ name: 'cr', expression: '`A\rB`', expected: 'A\nB' },
	{ name: 'crlf', expression: '`A\r\nB`', expected: 'A\nB' },
	{ name: 'ls', expression: '`A\u2028B`', expected: 'A\u2028B' },
	{ name: 'ps', expression: '`A\u2029B`', expected: 'A\u2029B' },
	{ name: 'template_escape_r', expression: '`A\\rB`', expected: 'A\rB' },
	{ name: 'quoted_escape_r', expression: '"A\\rB"', expected: 'A\rB' },
	{ name: 'mixed_raw_escaped', expression: '`A\r\\rB`', expected: 'A\n\rB' },
	{ name: 'literal_backslash_r', expression: '`A\\\\rB`', expected: 'A\\rB' },
	{ name: 'interpolated_raw', expression: '`A\r${in}\r\nB`', expected: '' },
	{ name: 'repeated_cr', expression: '`A\r\r\nB`', expected: 'A\n\nB' },
	{ name: 'original_mixed', expression: '`\r\n\n\r`', expected: '\n\n\n' },
	{ name: 'original_ls', expression: '`\u2028`', expected: '\u2028' },
	{ name: 'original_ps', expression: '`\u2029`', expected: '\u2029' },
]
const path = 'tests/language/expressions/template_newlines/cases'
const branches = shapes.map((shape, index) => `    case ${index}:\n      return ${shape.expression}`).join('\n')
const runtime = shapes.map((shape, index) => ({
	id: `language/expressions/template_newlines/${shape.name}`,
	input: index,
	expected: { value: shape.name === 'interpolated_raw' ? 'A\n' + String(index) + '\nB' : shape.expected },
}))

writeOutput(`${path}.zx`, `export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in) {\n${branches}\n    default:\n      return ""\n  }\n}\n`)
writeCatalog(`${path}.jsonl`, runtime)

const cases = runtime.filter(row => row.id.includes('/original_'))

writeCatalog('upstream/reviews/language/expressions/template_newlines.jsonl', samples.map(sample => ({
	...sample, status: 'adapted',
	reason: '保留原文CRLF+LF+CR、LS、PS三个普通模板解码值，实际编译验证原始CR/CRLF归一LF；移除tag包装，不声称raw数组和调用次数协议。历史差异经当前实现修复并独立字节探针复验。',
	contract: 'packages/core/IR契约.md#表达式与求值',
	cases: cases.map(row => row.id),
	assertions: cases.map(row => ({ case: row.id, field: 'value', expected: row.expected.value })),
})))
