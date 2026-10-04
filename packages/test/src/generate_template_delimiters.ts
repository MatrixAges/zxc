import { writeCatalog, writeOutput } from './shared/catalog.ts'

const shapes = [
	{ name: 'quoted_close', expression: '`L${"}"}R`', inputs: [0], expected: 'L}R' },
	{ name: 'quoted_open', expression: '`L${"{"}R`', inputs: [0], expected: 'L{R' },
	{ name: 'escaped_quote', expression: '`L${"\\\"}"}R`', inputs: [0], expected: 'L"}R' },
	{ name: 'object_field', expression: '`L${({ value: "}" }).value}R`', inputs: [0], expected: 'L}R' },
	{ name: 'block_comment', expression: '`L${/* } ` ${ */ in.value}R`', inputs: [-1, 2] },
	{ name: 'nested_comment', expression: '`L${`N${/* } ` */ in.value}M`}R`', inputs: [-1, 2] },
	{ name: 'line_comment', expression: '`L${// } ` ${\n in.value}R`', inputs: [-1, 2] },
]
const path = 'tests/language/expressions/template_delimiters/cases'
const branches = shapes.map((shape, index) => `    case ${index}:\n      return ${shape.expression}`).join('\n')
const runtime = shapes.flatMap((shape, kind) => shape.inputs.map(value => ({
	id: `language/expressions/template_delimiters/${shape.name}/${value}`,
	input: { kind, value },
	expected: { value: shape.expected ?? (shape.name === 'nested_comment' ? 'LN' + String(value) + 'MR' : 'L' + String(value) + 'R') },
})))

writeOutput(`${path}.zx`, `export type Input = { kind: u64, value: i64 }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in.kind) {\n${branches}\n    default:\n      return ""\n  }\n}\n`)
writeCatalog(`${path}.jsonl`, runtime)
