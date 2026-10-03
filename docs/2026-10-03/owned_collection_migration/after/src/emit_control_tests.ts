import type { Json } from './shared/json.ts'
import { writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import literal from './shared/zig_literal.ts'
import { quote } from './zig_string.ts'

type Case = { id: string; input: Json; expected: { error?: string; value?: Json } }

const [source, output] = process.argv.slice(2)
const declarations = ['const check = @import("support").check;\n']
const seen = new Set<string>()
const errors = new Set([
	'IndexOutOfBounds',
	'InvalidPadding',
	'InvalidCharacter',
	'InvalidHex',
	'InvalidUtf8',
	'InvalidWorkingDirectory',
	'MissingDriveDirectory',
	'InvalidTagLength',
	'OutputTooLong',
	'InvalidIterations',
	'InvalidKeyLength',
	'InvalidNonceLength',
	'AuthenticationFailed',
	'LengthMismatch'
])

for (const row of readRows<Case>(source)) {
	if (seen.has(row.id)) throw new Error(`duplicate case ID: ${row.id}`)
	seen.add(row.id)

	let expected: string

	if ('error' in row.expected) {
		if (
			typeof row.expected.error !== 'string' ||
			!errors.has(row.expected.error) ||
			Object.keys(row.expected).length !== 1
		)
			throw new Error(`unexpected error contract: ${row.id}`)
		expected = `.{ .failure = error.${row.expected.error} }`
	} else expected = `.{ .value = ${literal(row.expected.value!)} }`

	declarations.push(
		`test ${quote(row.id)} {\n    try check(@import("program"), ${literal(row.input)}, ${expected});\n}\n`
	)
}

if (!seen.size) throw new Error('empty case catalog')

writeFileSync(output, declarations.join('\n'))
