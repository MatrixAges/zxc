import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const directory = dirname(fileURLToPath(import.meta.url))
const upstream_root = process.argv[2]
const records = JSON.parse(readFileSync(resolve(directory, '原文清单.json'), 'utf8'))
const harness = ['sta.js', 'assert.js'].map(name => {
	const source = readFileSync(resolve(upstream_root, 'harness', name), 'utf8')

	return { name, source, sha256: createHash('sha256').update(source).digest('hex') }
})
const results = []

for (const record of records) {
	const source = readFileSync(resolve(upstream_root, record.path), 'utf8')

	assert.equal(createHash('sha256').update(source).digest('hex'), record.sha256)
	assert.equal((source.match(/assert(?:\.[a-zA-Z]+)?\(/g) ?? []).length, record.original_assertions)

	for (const strict of [false, true]) {
		const context = vm.createContext({})

		for (const entry of harness) vm.runInContext(entry.source, context, { filename: entry.name, timeout: 1000 })

		vm.runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: record.path, timeout: 1000 })
		results.push({
			path: record.path,
			sha256: record.sha256,
			strict,
			original_assertions: record.original_assertions,
			passed: true
		})
	}
}

writeFileSync(
	resolve(directory, '原文结果.json'),
	JSON.stringify(
		{ files: records.length, harness: harness.map(({ name, sha256 }) => ({ name, sha256 })), results },
		null,
		2
	) + '\n'
)
console.log(`${results.length}/${results.length} original executions verified`)
