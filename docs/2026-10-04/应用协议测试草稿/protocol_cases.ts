type Case = { name: string; program: 'no_input' | 'void_output' | 'fallible'; argv: Array<string> } & ({ expected: string; error?: never } | { error: string; expected?: never })

const cases: Array<Case> = [
	{ name: 'void input accepts no arguments', program: 'no_input', argv: [], expected: '7\n' },
	{ name: 'void output true branch', program: 'void_output', argv: ['true'], expected: 'null\n' },
	{ name: 'void output false branch', program: 'void_output', argv: ['false'], expected: 'null\n' },
	{ name: 'ordinary input requires an argument', program: 'void_output', argv: [], error: 'ExpectedJsonInput' },
	{ name: 'ordinary input rejects two arguments', program: 'void_output', argv: ['true', 'false'], error: 'ExpectedJsonInput' },
	{ name: 'argument count checked before malformed JSON', program: 'void_output', argv: ['{', '{'], error: 'ExpectedJsonInput' },
	{ name: 'whitespace around JSON is accepted', program: 'void_output', argv: [' \t\r\ntrue \n'], expected: 'null\n' },
	{ name: 'empty JSON is rejected', program: 'void_output', argv: [''], error: 'UnexpectedEndOfInput' },
	{ name: 'trailing JSON value is rejected', program: 'void_output', argv: ['true false'], error: 'SyntaxError' },
	{ name: 'wrong case JSON literal is rejected', program: 'void_output', argv: ['True'], error: 'SyntaxError' },
	{ name: 'unterminated JSON string is rejected', program: 'void_output', argv: ['"'], error: 'UnexpectedEndOfInput' },
	{ name: 'index first element', program: 'fallible', argv: ['{"items":[7,9],"index":0}'], expected: '7\n' },
	{ name: 'index last element', program: 'fallible', argv: ['{"items":[7,9],"index":1}'], expected: '9\n' },
	{ name: 'empty list execution failure has no output', program: 'fallible', argv: ['{"items":[],"index":0}'], error: 'IndexOutOfBounds' },
	{ name: 'index at length execution failure has no output', program: 'fallible', argv: ['{"items":[7,9],"index":2}'], error: 'IndexOutOfBounds' },
	{ name: 'negative index fails before execution', program: 'fallible', argv: ['{"items":[7],"index":-1}'], error: 'Overflow' },
	{ name: 'missing index fails before execution', program: 'fallible', argv: ['{"items":[7]}'], error: 'MissingField' },
	{ name: 'object input requires an argument', program: 'fallible', argv: [], error: 'ExpectedJsonInput' },
]

for (const argv of [['null'], ['1'], [''], ['--help'], ['1', '2']]) {
	cases.push({ name: `void input rejects ${JSON.stringify(argv)}`, program: 'no_input', argv, error: 'ExpectedNoArguments' })
}

for (const input of ['null', '0', '"true"', '{}', '[]']) {
	cases.push({ name: `bool input rejects ${input}`, program: 'void_output', argv: [input], error: 'UnexpectedToken' })
}

export default cases
