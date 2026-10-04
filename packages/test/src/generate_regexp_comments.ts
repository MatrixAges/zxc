import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'language/lexical/comments/regexp_boundary'
const endings = { lf: '\n', cr: '\r', crlf: '\r\n' }
const inputs = [0n, 42n, 18446744073709551615n]
const runtime_ids: Array<string> = []

for (const [name, ending] of Object.entries(endings)) {
	const rows = inputs.map(input => ({
		id: `${base}/${name}/${input}`,
		input,
		expected: { value: input }
	}))

	runtime_ids.push(...rows.map(row => row.id))
	writeCatalog(`tests/${base}/${name}.jsonl`, rows)
	writeOutput(
		`tests/${base}/${name}.zx`,
		'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const value = //.source;' +
			ending +
			'    in\n\n  return value\n}\n'
	)
}

const prefix =
	'export type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const value = '
const fragments = { unclosed_block: '/*/', triple_slash: '///\n.source;', empty_line: '//\n.source;' }
const frontend = Object.entries(fragments).map(([name, fragment]) => {
	const block = name === 'unclosed_block'
	const source = prefix + fragment + (block ? '' : '\n  return value\n}\n')
	const start = block ? prefix.length : source.indexOf('.source')

	return {
		id: `${base}/invalid/${name}`,
		source,
		phase: 'parse',
		diagnostic: block ? 'lexical' : 'syntax',
		span: [start, block ? source.length : start + 1]
	}
})

writeCatalog(`tests/${base}/invalid.jsonl`, frontend)

const origins = {
	'7.8.5-1gs.js': 'b011a3fda28d62564c2b955648c06f716e5edefe01a2fad7a02b6d71ac2e20b9',
	'S7.8.5_A1.2_T1.js': '33e0e27331ea23bc70dac6539c402fcd43b0c083aa4d5da2e4b5c05ae2d70072',
	'S7.8.5_A1.2_T3.js': 'f81e9df2f33b1e7e61127f36e10cf04c0443f345470eb6c93b523a1e7fbf1d13',
	'S7.8.5_A1.2_T4.js': '7eb080d9147f6f913485282c4919eca1c4d2d18e3284f3ced47c5baf8c1684d8'
}
const mappings = [
	{
		name: '7.8.5-1gs.js',
		cases: runtime_ids,
		reason: '保留 //.source; 后换行继续初始化表达式的原始结构，以运行输入替代原文y，LF/CR/CRLF和0/42/u64最大值均真实执行；这里只验证双斜杠为注释，不构建正则对象。'
	},
	{
		name: 'S7.8.5_A1.2_T1.js',
		cases: [base + '/invalid/unclosed_block'],
		reason: '保留原文 /*/ 作为未闭合块注释，验证lexical及开头到EOF的精确范围，不以任意正则解析错误替代。'
	},
	{
		name: 'S7.8.5_A1.2_T3.js',
		cases: [base + '/invalid/triple_slash'],
		reason: '保留三斜杠行注释后无接收者的.source片段，在ZX初始化表达式位置验证点号syntax诊断；不宣称正则语法支持。'
	},
	{
		name: 'S7.8.5_A1.2_T4.js',
		cases: [base + '/invalid/empty_line'],
		reason: '保留空行注释后无接收者的.source片段，验证点号syntax诊断，证明拒绝原因而非只判断非零退出。'
	}
]

writeCatalog(
	'upstream/reviews/language/literals/regexp_comments.jsonl',
	mappings.map(mapping => ({
		path: 'test/language/literals/regexp/' + mapping.name,
		sha256: origins[mapping.name as keyof typeof origins],
		status: 'adapted',
		reason: mapping.reason,
		contract: 'packages/compiler/src/zx/frontend/lex.zig',
		cases: mapping.cases
	}))
)
