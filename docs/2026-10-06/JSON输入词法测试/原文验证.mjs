import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const directory = dirname(fileURLToPath(import.meta.url))
const upstream_root = process.argv[2]
const entries = readFileSync(resolve(directory, '待审文件.jsonl'), 'utf8')
	.trim()
	.split('\n')
	.map(line => JSON.parse(line))
const results = []
const fingerprints = new Map()

assert.equal(entries.length, 23)

for (const entry of entries) {
	const source = readFileSync(resolve(upstream_root, entry.path), 'utf8')

	assert.equal(createHash('sha256').update(source).digest('hex'), entry.sha256)
	assert.equal(entry.negative, undefined)
	assert.ok(!(entry.flags ?? []).includes('module'))
	assert.ok(!(entry.flags ?? []).includes('async'))

	const modes = entry.flags?.includes('noStrict')
		? [false]
		: entry.flags?.includes('onlyStrict')
			? [true]
			: [false, true]

	for (const strict of modes) {
		const observations = []
		const context = vm.createContext({ observations })

		for (const name of ['sta.js', 'assert.js', ...(entry.includes ?? [])]) {
			const harness = readFileSync(resolve(upstream_root, 'harness', name), 'utf8')

			fingerprints.set(name, createHash('sha256').update(harness).digest('hex'))
			vm.runInContext(harness, context, { filename: name, timeout: 2000 })
		}

		vm.runInContext(
			`
const parse = JSON.parse;

JSON.parse = text => {
  try {
    const value = parse(text);

    observations.push({ json_text: text, expected: { value } });

    return value;
  } catch (error) {
    observations.push({ json_text: text, expected: { error: error.name } });

    throw error;
  }
};
`,
			context,
			{ filename: 'record_json_inputs', timeout: 1000 }
		)

		vm.runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: entry.path, timeout: 5000 })
		results.push({
			path: entry.path,
			sha256: entry.sha256,
			strict,
			passed: true,
			observations: observations.map(observation => ({
				...observation,
				input_utf8_hex: Buffer.from(observation.json_text).toString('hex')
			}))
		})
	}
}

const observed = results.reduce((sum, result) => sum + result.observations.length, 0)

assert.equal(results.length, 46)
assert.equal(observed, 54)

writeFileSync(
	resolve(directory, '原文结果.json'),
	JSON.stringify(
		{
			files: entries.length,
			node: process.version,
			harness: [...fingerprints].map(([name, sha256]) => ({ name, sha256 })),
			results,
			observed_json_parse_calls: observed,
			execution_status: 'original JavaScript executions only; generated ZX entry checks are recorded separately'
		},
		null,
		2
	) + '\n'
)

console.log(`${results.length}/${results.length} original executions; ${observed} observed JSON.parse calls`)
