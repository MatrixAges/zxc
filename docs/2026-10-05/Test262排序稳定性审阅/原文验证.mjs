import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const folder = dirname(fileURLToPath(import.meta.url))
const root = process.argv[2]
const records = JSON.parse(readFileSync(resolve(folder, '原文清单.json'), 'utf8'))
const harness = ['sta.js', 'assert.js'].map(name => {
	const source = readFileSync(resolve(root, 'harness', name), 'utf8')

	return { name, source, sha256: createHash('sha256').update(source).digest('hex') }
})
const results = []

for (const record of records) {
	const source = readFileSync(resolve(root, record.path), 'utf8')
	const digest = createHash('sha256').update(source).digest('hex')

	assert.equal(digest, record.sha256)

	const body = source.match(/const array = \[\n([\s\S]*?)\n\];/)[1]
	const entries = body.split('\n').map(line => {
		const match = line.match(/^  \{ name: '([^']+)', rating: ([0-9]+) \},$/)

		assert.ok(match)

		return { name: match[1], rating: Number(match[2]) }
	})

	assert.equal(entries.length, record.size)
	assert.equal(new Set(entries.map(item => item.name)).size, record.size)

	for (const strict of [false, true]) {
		const context = vm.createContext({})

		for (const item of harness) vm.runInContext(item.source, context, { filename: item.name, timeout: 1000 })

		vm.runInContext(`${strict ? '"use strict";\n' : ''}${source}`, context, {
			filename: record.path,
			timeout: 1000
		})

		const observed = JSON.parse(vm.runInContext('JSON.stringify({ length: array.length, reduced })', context))

		assert.equal(observed.length, record.size)
		assert.equal(observed.reduced, record.expected)
		results.push({ path: record.path, sha256: digest, strict, observed, original_passed: true })
	}
}

writeFileSync(
	resolve(folder, '原文结果.json'),
	`${JSON.stringify({ files: records.length, harness: harness.map(({ name, sha256 }) => ({ name, sha256 })), results }, null, 2)}\n`
)
console.log(`${results.length}/${results.length} original executions verified`)
