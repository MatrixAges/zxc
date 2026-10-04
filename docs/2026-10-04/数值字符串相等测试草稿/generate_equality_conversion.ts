import { writeCatalog } from './shared/catalog.ts'

const groups: Record<string, Array<[string, string]>> = {
	number_string: [['1', '"1"'], ['1.100', '"+1.10"'], ['1', '"true"'], ['255', '"0xff"'], ['0', '""']],
	string_number: [['"-1"', '-1'], ['"-1.100"', '-1.10'], ['"false"', '0'], ['"5e-324"', '5e-324']],
}
const rows: Array<{ id: string; source: string; phase: string; diagnostic: string | null }> = []

for (const [name, operator] of [['equal', '=='], ['not_equal', '!=']]) {
	for (const [group, pairs] of Object.entries(groups)) {
		for (const [index, [left, right]] of pairs.entries()) {
			for (const shape of ['literal', 'bound']) {
				const left_type = group === 'number_string' ? 'f64' : 'string'
				const right_type = group === 'number_string' ? 'string' : 'f64'
				const body = shape === 'literal'
					? `  return ${left} ${operator} ${right};`
					: `  const left: ${left_type} = ${left};\n  const right: ${right_type} = ${right};\n\n  return left ${operator} right;`

				rows.push({
					id: `language/types/equality_conversion/${name}/${group}/${index + 1}/${shape}`,
					source: `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n${body}\n}\n`,
					phase: 'analyze',
					diagnostic: 'type_mismatch',
				})
			}
		}
	}

	for (const scalar of ['f64', 'string']) {
		rows.push({
			id: `language/types/equality_conversion/${name}/control/${scalar}`,
			source: `export type Input = { left: ${scalar}; right: ${scalar}; };\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  return in.left ${operator} in.right;\n}\n`,
			phase: 'analyze',
			diagnostic: null,
		})
	}
}

writeCatalog('tests/language/types/equality_conversion/cases.jsonl', rows)
