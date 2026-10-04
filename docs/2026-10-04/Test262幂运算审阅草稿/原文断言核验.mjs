import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = process.argv[2]
const rows = readFileSync('packages/test/upstream/reviews/language/expressions/exponentiation_numeric.jsonl', 'utf8').trim().split('\n').map(row => JSON.parse(row))
let assertions = 0

for (const row of rows) {
	const source = readFileSync(join(root, row.path), 'utf8')

	assert.equal(createHash('sha256').update(source).digest('hex'), row.sha256)
	runInNewContext(source, {
		assert: { sameValue(actual, expected) { assertions++; assert.ok(Object.is(actual, expected)) } },
		Test262Error: class extends Error {},
	}, { filename: row.path, timeout: 1000 })
	console.log('CHECK ' + row.path)
}

console.log('Original files: ' + rows.length + '; sameValue assertions: ' + assertions + '; all direct throw checks also completed')
