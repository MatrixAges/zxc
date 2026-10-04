import { writeCatalog } from './shared/catalog.ts'

type Row = { id: string; source: string; phase: string; diagnostic: string; span: Array<number> }
const rows: Array<Row> = []

for (const [name, operator] of [['and', '&&'], ['or', '||']]) {
	const initial = name === 'or'
	const assigned = !initial
	const variants = [
		{ name: 'left_assignment', declaration: `  const x: bool = ${initial}

`, expression: `(x = ${assigned}) ${operator} x` },
		{ name: 'right_assignment', declaration: `  const x: bool = ${initial}

`, expression: `x ${operator} (x = ${assigned})` },
		{ name: 'unbound_then_assignment', declaration: '', expression: `x ${operator} (x = true)` },
		{ name: 'implicit_global', declaration: '', expression: `(y = true) ${operator} y` },
	]

	for (const variant of variants) {
		const source = `export type Input = void

export type Output = bool

export default function (in: Input): Output {
${variant.declaration}  return ${variant.expression}
}
`
		const start = source.indexOf(' = ', source.indexOf('return ')) + 1

		rows.push({ id: `language/types/logical_assignment/${name}/${variant.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] })
	}
}

writeCatalog('tests/language/types/logical_assignment/cases.jsonl', rows)
