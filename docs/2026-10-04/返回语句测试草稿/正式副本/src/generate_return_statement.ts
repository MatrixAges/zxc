import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/return_statement.jsonl'))
const frontend = []
const runtime_ids: Array<string> = []
const endings = [{ name: 'plain', text: '' }, { name: 'lf', text: '\n' }, { name: 'cr', text: '\r' }, { name: 'crlf', text: '\r\n' }]

for (const ending of endings) {
	if (ending.text) {
		const path = `tests/language/statements/return/newline/${ending.name}`
		const id = `language/statements/return/newline/${ending.name}`

		writeOutput(`${path}.zx`, `export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return${ending.text}1;\n}\n`)
		writeCatalog(`${path}.jsonl`, [{ id, input: 0, expected: { value: 1 } }])
		runtime_ids.push(id)
	}

	for (const type of ['void', 'u64']) {
		const source = `export type Input = void;\n\nexport type Output = ${type};\n\nexport default function (in: Input): Output {\n  return${ending.text};\n}\n`

		frontend.push({ id: `language/statements/return/empty/${ending.name}/${type}`, source, phase: 'analyze', diagnostic: type === 'void' ? null : 'type_mismatch' })
	}
}

for (const [index, body] of ['return;\n  const value = 1;', 'return 1;\n  const value = 2;', 'return;\n  return;'].entries()) {
	frontend.push({ id: `language/statements/return/unreachable/${index}`, source: `export type Input = void;\n\nexport type Output = ${index === 1 ? 'u64' : 'void'};\n\nexport default function (in: Input): Output {\n  ${body}\n}\n`, phase: 'analyze', diagnostic: 'return_path' })
}

for (const point of [0x2028, 0x2029]) {
	const source = `export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return${String.fromCodePoint(point)}1;\n}\n`
	const start = Buffer.byteLength(source.slice(0, source.indexOf(String.fromCodePoint(point))))

	frontend.push({ id: `language/statements/return/unicode/${point.toString(16)}`, source, phase: 'parse', diagnostic: 'lexical', span: [start, start + 1] })
}

writeCatalog('tests/language/statements/return/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/statements/return.jsonl', samples.map(sample => {
	const name = sample.path.split('/').at(-1)!
	const cases = name === 'line-terminators.js' ? [...runtime_ids, ...frontend.slice(-2).map(row => row.id)] : name === 'S12.9_A5.js' ? frontend.slice(8, 11).map(row => row.id) : name === 'S12.9_A4.js' ? [] : frontend.slice(0, 8).map(row => row.id)

	return { ...sample, status: cases.length ? 'adapted' : 'excluded', reason: name === 'line-terminators.js' ? '保留LF/CR与Unicode分隔符。ZX ASCII换行返回1，与JS ASI得到undefined明确不同；CRLF为补充，Unicode为词法拒绝。' : name === 'S12.9_A5.js' ? '只适配return后继续语句的边界：ZX在静态分析拒绝不可达代码；用const/return保留结构，不声称支持原文可变状态或运行时忽略不可达语句。' : cases.length ? '适配空return及分号前换行，以void成功和u64类型拒绝检查ZX契约；不声称void等同JS undefined，不覆盖原for循环累加。' : '原文涉及返回捕获闭包、函数参数及Math.sin数值导数；ZX不支持该完整高阶闭包协议，不改写成普通标量返回冒充。', contract: 'packages/core/IR契约.md#表达式与求值', cases }
}))
