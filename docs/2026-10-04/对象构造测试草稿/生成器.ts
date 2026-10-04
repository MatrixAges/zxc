import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; group: string; fields: Array<string>; values: Array<number> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/object_construction.jsonl'))
const reviews = []
const frontend = []

for (const sample of samples) {
	const path = `tests/language/expressions/object_construction/${sample.group}`
	const second = sample.group === 'merge' ? '  const o2 = { c: 4, d: 5 };\n' : ''
	const expression = sample.group === 'merge' ? '{...o, ...o2}' : '{a: 1, b: 7, ...o}'
	const fields = sample.fields.filter(field => !field.startsWith('o.'))
	const rows = fields.map((field, index) => ({ id: `language/expressions/object_construction/${sample.group}/${field}`, input: index, expected: { value: sample.values[index] } }))

	writeOutput(`${path}.zx`, `export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const o = { a: 2, b: 3 };\n${second}\n  const array = [${expression}];\n  const obj = array[0];\n  const observed: u64[] = [${fields.join(', ')}];\n\n  return observed[in];\n}\n`)
	writeCatalog(`${path}.jsonl`, rows)

	const rejected = []

	for (const field of sample.fields.filter(field => field.startsWith('o.'))) {
		const source = `export type Input = void;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  const o = { a: 2, b: 3 };\n  const array = [{a: 1, b: 7, ...o}];\n\n  return ${field};\n}\n`
		const id = `language/types/object_construction/consumed/${field}`

		frontend.push({ id, source, phase: 'analyze', diagnostic: 'ownership' })
		rejected.push(id)
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: 'adapted', reason: '保留对象spread、数组包装及被检查字段值，精确整数子集适配为u64；只覆盖字段合并/覆盖。展开消费本地所有者，原文后续源对象字段读取以ownership拒绝记录，未声称JS保留源对象语义通过。Function.apply/IIFE/callCount及Object.keys数量断言未移植，不声称实现动态调用或键枚举协议。', contract: 'packages/zx/IR契约.md#表达式与求值', cases: [...rows.map(row => row.id), ...rejected] })
}

writeCatalog('upstream/reviews/language/expressions/object_construction.jsonl', reviews)
writeCatalog('tests/language/types/object_construction/consumed.jsonl', frontend)

const shapes = [
	{ name: 'forward', literal: '{ a: LEFT, z: RIGHT }', result: 'in.pick_left ? value.a : value.z', selects: true },
	{ name: 'reverse', literal: '{ z: LEFT, a: RIGHT }', result: 'in.pick_left ? value.z : value.a', selects: true },
	{ name: 'nested', literal: '{ outer: { z: LEFT, a: RIGHT } }', result: 'in.pick_left ? value.outer.z : value.outer.a', selects: true },
	{ name: 'duplicate', literal: '{ item: LEFT, item: RIGHT }', result: 'value.item', selects: false },
	{ name: 'spread_first', literal: '{ ...{ item: LEFT }, item: RIGHT }', result: 'value.item', selects: false },
	{ name: 'spread_last', literal: '{ item: LEFT, ...{ item: RIGHT } }', result: 'value.item', selects: false },
]

for (const shape of shapes) {
	const path = `tests/runtime/evaluation_order/object/${shape.name}`
	const literal = shape.literal.replace('LEFT', 'readLeft(in.fail_left)').replace('RIGHT', 'readRight(in.fail_right)')

	writeOutput(`${path}.zx`, `import readLeft from "lib:probe-left";\nimport readRight from "lib:probe-right";\n\nexport type Input = { fail_left: bool; fail_right: bool; pick_left: bool; };\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n  const value = ${literal};\n\n  return ${shape.result};\n}\n`)

	const rows = []

	for (const fail_left of [false, true]) for (const fail_right of [false, true]) for (const pick_left of shape.selects ? [false, true] : [false]) {
		const trace = fail_left ? 'L' : 'LR'
		const error = fail_left ? 'LeftFailure' : fail_right ? 'RightFailure' : null

		rows.push({ id: `object_order/${shape.name}/left_${fail_left}/right_${fail_right}/pick_${pick_left}`, input: { fail_left, fail_right, pick_left }, expected: error ? { trace, error } : { trace, value: pick_left ? 2 : 3 } })
	}

	writeCatalog(`${path}.jsonl`, rows)
}
