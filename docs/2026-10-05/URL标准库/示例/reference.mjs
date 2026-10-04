import { readFileSync } from 'node:fs'

const input = JSON.parse(readFileSync(process.argv[2], 'utf8'))
const parsed = new URLSearchParams(input.query)
const appended = new URLSearchParams(parsed)

appended.append(input.key, input.value)

const assigned = new URLSearchParams(appended)

assigned.set(input.key, input.value)

const removed = new URLSearchParams(appended)

if (input.match_value === null) removed.delete(input.key)
else removed.delete(input.key, input.match_value)

const ordered = new URLSearchParams(appended)

ordered.sort()

console.log(
	JSON.stringify(
		{
			original: parsed.toString(),
			appended: appended.toString(),
			assigned: assigned.toString(),
			removed: removed.toString(),
			ordered: ordered.toString(),
			first: appended.get(input.key),
			all: appended.getAll(input.key),
			found: input.match_value === null ? appended.has(input.key) : appended.has(input.key, input.match_value),
			count: appended.size,
			keys: [...ordered.keys()],
			values: [...ordered.values()]
		},
		null,
		2
	)
)
