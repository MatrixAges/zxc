const items = 'items: i64[];'
const pair = items + ' other: i64[];'
const range = pair + ' start: u64; count: u64;'
const splice_output = '{ items: i64[]; removed: i64[]; }'
export const consuming = new Set([
	'push',
	'pop',
	'reverse',
	'sort',
	'concat',
	'concat_reverse',
	'concat_three',
	'splice',
	'splice_reverse'
])

function consume(call: string, result = 'next'): string {
	return `  const [next, _] = owned.${call};\n\n  return ${result};`
}

export const programs: Record<string, [string, string, string]> = {
	push: [items + ' value: i64;', 'i64[]', consume('push(in.value)')],
	pop: [
		items,
		'{ items: i64[]; value: i64?; }',
		'  const [items, value] = owned.pop();\n\n  return { items, value };'
	],
	reverse: [items, 'i64[]', consume('reverse()')],
	sort: [items, 'i64[]', consume('sort()')],
	concat: [pair, 'i64[]', consume('concat(in.other)')],
	concat_reverse: [
		pair,
		'i64[]',
		'  const [joined, _] = owned.concat(in.other);\n  const [next, _] = joined.reverse();\n\n  return next;'
	],
	concat_three: [
		pair + ' last: i64[];',
		'i64[]',
		'  const [first, _] = owned.concat(in.other);\n  const [next, _] = first.concat(in.last);\n\n  return next;'
	],
	splice: [
		range,
		splice_output,
		'  const [items, removed] = owned.splice(in.start, in.count, in.other);\n\n  return { items, removed };'
	],
	splice_reverse: [
		range,
		splice_output,
		'  const [next, deleted] = owned.splice(in.start, in.count, in.other);\n  const [items, _] = next.reverse();\n  const [removed, _] = deleted.reverse();\n\n  return { items, removed };'
	],
	map_double: [items, 'i64[]', '  return in.items.map(item => item * 2);'],
	map_plus_ten: [items, 'i64[]', '  return in.items.map(item => item + 10);'],
	map_greater_ten: [items, 'bool[]', '  return in.items.map(item => item > 10);'],
	map_true: [items, 'bool[]', '  return in.items.map(item => true);'],
	filter_odd: [items, 'i64[]', '  return in.items.filter(item => item % 2 != 0);'],
	filter_true: [items, 'i64[]', '  return in.items.filter(item => true);'],
	reduce_sum: [items + ' value: i64;', 'i64', '  return in.items.reduce((sum, item) => sum + item, in.value);'],
	reduce_digits: [
		items + ' value: i64;',
		'i64',
		'  return in.items.reduce((sum, item) => sum * 10 + item, in.value);'
	],
	index: [items + ' start: u64;', 'i64', '  return in.items[in.start];'],
	map_index: ['items: i64[][];', 'i64[]', '  return in.items.map(row => row[0]);'],
	filter_index: ['items: i64[][];', 'i64[][]', '  return in.items.filter(row => row[0] > 0);'],
	reduce_index: [
		'items: i64[][]; value: i64;',
		'i64',
		'  return in.items.reduce((sum, row) => sum + row[0], in.value);'
	]
}

export function source(name: string, length?: number): string {
	const [fields, output, operation_body] = programs[name]
	let body = operation_body

	if (consuming.has(name)) {
		if (length === undefined) throw new Error(`owned collection fixture needs its input length: ${name}`)

		const values = Array.from({ length }, (_, index) => `in.items[${index}]`).join(', ')
		body = `  const owned: i64[] = [${values}];\n\n${body}`
	}

	return `export type Input = { ${fields} };\n\nexport type Output = ${output};\n\nexport default function (in: Input): Output {\n${body}\n}\n`
}
