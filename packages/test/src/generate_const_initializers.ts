import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

const base = 'language/statements/const_initializers'
const shapes = [
	{ name: 'missing_plain', declaration: 'const x', valid: false },
	{ name: 'missing_typed', declaration: 'const x: Input', valid: false },
	{ name: 'missing_comment', declaration: 'const x /* initializer absent */', valid: false },
	{ name: 'valid_plain', declaration: 'const x = in', valid: true },
	{ name: 'valid_typed', declaration: 'const x: Input = in', valid: true },
	{ name: 'valid_comment', declaration: 'const x /* initializer present */ = in', valid: true }
]

writeCatalog(
	`tests/${base}/cases.jsonl`,
	shapes.map(shape => {
		const source = `export type Input = i64\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  ${shape.declaration}\n\n  return x\n}\n`
		const start = source.indexOf('return x')

		return {
			id: `${base}/${shape.name}`,
			source,
			phase: shape.valid ? 'analyze' : 'parse',
			diagnostic: shape.valid ? null : 'syntax',
			...(shape.valid ? {} : { span: [start, start + 6] })
		}
	})
)

writeCatalog(
	'upstream/reviews/language/statements/const_initializers.jsonl',
	readRows(resolve(package_dir, 'src/data/const_initializers.jsonl'))
)
