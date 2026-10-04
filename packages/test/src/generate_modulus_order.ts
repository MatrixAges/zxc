import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const rows: Array<{ id: string; input: Json; expected: { trace: string; value?: number; error?: string } }> = []

for (const binding of [false, true]) {
	for (const reverse of [false, true]) {
		for (const fail_left of [false, true]) {
			for (const fail_right of [false, true]) {
				const first_fails = reverse ? fail_right : fail_left
				const second_fails = reverse ? fail_left : fail_right
				const expected = first_fails
					? { error: reverse ? 'RightFailure' : 'LeftFailure' }
					: second_fails
						? { error: reverse ? 'LeftFailure' : 'RightFailure' }
						: { value: reverse ? 3 % 2 : 2 % 3 }
				const first = reverse ? 'R' : 'L'
				const second = reverse ? 'L' : 'R'

				rows.push({
					id: `modulus_order/${binding ? 'binding' : 'direct'}/${reverse ? 'RL' : 'LR'}/fail_left_${fail_left}/fail_right_${fail_right}`,
					input: { binding, reverse, fail_left, fail_right },
					expected: { ...expected, trace: first_fails ? first : first + second },
				})
			}
		}
	}
}

writeCatalog('tests/runtime/evaluation_order/modulus.jsonl', rows)
writeOutput('tests/runtime/evaluation_order/modulus.zx', `import readLeft from "lib:probe-left"
import readRight from "lib:probe-right"

export type Input = { binding: bool
 reverse: bool
 fail_left: bool
 fail_right: bool }

export type Output = f64

export default function (in: Input): Output {
  if (in.binding) {
    if (in.reverse) {
      const right = readRight(in.fail_right)
      const left = readLeft(in.fail_left)

      return right % left
    }

    const left = readLeft(in.fail_left)
    const right = readRight(in.fail_right)

    return left % right
  }

  return in.reverse ? readRight(in.fail_right) % readLeft(in.fail_left) : readLeft(in.fail_left) % readRight(in.fail_right)
}
`)

const variants = [
	{ name: 'left_assignment', declaration: '  const x: f64 = 0\n\n', expression: '(x = 1) % x' },
	{ name: 'right_assignment', declaration: '  const x: f64 = 1\n\n', expression: 'x % (x = 2)' },
	{ name: 'unbound_then_assignment', declaration: '', expression: 'x % (x = 1)' },
	{ name: 'implicit_global', declaration: '', expression: '(y = 1) % y' },
]
const frontend = variants.map(variant => {
	const source = `export type Input = void

export type Output = f64

export default function (in: Input): Output {
${variant.declaration}  return ${variant.expression}
}
`
	const start = source.indexOf(' = ', source.indexOf('return ')) + 1

	return { id: `language/types/modulus_assignment/${variant.name}`, source, phase: 'parse', diagnostic: 'syntax', span: [start, start + 1] }
})

writeCatalog('tests/language/types/modulus_assignment/cases.jsonl', frontend)
