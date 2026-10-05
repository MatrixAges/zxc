import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const folder = dirname(fileURLToPath(import.meta.url))
const record = JSON.parse(readFileSync(resolve(folder, '原文清单.json'), 'utf8'))
const source = readFileSync(resolve(process.argv[2], record.path), 'utf8')
const digest = createHash('sha256').update(source).digest('hex')
const harness = readFileSync(resolve(process.argv[2], 'harness/sta.js'), 'utf8')

assert.equal(digest, record.sha256)
assert.deepEqual(JSON.parse(source.match(/^var alphabetR = (\[.*\]);$/m)[1]), record.input)
assert.deepEqual(JSON.parse(source.match(/^var alphabet = (\[.*\]);$/m)[1]), record.expected)

let ordering_pairs = 0

for (const left of record.input) {
	assert.equal(left.length, 1)
	assert.ok(left.charCodeAt(0) < 0xd800 || left.charCodeAt(0) > 0xdfff)

	for (const right of record.input) {
		const utf16 = left < right ? -1 : left > right ? 1 : 0

		assert.equal(Math.sign(Buffer.compare(Buffer.from(left), Buffer.from(right))), utf16)
		ordering_pairs += 1
	}
}

const results = []

for (const strict of [false, true]) {
	const context = vm.createContext({})

	vm.runInContext(harness, context, { timeout: 1000 })
	vm.runInContext(`${strict ? '"use strict";\n' : ''}${source}`, context, { filename: record.path, timeout: 1000 })
	assert.deepEqual(Array.from(context.alphabetR), record.expected)
	results.push({ strict, original_passed: true, full_result: Array.from(context.alphabetR) })
}

writeFileSync(
	resolve(folder, '原文结果.json'),
	`${JSON.stringify({ path: record.path, sha256: digest, harness_sha256: createHash('sha256').update(harness).digest('hex'), ordering_pairs, results }, null, 2)}\n`
)
console.log('2/2 original executions and full sorted results verified')
