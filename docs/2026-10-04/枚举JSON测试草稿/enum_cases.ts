type Case = { name: string; program: 'scalar' | 'nested'; input: unknown } & ({ expected: unknown; error?: never } | { error: string; expected?: never })

const cases: Array<Case> = []

for (const [index, name] of ['First', 'Second', 'Third'].entries()) {
	for (const input of [name, index, String(index)]) {
		cases.push({ name: `scalar accepts ${JSON.stringify(input)}`, program: 'scalar', input, expected: name })
	}
}

cases.push({ name: 'scalar accepts null', program: 'scalar', input: null, expected: null })

for (const input of ['first', 'Missing', 3, -1, 1.5, '3', '1.0']) {
	cases.push({ name: `scalar rejects tag ${JSON.stringify(input)}`, program: 'scalar', input, error: 'InvalidEnumTag' })
}

for (const input of [true, {}, []]) {
	cases.push({ name: `scalar rejects token ${JSON.stringify(input)}`, program: 'scalar', input, error: 'UnexpectedToken' })
}

cases.push(
	{ name: 'nested null and empty list', program: 'nested', input: { value: null, values: [] }, expected: { value: null, values: [] } },
	{ name: 'nested named values', program: 'nested', input: { value: 'Second', values: ['First', 'Third'] }, expected: { value: 'Second', values: ['First', 'Third'] } },
	{ name: 'nested numeric values normalize to names', program: 'nested', input: { value: 2, values: [0, 1, 2] }, expected: { value: 'Third', values: ['First', 'Second', 'Third'] } },
	{ name: 'nested mixed encodings', program: 'nested', input: { value: '0', values: ['1', 2, 'First'] }, expected: { value: 'First', values: ['Second', 'Third', 'First'] } },
	{ name: 'nested missing list', program: 'nested', input: { value: null }, error: 'MissingField' },
	{ name: 'nested missing optional field', program: 'nested', input: { values: [] }, error: 'MissingField' },
	{ name: 'nested unknown field', program: 'nested', input: { value: null, values: [], extra: 1 }, error: 'UnknownField' },
	{ name: 'nested null list item', program: 'nested', input: { value: null, values: [null] }, error: 'UnexpectedToken' },
	{ name: 'nested unknown list tag', program: 'nested', input: { value: null, values: ['Missing'] }, error: 'InvalidEnumTag' },
	{ name: 'nested unknown optional tag', program: 'nested', input: { value: 'Missing', values: [] }, error: 'InvalidEnumTag' },
	{ name: 'nested invalid optional token', program: 'nested', input: { value: true, values: [] }, error: 'UnexpectedToken' },
	{ name: 'nested invalid list token', program: 'nested', input: { value: null, values: false }, error: 'UnexpectedToken' },
)

export default cases
