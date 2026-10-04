import { writeCatalog } from './shared/catalog.ts'

const shapes = [
	{ name: 'var_case', label: 'case 0', declaration: 'var x = 1', token: 'var' },
	{ name: 'var_default', label: 'default', declaration: 'var x = 1', token: 'var' },
	{ name: 'class_default', label: 'default', declaration: 'class x {}', token: 'class' },
	{ name: 'generator_default', label: 'default', declaration: 'function * x() {}', token: 'function' },
	{ name: 'async_function_default', label: 'default', declaration: 'async function x() {}', token: 'async' },
	{ name: 'async_generator_default', label: 'default', declaration: 'async function * x() {}', token: 'async' },
]
const frontend = shapes.map(shape => {
	const source = `export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  switch (in) {\n    ${shape.label}:\n      ${shape.declaration}\n  }\n\n  return 0\n}\n`
	const start = source.indexOf(shape.declaration)

	return { id: `language/statements/switch_declarations/${shape.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + shape.token.length] }
})

writeCatalog('tests/language/statements/switch_declarations/cases.jsonl', frontend)
