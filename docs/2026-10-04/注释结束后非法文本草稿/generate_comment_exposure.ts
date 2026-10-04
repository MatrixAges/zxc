import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; fragment: string; marker: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/comment_exposure.jsonl'))
const base = 'language/lexical/comments/exposure'
const prefix = 'export type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const x = '
const rows = samples.map(sample => {
	const source = prefix + sample.fragment + '\n\n  return x\n}\n'
	const start = Buffer.byteLength(prefix + sample.fragment.slice(0, sample.fragment.indexOf(sample.marker)))

	return { id: `${base}/${sample.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + Buffer.byteLength(sample.marker)] }
})

writeCatalog(`tests/${base}/cases.jsonl`, rows)
writeCatalog('upstream/reviews/language/lexical/comment_exposure.jsonl', samples.map((sample, index) => ({
	path: sample.path,
	sha256: sample.sha256,
	status: 'adapted',
	reason: '保留原单行注释、实际CR/LF和其后非法文本，放入ZX初始化表达式位置；验证注释后问号或相邻名称的parse/syntax及精确字节范围，不以注释内部拒绝替代。S7.3_A3.2_T1描述CR但源字节为LF，按源字节保留。',
	contract: 'packages/compiler/src/zx/frontend/lex.zig',
	cases: [rows[index].id],
	diagnostics: [{ case: rows[index].id, phase: rows[index].phase, code: rows[index].diagnostic, span: rows[index].span }]
})))
