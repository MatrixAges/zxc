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
let total = 0

assert.equal(evidence.length, 20)
assert.equal(reviews.length, 20)

for (const item of evidence) {
	const source = readFileSync(join(reference, item.path), 'utf8')
	const digest = createHash('sha256').update(source).digest('hex')
	const review = reviews.find(entry => entry.path === item.path)
	let count = 0

	assert.equal(digest, item.sha256)
	assert.equal(digest, review.sha256)
	assert.equal(review.status, 'excluded')
	assert.deepEqual(review.cases, [])

	runInNewContext(source, { assert: { sameValue(actual, expected) {
		assert.equal(expected, item.values[count].expected)
		assert.ok(Object.is(actual, expected))
		count++
	} } }, { filename: item.path, timeout: 1000 })

	assert.equal(count, item.values.length)
	for (const value of item.values) assert.ok(source.includes(value.expression))
	total += count
}

assert.equal(total, 438)
console.log('PASS: 20 original JavaScript files and hashes, 438 assertions; these are not ZX test passes')
