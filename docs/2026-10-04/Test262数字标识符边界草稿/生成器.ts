import { writeCatalog } from './shared/catalog.ts'

const expressions = ['e1', 'E1', 'e-1', 'E-1', 'e+1', 'E+1', 'e0', 'E0']
const rows = expressions.flatMap((expression, index) => [false, true].map(declared => {
	const name = expression.match(/^[A-Za-z][0-9]*/)![0]
	const declaration = declared ? '  const ' + name + ' = in\n\n' : ''
	const source = 'export type Input = f64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n' + declaration + '  return ' + expression + '\n}\n'
	const start = source.indexOf('return ') + 7

	return {
		id: 'language/lexical/numeric/exponent_names/' + index + '/' + (declared ? 'bound' : 'unbound'),
		source,
		phase: 'analyze',
		diagnostic: declared ? null : 'name',
		...(!declared ? { span: [start, start + name.length] } : {}),
	}
}))

writeCatalog('tests/language/lexical/numeric/exponent_names/cases.jsonl', rows)
