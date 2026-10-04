import { writeCatalog } from './shared/catalog.ts'

type Row = { id: string; source: string; phase: string; diagnostic: string; span: Array<number> }
const rows: Array<Row> = []

for (const [name, operator] of [['equal', '=='], ['not_equal', '!=']]) {
	const initial = 0
	const assigned = 1
	const variants = [
		{ name: 'left_assignment', declaration: `  const x: f64 = ${initial};\n\n`, expression: `(x = ${assigned}) ${operator} x` },
		{ name: 'right_assignment', declaration: `  const x: f64 = ${initial};\n\n`, expression: `x ${operator} (x = ${assigned})` },
		{ name: 'unbound_then_assignment', declaration: '', expression: `x ${operator} (x = 1)` },
		{ name: 'implicit_global', declaration: '', expression: `(y = 1) ${operator} y` },
	]

	for (const variant of variants) {
		const source = `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n${variant.declaration}  return ${variant.expression};\n}\n`
		const start = source.indexOf(' = ', source.indexOf('return ')) + 1

		rows.push({ id: `language/types/equality_assignment/${name}/${variant.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] })
	}
}

writeCatalog('tests/language/types/equality_assignment/cases.jsonl', rows)
