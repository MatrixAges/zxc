import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; literal: string; expected: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/string_source.jsonl'))
const base = 'language/lexical/string/source_characters/cases'
const branches = samples.map((sample, index) => '    case ' + index + ':\n      return ' + sample.literal).join('\n')

writeOutput(
	'tests/' + base + '.zx',
	'export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in) {\n' +
		branches +
		'\n    default:\n      return ""\n  }\n}\n'
)
writeCatalog('tests/' + base + '.jsonl', [
	...samples.map((sample, index) => ({
		id: base + '/' + sample.name,
		input: index,
		expected: { value: sample.expected }
	})),
	{ id: base + '/fallback', input: samples.length, expected: { value: '' } }
])
writeCatalog(
	'upstream/reviews/language/literals/source_characters.jsonl',
	samples.map(sample => ({
		path: sample.path,
		sha256: sample.sha256,
		status: 'adapted',
		reason: '保留原文测试主体中的实际Unicode源字符，生成并执行ZX返回值；期望字符从原文右侧Unicode转义独立解码为UTF8。这里只适配源字符可出现于字符串的断言，不宣称ZX支持Unicode转义语法。',
		contract: 'packages/compiler/src/zx/frontend/lex.zig',
		cases: [base + '/' + sample.name],
		assertions: [{ case: base + '/' + sample.name, field: 'value', expected: sample.expected }]
	}))
)
