import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; expression: string; expected: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/template_calls.jsonl'))
const base = 'tests/language/expressions/template_calls'

writeOutput(`${base}/helpers/constant.zx`, 'export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return "result"\n}\n')
writeOutput(`${base}/helpers/identity.zx`, 'export type Input = string\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return in\n}\n')

for (const sample of samples) {
	for (const mode of ['original', 'dynamic']) {
		const original = mode === 'original'
		const helper = original ? 'constant' : 'identity'
		const input_type = original ? 'u64' : 'string'
		const path = `${base}/${sample.name}/${mode}`
		const values = original ? [0] : ['', 'result', '${unchanged}', '甲\n乙']
		const rows = values.map((value, index) => ({
			id: `language/expressions/template_calls/${sample.name}/${mode}/${index}`,
			input: value,
			expected: { value: original ? sample.expected : sample.expected.replace('result', () => String(value)) },
		}))

		writeOutput(`${path}.zx`, `import fn from "../helpers/${helper}.zx"\n\nexport type Input = ${input_type}\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return ${sample.expression}\n}\n`)
		writeCatalog(`${path}.jsonl`, rows)
	}
}

writeCatalog('upstream/reviews/language/expressions/template_calls.jsonl', samples.map(sample => {
	const id = `language/expressions/template_calls/${sample.name}/original/0`

	return {
		path: sample.path, sha256: sample.sha256, status: 'adapted',
		reason: '保留三个位置的实际函数调用、常量返回result与完整模板预期；局部JS函数改为ZX导入模块并传递显式输入，不声称局部函数声明或对象方法语法兼容。动态返回值另作原生补充。',
		contract: 'packages/core/IR契约.md',
		cases: [id],
		assertions: [{ case: id, field: 'value', expected: sample.expected }],
	}
}))
