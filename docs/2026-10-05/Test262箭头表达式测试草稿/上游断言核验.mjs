import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import vm from 'node:vm'

const upstream = resolve(process.argv[2])
const rows = readFileSync('packages/test/src/data/arrow_bodies.jsonl', 'utf8')
	.trim()
	.split('\n')
	.map(line => JSON.parse(line))
const results = []

for (const row of rows) {
	const source = readFileSync(join(upstream, row.path), 'utf8')
	assert.equal(createHash('sha256').update(source).digest('hex'), row.sha256)

	for (const strict of [false, true]) {
		let assertions = 0
		const context = vm.createContext({
			assert: {
				sameValue(actual, expected) {
					assert.ok(Object.is(actual, expected), `${row.path}: ${actual} != ${expected}`)
					assertions += 1
				}
			}
		})
		new vm.Script((strict ? '"use strict";\n' : '') + source, { filename: row.path }).runInContext(context, {
			timeout: 1000
		})
		results.push({ path: row.path, strict, assertions, passed: true })
	}
}

writeFileSync(new URL('上游断言结果.json', import.meta.url), JSON.stringify(results, null, 2) + '\n')
console.log(
	JSON.stringify({
		files: rows.length,
		executions: results.length,
		assertions: results.reduce((sum, row) => sum + row.assertions, 0)
	})
)
