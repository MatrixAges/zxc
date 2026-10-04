type Case = { name: string; program: 'u64' | 'i64'; input: string } & ({ expected: string; error?: never } | { error: string; expected?: never })

const cases: Array<Case> = []
const values = {
	u64: ['0', '1', '9007199254740991', '9007199254740992', '9007199254740993', '9223372036854775808', '18446744073709551614', '18446744073709551615'],
	i64: ['-9223372036854775808', '-9223372036854775807', '-9007199254740993', '-1', '0', '9007199254740993', '9223372036854775806', '9223372036854775807'],
}
const outside = {
	u64: ['-1', '18446744073709551616'],
	i64: ['-9223372036854775809', '9223372036854775808'],
}

for (const program of ['u64', 'i64'] as const) {
	for (const value of values[program]) {
		for (const input of [value, JSON.stringify(value), value + '.0', value + 'e0']) {
			cases.push({ name: `${program} accepts ${input}`, program, input, expected: value })
		}
	}

	for (const value of outside[program]) {
		for (const input of [value, JSON.stringify(value), value + '.0', value + 'e0']) {
			cases.push({ name: `${program} rejects overflow ${input}`, program, input, error: 'Overflow' })
		}
	}

	for (const value of ['1.5', '-1.5']) {
		for (const input of [value, JSON.stringify(value)]) {
			cases.push({ name: `${program} rejects fraction ${input}`, program, input, error: 'InvalidNumber' })
		}
	}

	for (const input of ['null', 'true', '{}', '[]']) {
		cases.push({ name: `${program} rejects token ${input}`, program, input, error: 'UnexpectedToken' })
	}
}

export default cases
