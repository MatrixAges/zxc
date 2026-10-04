import type { Json } from './shared/json.ts'
import { writeCatalog } from './shared/catalog.ts'

type Row = { id: string; input: Json; expected: { trace: string; value?: number; error?: string } }
const condition_rows: Array<Row> = []
const value_rows: Array<Row> = []
const results = [11, 22, 33]

for (const left of [false, true]) {
	for (const right of [false, true]) {
		for (const fail_left of [false, true]) {
			for (const fail_right of [false, true]) {
				for (const length of [0, 1, 2, 3]) {
					const trace = fail_left || left ? 'L' : 'LR'
					const selected = left ? 0 : right ? 1 : 2
					const error = fail_left ? 'LeftFailure' : !left && fail_right ? 'RightFailure' : selected >= length ? 'IndexOutOfBounds' : null
					const input = { left: left ? 2 : 0, right: right ? 3 : 0, fail_left, fail_right, items: results.slice(0, length) }

					condition_rows.push({ id: `match_order/condition/left_${left}/right_${right}/fail_left_${fail_left}/fail_right_${fail_right}/length_${length}`, input, expected: { trace, ...(error ? { error } : { value: results[selected] }) } })
				}
			}
		}
	}
}

for (const [name, scale, selected] of [['first', 1.5, 0], ['second', 1, 1], ['fallback', 2, 2]] as const) {
	for (const fail_left of [false, true]) {
		for (const fail_right of [false, true]) {
			for (const length of [0, 1, 2, 3]) {
				const trace = fail_left ? 'L' : fail_right || selected === 0 ? 'LR' : 'LRL'
				const error = fail_left ? 'LeftFailure' : fail_right ? 'RightFailure' : selected >= length ? 'IndexOutOfBounds' : null
				const input = { scale, fail_left, fail_right, items: results.slice(0, length) }

				value_rows.push({ id: `match_order/value/${name}/fail_left_${fail_left}/fail_right_${fail_right}/length_${length}`, input, expected: { trace, ...(error ? { error } : { value: results[selected] }) } })
			}
		}
	}
}

writeCatalog('tests/runtime/evaluation_order/match_condition.jsonl', condition_rows)
writeCatalog('tests/runtime/evaluation_order/match_value.jsonl', value_rows)
