import { writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import { quote, quoteBytes } from './zig_string.ts'

type UnicodeCase = {
	id: string
	unicode_comments: { mode: string; first: number; last: number }
	expected: { invalid_utf8: string; terminated: string; ignored: string; terminators: Array<number> }
}

type Case = {
	id: string
	phase: string
	diagnostic: string | null
	span?: [number, number]
	source?: string
	source_hex?: string
}

const paths = process.argv.slice(2)
const output = paths.pop()!
const declarations = ['const check = @import("support").check;\n']
const seen = new Set<string>()
const codes = [
	null,
	'lexical',
	'syntax',
	'type_mismatch',
	'name',
	'naming',
	'ownership',
	'return_path',
	'unsupported',
	'contract'
]

for (const source of paths) {
	for (const row of readRows<Case | UnicodeCase>(source)) {
		if (seen.has(row.id)) throw new Error(`duplicate case ID: ${row.id}`)
		seen.add(row.id)

		if ('unicode_comments' in row) {
			const { mode, first, last } = row.unicode_comments
			const expected = row.expected
			if (
				!['line', 'block'].includes(mode) ||
				'source' in row ||
				'source_hex' in row ||
				!Number.isInteger(first) ||
				!Number.isInteger(last) ||
				first < 0 ||
				first > last ||
				last > 0x10ffff
			)
				throw new Error('invalid Unicode comment range: ' + row.id)
			if (
				expected.invalid_utf8 !== 'lexical' ||
				expected.terminated !== 'contract' ||
				expected.ignored !== 'analyze' ||
				!expected.terminators.every(point => Number.isInteger(point) && point >= first && point <= last)
			)
				throw new Error('invalid Unicode comment expectations: ' + row.id)
			declarations.push(
				`test ${quote(row.id)} {\n    try @import("support").checkUnicodeComments(check, .{ .mode = .${mode}, .first = ${first}, .last = ${last}, .terminators = &.{${expected.terminators.join(', ')}} });\n}\n`
			)
			continue
		}

		if (!['parse', 'analyze', 'compile'].includes(row.phase)) throw new Error(`invalid phase: ${row.id}`)
		if (!codes.includes(row.diagnostic)) throw new Error(`invalid diagnostic: ${row.id}`)
		if ('source' in row === 'source_hex' in row)
			throw new Error(`expected exactly one source representation: ${row.id}`)
		if (row.source_hex !== undefined && !/^(?:[0-9a-fA-F]{2})*$/.test(row.source_hex))
			throw new Error(`invalid source hex: ${row.id}`)

		const diagnostic = row.diagnostic === null ? 'null' : '.' + row.diagnostic
		const span = row.span == null ? 'null' : '.{' + row.span.join(', ') + '}'
		const source_literal =
			row.source !== undefined ? quote(row.source) : quoteBytes(Buffer.from(row.source_hex!, 'hex'))
		declarations.push(
			`test ${quote(row.id)} {\n    try check(${source_literal}, .${row.phase}, ${diagnostic}, ${span});\n}\n`
		)
	}
}

if (!seen.size) throw new Error('empty case catalog')

writeFileSync(output, declarations.join('\n'))
