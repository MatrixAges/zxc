import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/switch_nested.jsonl'))
const groups = [
	{ name: 'missing_body', body: '  switch (in)\n', token: '}' },
	{ name: 'missing_label', body: '  switch (in) {\n    case:\n      return 1\n    default:\n      return 2\n  }\n', token: ':' },
	{ name: 'unlabelled_statement', body: '  switch (in) {\n    result = 2\n    case 0:\n      return 1\n    default:\n      return 2\n  }\n', token: 'result' },
]
const frontend = groups.map(group => {
	const source = `export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n${group.body}}\n`
	const start = group.name === 'missing_body' ? source.lastIndexOf('}') : source.indexOf(group.token, source.indexOf('switch'))
	return { id: `language/statements/switch_nested/${group.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + group.token.length] }
})
const path = 'tests/language/statements/switch/nested/cases'
const runtime = [0, 1].flatMap(outer => [0, 1].map(inner => ({ id: `language/statements/switch/nested/${outer}/${inner}`, input: { outer, inner }, expected: { value: outer !== 0 ? 32 : inner === 0 ? 6 : 64 } })))

writeOutput(`${path}.zx`, 'export type Input = { outer: u64, inner: u64 }\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  switch (in.outer) {\n    case 0:\n      switch (in.inner) {\n        case 0:\n          return 3 * 2\n        default:\n          return 32 * 2\n      }\n    default:\n      return 32\n  }\n}\n')
writeCatalog(`${path}.jsonl`, runtime)
writeCatalog('tests/language/statements/switch_nested/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/switch_nested.jsonl', samples.map((sample, index) => ({ ...sample, status: 'adapted', reason: index < 3 ? '保留缺switch体、缺case表达式或无标签语句结构，移除分号并用合法返回分支隔离错误；精确检查首个结构诊断，不声称var/可变累加/break支持。' : '只保留嵌套选择与分支算术结果，0/0复现原文6，内外输入拆分为ZX扩展。直接返回替代可变累加与break，不声称不可达赋值及贯穿兼容。', contract: 'packages/core/IR契约.md#表达式与求值', cases: index < 3 ? [frontend[index].id] : runtime.map(row => row.id) })))
