import { writeCatalog, writeOutput } from './shared/catalog.ts'

const case_body = '    case 1:\n      const f = 11\n\n      return f'
const default_body = '    default:\n      const f = 22\n\n      return f'
const shapes = [
	{ name: 'case_default', body: `${case_body}\n${default_body}`, valid: true },
	{ name: 'default_case', body: `${default_body}\n${case_body}`, valid: true },
	{ name: 'duplicate_case', body: `    case 1:\n      const f = 11\n      const f = 12\n\n      return f\n${default_body}`, valid: false },
	{ name: 'duplicate_default', body: `${case_body}\n    default:\n      const f = 21\n      const f = 22\n\n      return f`, valid: false },
]
const frontend = shapes.map(shape => {
	const source = `export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  switch (in) {\n${shape.body}\n  }\n}\n`
	const second = shape.name === 'duplicate_case' ? 'const f = 12' : 'const f = 22'
	const start = source.indexOf(second) + 6

	if (shape.valid) {
		const path = `tests/language/statements/switch/scope/${shape.name}`

		writeOutput(`${path}.zx`, source)
		writeCatalog(`${path}.jsonl`, [0, 1].map(input => ({ id: `language/statements/switch/scope/${shape.name}/${input}`, input, expected: { value: input === 1 ? 11 : 22 } })))
	}

	return { id: `language/statements/switch_redeclarations/${shape.name}`, source, phase: 'analyze', diagnostic: shape.valid ? null : 'name', ...shape.valid ? {} : { span: [start, start + 1] } }
})

writeCatalog('tests/language/statements/switch_redeclarations/cases.jsonl', frontend)
