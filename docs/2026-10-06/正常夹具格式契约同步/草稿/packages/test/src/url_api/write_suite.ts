import type { Json } from '../shared/json.ts'
import { writeCatalog, writeOutput } from '../shared/catalog.ts'

export type Case = { name: string; input: Json; value?: Json; error?: string }

export default function writeSuite(args: {
	operation: string
	input: string
	output: string
	rows: Array<Case>
	body?: string
}): void {
	const { operation, input, output, rows, body = `return url.${operation}(in)` } = args
	const directory = operation
		.replace(/([a-z0-9])([A-Z])/g, '$1_$2')
		.replace(/([A-Z])([A-Z][a-z])/g, '$1_$2')
		.toLowerCase()
	const path = `tests/standard/url/api/${directory}/cases`

	writeCatalog(
		`${path}.jsonl`,
		rows.map(row => ({
			id: `${path.slice(6)}/${row.name}`,
			input: row.input,
			expected: row.error ? { error: row.error } : { value: row.value }
		}))
	)
	writeOutput(
		`${path}.zx`,
		`import url from "std:url"

import type { Url, Resolve, Platform } from "std:url"

export type Input = ${input}

export type Output = ${output}

export default function (in: Input): Output {
  ${body}
}
`
	)
}
