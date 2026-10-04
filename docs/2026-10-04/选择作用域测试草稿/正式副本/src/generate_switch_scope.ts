import { writeCatalog, writeOutput } from './shared/catalog.ts'

const header = 'export type Input = bool\n\nexport type Output = u64\n\n'
const bodies = [
	{ name: 'sibling_forward', body: '  switch (in) {\n    case true:\n      const local = 1\n\n      return local\n    case false:\n      return local\n  }', valid: false },
	{ name: 'sibling_reverse', body: '  switch (in) {\n    case true:\n      return local\n    case false:\n      const local = 1\n\n      return local\n  }', valid: false },
	{ name: 'after_switch', body: '  switch (in) {\n    case true:\n      const local = 1\n    case false:\n      const local = 2\n  }\n\n  return local', valid: false },
	{ name: 'default_sibling', body: '  switch (in) {\n    case true:\n      const local = 1\n\n      return local\n    default:\n      return local\n  }', valid: false },
	{ name: 'separate_bindings', body: '  switch (in) {\n    case true:\n      const local = 1\n\n      return local\n    case false:\n      const local = 2\n\n      return local\n  }', valid: true },
	{ name: 'outer_binding', body: '  const local = 3\n\n  switch (in) {\n    case true:\n      return local\n    case false:\n      return local + 1\n  }', valid: true },
]
const frontend = []

for (const shape of bodies) {
	const source = `${header}export default function (in: Input): Output {\n${shape.body}\n}\n`
	const start = shape.name === 'sibling_reverse' ? source.indexOf('local') : source.lastIndexOf('local')
	frontend.push({ id: `language/statements/switch_scope/${shape.name}`, source, phase: 'analyze', diagnostic: shape.valid ? null : 'name', ...shape.valid ? {} : { span: [start, start + 5] } })

	if (shape.valid) {
		const path = `tests/language/statements/switch/scope/${shape.name}`
		writeOutput(`${path}.zx`, source)
		writeCatalog(`${path}.jsonl`, [false, true].map(input => ({ id: `language/statements/switch/scope/${shape.name}/${input}`, input, expected: { value: shape.name === 'separate_bindings' ? input ? 1 : 2 : input ? 3 : 4 } })))
	}
}

writeCatalog('tests/language/statements/switch_scope/cases.jsonl', frontend)
