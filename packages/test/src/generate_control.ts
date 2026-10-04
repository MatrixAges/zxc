import { writeCatalog, writeOutput } from './shared/catalog.ts'

const maximum = 2n ** 64n - 1n
const indexed = 'items: u64[], index: u64,'
const logical = 'left: bool, ' + indexed
const nested = 'left: bool, middle: bool, ' + indexed
const conditional = 'choose: bool, fallback: u64, ' + indexed
const suites = [
	['logical_and/basic', logical, 'bool', 'in.left && in.items[in.index] > 0'],
	['logical_or/basic', logical, 'bool', 'in.left || in.items[in.index] > 0'],
	['logical_and/nested_or', nested, 'bool', 'in.left && (in.middle || in.items[in.index] > 0)'],
	['logical_or/nested_and', nested, 'bool', 'in.left || in.middle && in.items[in.index] > 0'],
	['conditional/yes', conditional, 'u64', 'in.choose ? in.items[in.index] : in.fallback'],
	['conditional/no', conditional, 'u64', 'in.choose ? in.fallback : in.items[in.index]'],
	['coalesce/optional', 'value: u64?, ' + indexed, 'u64', 'in.value ?? in.items[in.index]']
]

type Choice = { value?: bigint | null; choose?: boolean; fallback?: bigint; left?: boolean; middle?: boolean }
type Input = Choice & { items: Array<bigint>; index: bigint }

function choices(name: string): Array<[string, Choice]> {
	if (name.startsWith('coalesce'))
		return [
			['null', { value: null }],
			['zero', { value: 0n }],
			['ordinary', { value: 42n }],
			['maximum', { value: maximum }]
		]
	if (name.startsWith('conditional'))
		return [false, true].map(value => [String(value), { choose: value, fallback: 42n }])
	if (name.includes('nested'))
		return [false, true].flatMap(left =>
			[false, true].map(middle => [`${left}_${middle}`, { left, middle }] as [string, Choice])
		)

	return [false, true].map(value => [String(value), { left: value }])
}

function expected(name: string, args: Input) {
	if (name === 'logical_and/basic' && !args.left) return { value: false }
	if (name === 'logical_or/basic' && args.left) return { value: true }
	if (name === 'logical_and/nested_or') {
		if (!args.left) return { value: false }
		if (args.middle) return { value: true }
	}

	if (name === 'logical_or/nested_and') {
		if (args.left) return { value: true }
		if (!args.middle) return { value: false }
	}

	if (name === 'conditional/yes' && !args.choose) return { value: args.fallback }
	if (name === 'conditional/no' && args.choose) return { value: args.fallback }
	if (name === 'coalesce/optional' && args.value !== null) return { value: args.value }
	if (args.index >= BigInt(args.items.length)) return { error: 'IndexOutOfBounds' }

	const item = args.items[Number(args.index)]

	return { value: name.startsWith('logical') ? item > 0n : item }
}

function cases(name: string) {
	const arrays = {
		empty: [],
		zero: [0n],
		one: [1n],
		maximum: [maximum],
		zero_one: [0n, 1n],
		one_zero: [1n, 0n],
		maximum_zero: [maximum, 0n]
	}
	const rows = []

	for (const [array_name, items] of Object.entries(arrays)) {
		const indices = new Set([0n, BigInt(Math.max(0, items.length - 1)), BigInt(items.length), maximum])

		for (const index of indices) {
			for (const [label, fields] of choices(name)) {
				const input = { ...fields, items, index }
				rows.push({
					id: `language/expressions/${name}/${label}/${array_name}/index_${index}`,
					input,
					expected: expected(name, input)
				})
			}
		}
	}

	return rows
}

function nameCases() {
	const expressions: Record<string, string> = {}

	for (const [name, operator] of [
		['logical_and', '&&'],
		['logical_or', '||']
	]) {
		for (const value of ['false', 'true']) {
			expressions[`${name}/left/${value}`] = `missing ${operator} ${value}`
			expressions[`${name}/right/${value}`] = `${value} ${operator} missing`
		}
	}

	for (const value of ['false', 'true']) {
		expressions[`conditional/condition/${value}`] = `missing ? ${value} : ${value === 'false'}`
		expressions[`conditional/yes/${value}`] = `${value} ? missing : false`
		expressions[`conditional/no/${value}`] = `${value} ? true : missing`
	}

	const rows = []

	for (const [name, expression] of Object.entries(expressions)) {
		for (const declared of [false, true]) {
			const binding = declared ? '  const missing = in\n\n' : ''
			const source =
				'export type Input = bool\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n' +
				binding +
				`  return ${expression}
}
`
			const start = source.indexOf('missing')
			rows.push({
				id: `language/expressions/static_names/${name}/${declared ? 'declared' : 'unbound'}`,
				source,
				phase: 'analyze',
				diagnostic: declared ? null : 'name',
				...(!declared ? { span: [start, start + 'missing'.length] } : {})
			})
		}
	}

	return rows
}

writeCatalog('tests/language/expressions/static_names/cases.jsonl', nameCases())

for (const [name, fields, output, expression] of suites) {
	const base = 'tests/language/expressions/' + name

	writeCatalog(base + '.jsonl', cases(name))
	writeOutput(
		base + '.zx',
		`export type Input = { ${fields} }

export type Output = ${output}

export default function (in: Input): Output {
  return ${expression}
}
`
	)
}
