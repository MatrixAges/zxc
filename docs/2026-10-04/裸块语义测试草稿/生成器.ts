import { writeCatalog } from './shared/catalog.ts'

const shapes = [
	{ name: 'empty', body: '  {}', marker: '  {' },
	{ name: 'binding', body: '  {\n    const x = 1\n  }', marker: '  {' },
	{ name: 'return', body: '  {\n    return 1\n  }', marker: '  {' },
	{ name: 'inside_if', body: '  if (in) {\n    {\n      return 1\n    }\n  }', marker: '    {' },
]
const frontend = shapes.map(shape => {
	const header = 'export type Input = bool\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n'
	const source = `${header}${shape.body}\n\n  return 0\n}\n`
	const start = header.length + shape.body.indexOf(shape.marker) + shape.marker.length - 1

	return { id: `language/statements/bare_blocks/${shape.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] }
})

writeCatalog('tests/language/statements/bare_blocks/cases.jsonl', frontend)
