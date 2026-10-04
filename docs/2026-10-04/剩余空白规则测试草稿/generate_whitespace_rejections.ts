import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; token: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/whitespace_rejections.jsonl'))
const base = 'language/lexical/whitespace/rejections'
const prefix = 'export type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const'
const rows = samples.map(sample => ({
	id: `${base}/${sample.name}`,
	source: prefix + sample.token + 'x = 0\n\n  return x\n}\n',
	phase: 'parse',
	diagnostic: 'lexical',
	span: [Buffer.byteLength(prefix), Buffer.byteLength(prefix) + 1]
}))

writeCatalog(`tests/${base}/cases.jsonl`, rows)
writeCatalog('upstream/reviews/language/lexical/whitespace_rejections.jsonl', samples.map((sample, index) => ({
	path: sample.path,
	sha256: sample.sha256,
	status: 'adapted',
	reason: '保留代码 token 之间的原始反斜杠 Unicode 拼写或 U+180E 字节，var 改 const 并添加类型包装；验证这些形式不能充当空白的 parse/lexical 诊断及首字节范围。eval 原例静态化，不声称动态求值。',
	contract: 'packages/compiler/src/zx/frontend/lex.zig',
	cases: [rows[index].id],
	diagnostics: [{ case: rows[index].id, phase: rows[index].phase, code: rows[index].diagnostic, span: rows[index].span }]
})))
