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

assert.equal(entries.length, 35)

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
		const context = vm.createContext({})

		for (const name of ['sta.js', 'assert.js', ...(entry.includes ?? [])]) {
			const harness = readFileSync(resolve(upstream_root, 'harness', name), 'utf8')

			fingerprints.set(name, createHash('sha256').update(harness).digest('hex'))
			vm.runInContext(harness, context, { filename: name, timeout: 2000 })
		}

		let error = null

		try {
			vm.runInContext((strict ? '"use strict";\n' : '') + source, context, {
				filename: entry.path,
				timeout: 5000
			})
		} catch (failure) {
			error = { name: failure.name, message: failure.message, stack: failure.stack }
		}

		results.push({ path: entry.path, sha256: entry.sha256, strict, passed: error === null, error })
	}
}

assert.equal(results.length, 70)

writeFileSync(
	resolve(directory, '原文结果.json'),
	JSON.stringify(
		{
			files: entries.length,
			node: process.version,
			harness: [...fingerprints].map(([name, sha256]) => ({ name, sha256 })),
			json_parse_replaced: false,
			results,
			execution_status: 'original JavaScript reference executions; zero generated ZX application executions'
		},
		null,
		2
	) + '\n'
)

const passed = results.filter(result => result.passed).length

console.log(`${passed}/${results.length} unchanged original executions; JSON.parse was not replaced`)
assert.equal(passed, results.length)
