import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; adapted: boolean; reason: string }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/call_arguments.jsonl'))
const base = 'language/expressions/call_arguments'
const expressions = [
	'f_arg(1,,2)',
	'f_arg(,1)',
	'f_arg(1,,)',
	'f_arg(,,)',
	'f_arg()',
	'f_arg(1)',
	'f_arg(1,)',
	'f_arg(1,2,)'
]
const frontend = expressions.map((expression, index) => {
	const source = `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return ${expression}
}
`
	const offset = expression.includes('(,') ? expression.indexOf('(,') + 1 : expression.indexOf(',,') + 1
	const start = source.indexOf(expression) + offset

	return {
		id: `${base}/syntax/${index}`,
		source,
		phase: 'parse',
		diagnostic: index < 4 ? 'syntax' : null,
		...(index < 4 ? { span: [start, start + 1] } : {})
	}
})

writeCatalog(`tests/${base}/syntax.jsonl`, frontend)

const calls = [
	'increment(in.value,)',
	'increment(in.value,\n      )',
	'increment(in.value, /* tail */)',
	'increment(in.value /* value */, )'
]
const branches = calls
	.map(
		(call, index) => `    case ${index}:
      return ${call}`
	)
	.join('\n')

writeOutput(
	`tests/${base}/increment.zx`,
	'export type Input = i64\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  return in + 1\n}\n'
)
writeOutput(
	`tests/${base}/cases.zx`,
	`import increment from "./increment"

export type Input = { kind: u64, value: i64 }

export type Output = i64

export default function (in: Input): Output {
  switch (in.kind) {
${branches}
    default:
      return increment(in.value)
  }
}
`
)
writeCatalog(
	`tests/${base}/cases.jsonl`,
	calls.flatMap((_, kind) =>
		[-7, 9].map(value => ({
			id: `${base}/runtime/${kind}/${value}`,
			input: { kind, value },
			expected: { value: value + 1 }
		}))
	)
)
writeCatalog(
	'upstream/reviews/language/expressions/call_arguments.jsonl',
	samples.map(sample => ({
		path: sample.path,
		sha256: sample.sha256,
		reason: sample.reason,
		status: sample.adapted ? 'adapted' : 'excluded',
		contract: 'packages/compiler/src/zx/frontend/parser_expressions.zig',
		cases: sample.adapted ? [frontend[0].id] : [],
		...(sample.adapted
			? { diagnostics: [{ case: frontend[0].id, phase: 'parse', code: 'syntax', span: frontend[0].span }] }
			: {})
	}))
)
