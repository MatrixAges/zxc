import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_segments.jsonl'))
const literals = [
	{ name: 'empty', expression: '``', value: '' },
	{ name: 'foo', expression: '`foo`', value: 'foo' },
	{ name: 'bom', expression: '`\uFEFFtest`', value: '\uFEFFtest' },
]
const shapes = [
	{ name: 'empty_edges', expression: '`${in.left}`', position: 'head', text: '' },
	{ name: 'head_text', expression: '`foo${in.left}`', position: 'head', text: 'foo' },
	{ name: 'middle_empty', expression: '`${in.left}${in.right}`', position: 'middle', text: '' },
	{ name: 'middle_text', expression: '`${in.left}foo${in.right}`', position: 'middle', text: 'foo' },
	{ name: 'tail_text', expression: '`${in.left}foo`', position: 'tail', text: 'foo' },
]
const runtime = literals.map((literal, kind) => ({
	id: `language/expressions/template_segments/${literal.name}`,
	input: { kind, left: '', right: '' },
	expected: { value: literal.value },
}))

for (const [index, shape] of shapes.entries()) {
	const pairs = shape.position === 'middle' ? [['', ''], ['A', ''], ['', 'B'], ['甲', '${raw}\n']] : ['', 'A', '甲', '${raw}\n'].map(value => [value, ''])

	for (const [pair_index, [left, right]] of pairs.entries()) {
		const value = shape.position === 'head' ? shape.text + left : left + shape.text + right

		runtime.push({
			id: `language/expressions/template_segments/${shape.name}/${pair_index}`,
			input: { kind: literals.length + index, left, right },
			expected: { value },
		})
	}
}

const path = 'tests/language/expressions/template_segments/cases'
const branches = [...literals, ...shapes].map((shape, index) => `    case ${index}:\n      return ${shape.expression}`).join('\n')

writeOutput(`${path}.zx`, `export type Input = { kind: u64, left: string, right: string }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in.kind) {\n${branches}\n    default:\n      return ""\n  }\n}\n`)
writeCatalog(`${path}.jsonl`, runtime)
writeCatalog('upstream/reviews/language/expressions/template_segments.jsonl', samples.map(sample => {
	const selected = sample.name === 'tv-no-substitution' ? runtime.slice(0, 2) : sample.name === 'tv-zwnbsp' ? runtime.slice(2, 3) : []

	return {
		path: sample.path, sha256: sample.sha256, status: selected.length ? 'adapted' : 'excluded',
		reason: selected.length ? '仅保留无插值模板的普通cooked值；不覆盖tag/raw/调用次数，zwnbsp仅直接U+FEFF形式，Unicode转义形式不支持。' : '原文检查tag接收的head/middle/tail分段数组，ZX没有tagged模板协议；普通完整拼接无法证明这些数组元素断言，本地动态拼接不计为上游适配。',
		contract: 'packages/compiler/src/zx/frontend/template.zig',
		cases: selected.map(row => row.id),
		assertions: selected.map(row => ({ case: row.id, field: 'value', expected: row.expected.value })),
	}
}))
