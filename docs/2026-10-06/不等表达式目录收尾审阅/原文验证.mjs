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
const harness = ['sta.js', 'assert.js'].map(name => {
	const source = readFileSync(resolve(upstream_root, 'harness', name), 'utf8')

	return { name, source, sha256: createHash('sha256').update(source).digest('hex') }
})
const results = []
let same_value_calls = 0

assert.equal(entries.length, 20)

for (const entry of entries) {
	assert.ok(entry.path.startsWith('test/language/expressions/does-not-equals/'))

	const source = readFileSync(resolve(upstream_root, entry.path), 'utf8')

	assert.equal(createHash('sha256').update(source).digest('hex'), entry.sha256)
	assert.ok(!entry.flags?.length)
	assert.ok(!entry.includes?.length)
	assert.equal(entry.negative, undefined)

	same_value_calls += (source.match(/assert\.sameValue\s*\(/g) ?? []).length

	for (const strict of [false, true]) {
		const context = vm.createContext({})

		for (const entry of harness) vm.runInContext(entry.source, context, { filename: entry.name, timeout: 1000 })

		vm.runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: entry.path, timeout: 1000 })
		results.push({ path: entry.path, sha256: entry.sha256, strict, passed: true })
	}
}

assert.equal(same_value_calls, 179)
assert.equal(results.length, 40)

writeFileSync(
	resolve(directory, '原文结果.json'),
	JSON.stringify(
		{
			files: entries.length,
			static_same_value_calls: same_value_calls,
			node: process.version,
			harness: harness.map(({ name, sha256 }) => ({ name, sha256 })),
			results,
			execution_status: 'original JavaScript executions only; no ZX compatibility claim'
		},
		null,
		2
	) + '\n'
)

console.log(`${results.length}/${results.length} original executions verified`)
