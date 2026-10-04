import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/array_properties.jsonl'))
const source = 'export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const array: u64[] = [,];\n\n  return array.length;\n}\n'
const start = source.indexOf('[,]') + 1
const id = 'language/types/array_literal/single_elision'

writeCatalog('tests/language/types/array_literal/single_elision.jsonl', [{ id, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] }])
writeCatalog('upstream/reviews/language/expressions/array_properties.jsonl', samples.map(sample => ({
	...sample,
	status: sample.path.endsWith('11.1.4-0.js') ? 'adapted' : 'excluded',
	reason: sample.path.endsWith('11.1.4-0.js') ? '原文[,]实际长度断言为1；保留单空位字面量，以ZX语法拒绝定位逗号。没有将空位替成值，也不声称原JS长度断言执行。' : '原文修改Array.prototype只读索引后验证字面量仍创建自身元素及正确数值（正文未直接检查新元素的writable描述符），ZX没有JS原型和属性描述符；普通列表元素值通过不足以证明该机制，不建立替代通过关联。',
	contract: 'packages/zx/IR契约.md#表达式与求值',
	cases: sample.path.endsWith('11.1.4-0.js') ? [id] : [],
})))

for (const shape of ['flat', 'nested']) {
	const path = `tests/runtime/evaluation_order/array/${shape}`
	const declaration = shape === 'flat'
		? '  const values: f64[] = [readLeft(in.fail_left), readRight(in.fail_right)];'
		: '  const values: f64[][] = [[readLeft(in.fail_left)], [readRight(in.fail_right)]];'
	const value = shape === 'flat' ? 'values[in.index]' : 'values[in.index][0]'

	writeOutput(`${path}.zx`, `import readLeft from "lib:probe-left";\nimport readRight from "lib:probe-right";\n\nexport type Input = { fail_left: bool; fail_right: bool; index: u64; };\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n${declaration}\n\n  return ${value};\n}\n`)

	const rows = []

	for (const fail_left of [false, true]) for (const fail_right of [false, true]) for (const index of [0, 1, 2]) {
		const trace = fail_left ? 'L' : 'LR'
		const error = fail_left ? 'LeftFailure' : fail_right ? 'RightFailure' : index === 2 ? 'IndexOutOfBounds' : null
		const expected = error ? { trace, error } : { trace, value: index === 0 ? 2 : 3 }

		rows.push({ id: `array_order/${shape}/left_${fail_left}/right_${fail_right}/index_${index}`, input: { fail_left, fail_right, index }, expected })
	}

	writeCatalog(`${path}.jsonl`, rows)
}
