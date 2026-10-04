import type { Json } from './shared/json.ts'
import { writeCatalog } from './shared/catalog.ts'

const rows: Array<{ id: string; input: Json; expected: { trace: string; value?: boolean; error?: string } }> = []

for (const is_and of [false, true]) {
	for (const reverse of [false, true]) {
		for (const left of [false, true]) {
			for (const right of [false, true]) {
				for (const fail_left of [false, true]) {
					for (const fail_right of [false, true]) {
						const first = reverse ? right : left
						const first_fails = reverse ? fail_right : fail_left
						const second_fails = reverse ? fail_left : fail_right
						const first_label = reverse ? 'R' : 'L'
						let trace = first_label
						let expected: { value?: boolean; error?: string } = { value: first }

						if (first_fails) expected = { error: `${reverse ? 'Right' : 'Left'}Failure` }
						else if (first === is_and) {
							trace += reverse ? 'L' : 'R'
							expected = second_fails ? { error: `${reverse ? 'Left' : 'Right'}Failure` } : { value: reverse ? left : right }
						}

						const id = `logical_order/${is_and ? 'and' : 'or'}/${reverse ? 'RL' : 'LR'}/left_${left}/right_${right}/fail_left_${fail_left}/fail_right_${fail_right}`
						const input = { is_and, reverse, left: left ? 2 : 0, right: right ? 3 : 0, fail_left, fail_right }

						rows.push({ id, input, expected: { ...expected, trace } })
					}
				}
			}
		}
	}
}

writeCatalog('tests/runtime/evaluation_order/logical.jsonl', rows)
