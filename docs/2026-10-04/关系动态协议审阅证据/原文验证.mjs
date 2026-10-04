import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const directory = fileURLToPath(new URL('.', import.meta.url))
const reference = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = JSON.parse(readFileSync(join(directory, '原文证据.json'), 'utf8'))
const reviews = readFileSync(join(directory, '审阅记录.jsonl'), 'utf8').trim().split('\n').map(line => JSON.parse(line))

assert.equal(evidence.length, 12)
assert.equal(reviews.length, 12)

for (const item of evidence) {
	const source = readFileSync(join(reference, item.path), 'utf8')
	const digest = createHash('sha256').update(source).digest('hex')
	const review = reviews.find(entry => entry.path === item.path)

	assert.equal(digest, item.sha256)
	assert.equal(digest, review.sha256)
	assert.equal(review.status, 'excluded')
	assert.deepEqual(review.cases, [])

	if (item.kind === 'default_value') {
		assert.equal((source.match(/\/\/CHECK#/g) ?? []).length, 8)
		assert.equal(item.true_conditions.length, 6)

		for (const expression of [...item.true_conditions, item.throw_error, item.throw_type_error]) assert.ok(source.includes(expression))
	} else {
		assert.equal(item.assertions.length, 2)

		for (const line of item.assertions) assert.ok(source.includes(line))
	}

	runInNewContext(source, { Test262Error: Error, assert: { sameValue(actual, expected) { assert.ok(Object.is(actual, expected)) } } }, { filename: item.path, timeout: 1000 })
}

console.log('PASS: 12 original JavaScript reference executions and hashes; these are not ZX test passes')
