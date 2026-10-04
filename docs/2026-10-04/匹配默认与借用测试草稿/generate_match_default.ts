import { writeCatalog } from './shared/catalog.ts'

const rows = []

for (const fail of [false, true]) {
	for (const length of [0, 1, 2]) {
		for (const index of [0, 1]) {
			const items = [42, 84].slice(0, length)
			const error = fail ? 'LeftFailure' : index >= length ? 'IndexOutOfBounds' : null

			rows.push({ id: `match_order/default_only/fail_${fail}/length_${length}/index_${index}`, input: { fail, items, index }, expected: { trace: 'L', ...(error ? { error } : { value: items[index] }) } })
		}
	}
}

writeCatalog('tests/runtime/evaluation_order/match_default.jsonl', rows)
