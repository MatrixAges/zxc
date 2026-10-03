import { writeFileSync } from 'node:fs'
import { readRows } from './shared/json.ts'
import { quote } from './zig_string.ts'

type PathCase = {
	id: string
	paths: Array<string>
	owner: number | null
	kind: string
	reference: string | null
	expected: { paths: Array<string> } | { failure: { owner: number; reference: boolean; message: string } }
}
type GraphCase = {
	id: string
	size: number
	shape: string
	edges: Array<number>
	cyclic_edges: Array<number>
	allocation_failures?: boolean
	bounded_stack?: boolean
}

function pathCall(row: PathCase): string {
	const paths = '&.{' + row.paths.map(quote).join(', ') + '}'
	const owner = row.owner === null ? 'null' : String(row.owner)
	const reference = row.reference === null ? 'null' : quote(row.reference)

	if (!['call', 'import'].includes(row.kind)) throw new Error(`invalid path reference kind: ${row.id}`)

	let expected: string

	if ('paths' in row.expected) expected = '.{ .paths = &.{' + row.expected.paths.map(quote).join(', ') + '} }'
	else {
		const failure = row.expected.failure
		expected = `.{ .failure = .{ .owner = ${failure.owner}, .reference = ${failure.reference}, .message = ${quote(failure.message)} } }`
	}

	return `support.checkPaths(${paths}, ${owner}, .${row.kind}, ${reference}, ${expected})`
}

const paths = process.argv.slice(2)
const output = paths.pop()!
const declarations = ['const support = @import("support");\n']
const seen = new Set<string>()

for (const source of paths) {
	for (const row of readRows<PathCase | GraphCase>(source)) {
		if (seen.has(row.id)) throw new Error(`duplicate case ID: ${row.id}`)
		seen.add(row.id)

		if ('paths' in row) {
			declarations.push(`test ${quote(row.id)} {\n    try ${pathCall(row)};\n}\n`)
			continue
		}

		if (row.allocation_failures && row.bounded_stack) throw new Error(`multiple graph execution modes: ${row.id}`)
		if (!['call', 'import', 'case', 'parallel_task'].includes(row.shape))
			throw new Error(`unknown graph shape: ${row.shape}`)

		const check = row.allocation_failures
			? 'checkAllocationFailures'
			: row.bounded_stack
				? 'checkBoundedStack'
				: 'check'
		declarations.push(
			`test ${quote(row.id)} {\n    try support.${check}(${row.size}, .${row.shape}, &.{${row.edges.join(', ')}}, &.{${row.cyclic_edges.join(', ')}});\n}\n`
		)
	}
}

if (!seen.size) throw new Error('empty graph catalog')

writeFileSync(output, declarations.join('\n'))
