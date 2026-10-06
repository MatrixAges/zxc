import type { Json } from '../shared/json.ts'
import { writeCatalog, writeOutput } from '../shared/catalog.ts'

type Case = { name: string; input: Json; value: Json }

export default function writeSuite(args: {
	operation: string
	input: string
	output: string
	rows: Array<Case>
}): void {
	const { operation, input, output, rows } = args
	const base = `standard/url/search_params/${operation.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`)}/cases`

	writeCatalog(
		`tests/${base}.jsonl`,
		rows.map(row => ({ id: `${base}/${row.name}`, input: row.input, expected: { value: row.value } }))
	)
	writeOutput(
		`tests/${base}.zx`,
		`import params from "std:url/search_params"

import type { Entry, Lookup, Match, Update } from "std:url/search_params"

export type Input = ${input}

export type Output = ${output}

export default function (in: Input): Output {
  return params.${operation}(in)
}
`
	)
}
