import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'

const directory = new URL('./', import.meta.url)
const data = JSON.parse(readFileSync(new URL('IP预期.json', directory), 'utf8'))
const results = []

function numericSuffix(input) {
	const text = input.endsWith('.') ? input.slice(0, -1) : input
	const last = text.split('.').at(-1)

	return /^(?:[0-9]+|0[xX][0-9a-fA-F]*)$/.test(last)
}

for (const kind of ['ipv4', 'ipv6']) {
	for (const [input, expected] of data[kind]) {
		const host = kind === 'ipv4' ? input : `[${input}]`
		const observed = new URL(`http://${host}/`).hostname.replace(/^\[|\]$/g, '')
		assert.equal(observed, expected)
		results.push({ kind, input, expected, observed, compared: true })
	}

	for (const input of data[`${kind}_invalid`]) {
		const host = kind === 'ipv4' ? input : `[${input}]`
		let observed

		try {
			observed = new URL(`http://${host}/`).hostname
		} catch {
			observed = null
		}

		const compared = kind === 'ipv6' || (/^[\x00-\x7f]*$/.test(input) && numericSuffix(input))

		if (compared) assert.equal(observed, null)

		results.push({
			kind,
			input,
			observed,
			compared,
			reason: compared
				? 'numeric host parser'
				: 'domain or IDNA processing lies outside the direct ASCII IPv4 parser'
		})
	}
}

const masks = []

for (let mask = 0; mask < 256; mask++) {
	const input = Array.from({ length: 8 }, (_, index) => (mask & (1 << index) ? '0' : (index + 1).toString(16))).join(
		':'
	)
	const expected = new URL(`http://[${input}]/`).hostname.slice(1, -1)
	masks.push({ input, expected })
}

const source = [
	'pub const cases = [_]struct { input: []const u8, expected: []const u8 }{',
	...masks.map(
		entry => `    .{ .input = ${JSON.stringify(entry.input)}, .expected = ${JSON.stringify(entry.expected)} },`
	),
	'};\n'
].join('\n')

writeFileSync(new URL('../../../packages/test/tests/standard/resources/url/host/ipv6_masks.zig', directory), source)
writeFileSync(
	new URL('Node对照.json', directory),
	JSON.stringify(
		{
			node: process.version,
			compared: results.filter(row => row.compared).length,
			outside_scope: results.filter(row => !row.compared).length,
			ipv6_masks: masks.length,
			results
		},
		null,
		2
	) + '\n'
)
console.log(
	`Node IP comparisons: ${results.filter(row => row.compared).length}; outside direct-parser scope: ${results.filter(row => !row.compared).length}; IPv6 masks: ${masks.length}`
)
