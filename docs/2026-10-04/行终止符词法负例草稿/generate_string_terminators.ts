import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; expression: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/string_terminators.jsonl'))
const base = 'language/lexical/strings/terminators'
const prefix = 'export type Input = void\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return '
const start = Buffer.byteLength(prefix)
const rows = samples.map(sample => ({
	id: `${base}/${sample.name}`,
	source: prefix + sample.expression + '\n}\n',
	phase: 'parse',
	diagnostic: 'lexical',
	span: [start, start + 2]
}))

writeCatalog(`tests/${base}/cases.jsonl`, rows)
writeCatalog('upstream/reviews/language/lexical/string_terminators.jsonl', samples.map((sample, index) => ({
	path: sample.path,
	sha256: sample.sha256,
	status: 'adapted',
	reason: '保留原始字符串内部未转义CR/LF，仅把单引号定界符适配为双引号；验证parse/lexical和开引号至首控制字符的精确字节范围。A2.2_T2描述CR但源字节为LF，按源字节保留。',
	contract: 'packages/compiler/src/zx/frontend/lex.zig',
	cases: [rows[index].id],
	diagnostics: [{ case: rows[index].id, phase: rows[index].phase, code: rows[index].diagnostic, span: rows[index].span }]
})))
