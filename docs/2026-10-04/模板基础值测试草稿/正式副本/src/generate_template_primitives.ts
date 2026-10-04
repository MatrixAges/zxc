import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Group = { path: string; sha256: string; samples: Array<{ original: string; expression: string; expected: string }> }

const groups = readRows<Group>(resolve(package_dir, 'src/data/template_primitives.jsonl'))
const samples = groups.flatMap(group => group.samples)
const path = 'tests/language/expressions/template_primitives/original'
const branches = samples.map((sample, index) => `    case ${index}:\n      return ${sample.expression}`).join('\n')
const runtime = samples.map((sample, index) => ({ id: `language/expressions/template_primitives/original/${index}`, input: index, expected: { value: sample.expected } }))

writeOutput(`${path}.zx`, `export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in) {\n${branches}\n    default:\n      return ""\n  }\n}\n`)
writeCatalog(`${path}.jsonl`, runtime)

const dynamic_path = 'tests/language/expressions/template_primitives/dynamic'
const expression = '`value=${in.value}|flag=${in.flag}|text=${in.text}`'
const values = [-1, 0, 5].flatMap(value => [false, true].flatMap(flag => ['', '汉', '${literal}'].map((text, index) => ({
	id: `language/expressions/template_primitives/dynamic/${value}/${flag}/${index}`,
	input: { value, flag, text },
	expected: { value: 'value=' + String(value) + '|flag=' + (flag ? 'true' : 'false') + '|text=' + text },
}))))

writeOutput(`${dynamic_path}.zx`, `export type Input = { value: i64, flag: bool, text: string }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${expression}\n}\n`)
writeCatalog(`${dynamic_path}.jsonl`, values)
writeCatalog('upstream/reviews/language/expressions/template_primitives.jsonl', groups.map((group, index) => ({
	path: group.path, sha256: group.sha256, status: 'adapted',
	reason: '保留原文数字5和字符串string在模板中的位置及两条预期；仅把字符串单引号换为ZX双引号。原文不含bool/null/undefined，不扩展宣称一般ToString兼容。',
	contract: 'packages/compiler/src/zx/analysis/strings.zig',
	cases: runtime.slice(index * 2, index * 2 + 2).map(row => row.id),
	assertions: runtime.slice(index * 2, index * 2 + 2).map(row => ({ case: row.id, field: 'value', expected: row.expected.value })),
})))
