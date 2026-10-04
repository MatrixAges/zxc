import type { Json } from './shared/json.ts'
import { writeCatalog } from './shared/catalog.ts'

const rows: Array<{ id: string; input: Json; expected: { trace: string; value?: boolean; error?: string } }> = []

for (const reverse of [false, true]) {
	for (const left of [null, false, true]) {
		for (const right of [null, false, true]) {
			for (const fallback of [false, true]) {
				for (const fail_left of [false, true]) {
					for (const fail_right of [false, true]) {
						const first = reverse ? right : left
						const second = reverse ? left : right
						const first_fails = reverse ? fail_right : fail_left
						const second_fails = reverse ? fail_left : fail_right
						let trace = reverse ? 'R' : 'L'
						let expected: { value?: boolean; error?: string }

						if (first_fails) expected = { error: `${reverse ? 'Right' : 'Left'}Failure` }
						else if (first !== null) expected = { value: first }
						else {
							trace += reverse ? 'L' : 'R'
							expected = second_fails ? { error: `${reverse ? 'Left' : 'Right'}Failure` } : { value: second === null ? fallback : second }
						}

						const id = `coalesce_order/${reverse ? 'RL' : 'LR'}/left_${left}/right_${right}/fallback_${fallback}/fail_left_${fail_left}/fail_right_${fail_right}`
						const input = { reverse, left: { fail: fail_left, value: left }, right: { fail: fail_right, value: right }, fallback }

						rows.push({ id, input, expected: { ...expected, trace } })
					}
				}
			}
		}
	}
}

writeCatalog('tests/runtime/evaluation_order/coalesce.jsonl', rows)

const input = '{ left: bool?\n right: bool?\n fallback: bool }'
const expressions = {
	unparenthesized_chain: 'in.left ?? in.right ?? in.fallback',
	optional_fallback: 'in.left ?? in.right',
	nonoptional_head: 'in.fallback ?? true',
}

writeCatalog('tests/language/types/coalesce_chain/cases.jsonl', Object.entries(expressions).map(([name, expression]) => ({
	id: `language/types/coalesce_chain/${name}`,
	source: `export type Input = ${input}

export type Output = bool

export default function (in: Input): Output {
  return ${expression}
}
`,
	phase: 'analyze',
	diagnostic: 'type_mismatch',
})))
