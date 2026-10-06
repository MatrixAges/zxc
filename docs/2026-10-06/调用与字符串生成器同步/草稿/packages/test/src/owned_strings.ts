import type { Json } from './shared/json.ts'
import assert from 'node:assert/strict'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Row = { id: string; input: Record<string, Array<string>>; expected: { value: Json } }

function values(field: string, length: number): string {
	return '[' + Array.from({ length }, (_, index) => `fromLiteral(in.${field}[${index}])`).join(', ') + ']'
}

function literal(value: string): string {
	if (/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/u.test(value))
		return '`' + value.replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('${', '\\${') + '`'

	return JSON.stringify(value)
}

export default function writeOwnedStrings(args: { name: string; rows: Array<Row> }): void {
	const { name, rows } = args
	const alphabet = [...new Set(rows.flatMap(row => Object.values(row.input).flat()))]
	const codes = new Map(alphabet.map((value, index) => [value, index]))
	const groups = new Map<string, Array<Row>>()

	for (const row of rows) {
		const key = `${row.input.items.length}_${row.input.other?.length ?? 0}`
		const group = groups.get(key) ?? []

		group.push(row)
		groups.set(key, group)
	}

	const literal_path = `built_ins/string/fixtures/${name}_literal.zx`
	const literal_source = `export type Input = u64

export type Output = string

export default function (in: Input): Output {
  const values: string[] = [${alphabet.map(literal).join(', ')}]

  return values[in]
}
`

	writeOutput('tests/' + literal_path, literal_source)

	for (const [key, group] of groups) {
		const first = group[0].input
		const constructed = values('items', first.items.length)
		const other = first.other ? values('other', first.other.length) : null
		const fields = other ? 'items: u64[], other: u64[],' : 'items: u64[],'
		const body = other
			? `  const other: string[] = ${other}

  const [joined, _] = owned.concat(other)
  const [result, _] = joined.reverse()
`
			: '\n  const [result, _] = owned.sort()\n'
		const source = `import fromLiteral from "../../../fixtures/${name}_literal"

export type Input = { ${fields} }

export type Output = string[]

export default function (in: Input): Output {
  const owned: string[] = ${constructed}
${body.trimEnd()}

  return result
}
`
		const encoded = group.map(row => {
			const input = Object.fromEntries(
				Object.entries(row.input).map(([field, strings]) => {
					const indices = strings.map(value => codes.get(value)!)

					assert.deepEqual(
						indices.map(index => alphabet[index]),
						strings
					)

					return [field, indices]
				})
			)

			return { id: row.id, input, value_input: row.input, expected: row.expected }
		})
		const base = `tests/built_ins/string/${name}/owned/${key}/cases`

		writeCatalog(base + '.jsonl', encoded)
		writeOutput(base + '.zx', source)
	}
}
