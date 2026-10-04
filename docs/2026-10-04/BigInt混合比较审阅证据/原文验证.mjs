import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { runInNewContext } from 'node:vm'

const directory = fileURLToPath(new URL('.', import.meta.url))
const reference = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = JSON.parse(readFileSync(join(directory, '原文证据.json'), 'utf8'))
const reviews = readFileSync(join(directory, '审阅记录.jsonl'), 'utf8').trim().split('\n').map(line => JSON.parse(line))
let assertion_count = 0

assert.equal(evidence.length, 8)
assert.equal(reviews.length, 8)

for (const item of evidence) {
	const source = readFileSync(join(reference, item.path), 'utf8')
	const digest = createHash('sha256').update(source).digest('hex')
	const review = reviews.find(entry => entry.path === item.path)
	let count = 0

	assert.equal(digest, item.sha256)
	assert.equal(digest, review.sha256)
	assert.equal(review.status, 'excluded')
	assert.deepEqual(review.cases, [])

	for (const value of item.values) assert.ok(source.includes(`assert.sameValue(${value.expression}, ${value.expected},`))
	for (const value of item.errors) assert.ok(source.includes(value.expression + ';'))

	runInNewContext(source, { assert: {
		sameValue(actual, expected) {
			assert.ok(Object.is(actual, expected))
			count++
		},
		throws(expected, callback) {
			let caught

			try { callback() } catch (error) { caught = error }

			assert.ok(caught)
			assert.equal(caught.constructor, expected)
			count++
		},
	} }, { filename: item.path, timeout: 1000 })

	assert.equal(count, item.values.length + item.errors.length)
	assertion_count += count
}

assert.equal(assertion_count, 72)
console.log('PASS: 8 hashes and original JavaScript files, 72 reference assertions including exact TypeError constructors; no ZX pass claims')
