import { writeCatalog } from './shared/catalog.ts'

const rows = []
const contents = { equal: [0, 0, 0], left_equals_right: [42, 42, 1], distinct: [0, 42, 1] }

for (const [name, values] of Object.entries(contents)) {
	for (const has_left of [false, true]) {
		for (const has_right of [false, true]) {
			const left = has_left ? { value: values[0] } : null
			const right = has_right ? { value: values[1] } : null
			const fallback = { value: values[2] }
			const value = has_left ? left! : has_right ? right! : fallback

			rows.push({ id: `language/expressions/coalesce/identity/${name}/left_${has_left}/right_${has_right}`, input: { left, right, fallback }, expected: { value } })
		}
	}
}

for (const operation of ['coalesce', 'match']) {
	writeCatalog(`tests/language/expressions/${operation}/identity/object.jsonl`, rows.map(row => ({ ...row, id: row.id.replace('/coalesce/', `/${operation}/`) })))
}
