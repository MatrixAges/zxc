import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { kind: string; path: string; sha256: string }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/array_spread.jsonl'))
const frontend = []
const reviews = []
const runtime = [
	{ id: 'language/expressions/object_construction/copy/c', input: false, expected: { value: 3 } },
	{ id: 'language/expressions/object_construction/copy/d', input: true, expected: { value: 4 } },
]

for (const sample of samples) {
	const cases: Array<string> = []
	let reason = '原文自定义Symbol.iterator，每轮调用next并检查done/value，再经apply观察参数。ZX没有该动态协议，不能以已知数组替换后宣称迭代行为实现。'

	if (sample.kind === 'obj-ident') {
		cases.push(...runtime.map(row => row.id))
		reason = '保留[{...o}]对象复制及c=3/d=4字段值，显式bool选择读取字段；verifyProperty的enumerable/writable/configurable、Object.keys数量和apply/callCount不适配，不声称JS描述符与调用协议通过。'
	} else if (sample.kind !== 'iter') {
		const expression = sample.kind === 'empty' ? '[...[]]' : sample.kind === 'literal' ? '[...[3, 4, 5]]' : '[...target = source]'
		const declaration = sample.kind === 'expr' ? '  const source: u64[] = [2, 3, 4]\n\n' : ''
		const source = `export type Input = void

export type Output = u64[]

export default function (in: Input): Output {
${declaration}  return ${expression}
}
`
		const start = source.indexOf('...')
		const id = `language/types/array_spread/${sample.kind}`

		frontend.push({ id, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 3] })
		cases.push(id)
		reason = '保留原数组spread表达式并精确定位...语法拒绝；source静态声明只为保持原值，[...target = source]中的赋值/未初始化target、迭代器与apply参数检查均未实现，不以parse拒绝宣称运行断言通过。'
	}

	reviews.push({ path: sample.path, sha256: sample.sha256, status: sample.kind === 'iter' ? 'excluded' : 'adapted', reason, contract: 'packages/core/IR契约.md#表达式与求值', cases })
}

writeOutput('tests/language/expressions/object_construction/copy.zx', 'export type Input = bool\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const o = { c: 3, d: 4 }\n  const values = [{...o}]\n  const value = values[0]\n\n  return in ? value.d : value.c\n}\n')
writeCatalog('tests/language/expressions/object_construction/copy.jsonl', runtime)
writeCatalog('tests/language/types/array_spread/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/array_spread.jsonl', reviews)
