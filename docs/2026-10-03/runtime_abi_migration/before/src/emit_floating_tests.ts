import { writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import { quote } from './zig_string.ts'

type Case = {
	id: string
	input?: string
	left?: string
	right?: string
	third?: string
	expected: string | Record<string, boolean>
}

const [source, output] = process.argv.slice(2)
const declarations = ['const check = @import("support").check;\n']
const seen = new Set<string>()
const fields = ['less', 'less_equal', 'greater', 'greater_equal', 'equal', 'not_equal'].sort()

for (const row of readRows<Case>(source)) {
	if (seen.has(row.id)) throw new Error(`duplicate case ID: ${row.id}`)
	seen.add(row.id)

	const value = row.expected
	let expected: string

	if (typeof value === 'object') {
		if (
			Object.keys(value).sort().join(',') !== fields.join(',') ||
			!Object.values(value).every(item => typeof item === 'boolean')
		)
			throw new Error(`invalid comparison expectation: ${row.id}`)
		expected =
			'.{' +
			Object.entries(value)
				.map(([name, item]) => `.${name} = ${item}`)
				.join(', ') +
			'}'
	} else expected = value === 'nan' ? 'null' : '0x' + value

	if ('input' in row === ('left' in row || 'right' in row))
		throw new Error(`invalid floating operand shape: ${row.id}`)
	if (!('input' in row) && (!row.left || !row.right)) throw new Error(`missing binary operand: ${row.id}`)
	if ('third' in row && ('input' in row || !row.third)) throw new Error(`invalid third operand: ${row.id}`)

	const operands =
		'input' in row ? `0x${row.input}` : `0x${row.left}, 0x${row.right}` + ('third' in row ? `, 0x${row.third}` : '')

	declarations.push(`test ${quote(row.id)} {\n    try check(@import("program"), ${operands}, ${expected});\n}\n`)
}

if (!seen.size) throw new Error('empty case catalog')

writeFileSync(output, declarations.join('\n'))
