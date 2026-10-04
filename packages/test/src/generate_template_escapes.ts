import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; expression: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_escapes.jsonl'))
const controls = [
	{ name: 'hex_valid', expression: '`\\x41`' },
	{ name: 'unicode_valid', expression: '`\\u0041`' },
	{ name: 'code_point_valid', expression: '`\\u{1F639}`' },
	{ name: 'null_valid', expression: '`\\0`' },
	{ name: 'identity_valid', expression: '`\\q`' },
]
const accepted = [
	{ name: 'newline', expression: '`\\n`' },
	{ name: 'backslash', expression: '`\\\\u0041`' },
	{ name: 'backtick', expression: '`\\``' },
	{ name: 'dollar', expression: '`\\${literal}`' },
]
const rows = []

for (const [group, entries] of [['upstream', samples], ['js_valid', controls], ['supported', accepted]] as const) {
	for (const sample of entries) {
		for (const context of ['direct', 'nested']) {
			const literal = sample.expression.replace("'inner'", '"inner"')
			const expression = context === 'direct' ? literal : '`前${' + literal + '}后`'
			const source = `export type Input = void\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`
			const start = Buffer.byteLength(source.slice(0, source.indexOf('\\')))
			const supported = group === 'supported'

			rows.push({
				id: `language/lexical/template_escapes/${group}/${sample.name}/${context}`,
				source,
				phase: supported ? 'analyze' : 'parse',
				diagnostic: supported ? null : 'lexical',
				...(!supported ? { span: [start, start + 2] } : {}),
			})
		}
	}
}

writeCatalog('tests/language/lexical/template_escapes/cases.jsonl', rows)
writeCatalog('upstream/reviews/language/expressions/template_escapes.jsonl', samples.map(sample => ({
	path: sample.path, sha256: sample.sha256, status: 'excluded',
	reason: '原文非法模板转义已独立验证SyntaxError，但ZX在转义起始处整体拒绝x/u/数字序列；合法JS序列对照也被拒绝，因此本地lexical拒绝不证明上游具体规则兼容，不登记适配或等价通过。',
	contract: 'packages/compiler/src/zx/frontend/template.zig',
	cases: [],
})))
