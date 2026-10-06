import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const directory = dirname(fileURLToPath(import.meta.url))
const upstream_root = process.argv[2]
const records = JSON.parse(readFileSync(resolve(directory, '原文清单.json'), 'utf8'))
const harness = new Map()
const results = []

for (const record of records) {
	const source = readFileSync(resolve(upstream_root, record.path), 'utf8')

	assert.equal(createHash('sha256').update(source).digest('hex'), record.sha256)
	assert.equal((source.match(/assert(?:\.[a-zA-Z]+)?\(/g) ?? []).length, record.direct_assertion_sites)
	assert.equal((source.match(/verifyProperty\(/g) ?? []).length, record.property_helper_sites)

	const names = ['sta.js', 'assert.js', ...record.includes]

	for (const name of names) {
		if (harness.has(name)) continue

		const text = readFileSync(resolve(upstream_root, 'harness', name), 'utf8')

		harness.set(name, { name, source: text, sha256: createHash('sha256').update(text).digest('hex') })
	}

	for (const strict of record.flags.includes('noStrict')
		? [false]
		: record.flags.includes('onlyStrict')
			? [true]
			: [false, true]) {
		const context = vm.createContext({})

		for (const name of names) {
			const entry = harness.get(name)

			vm.runInContext(entry.source, context, { filename: entry.name, timeout: 1000 })
		}

		const constructors = record.includes.includes('resizableArrayBufferUtils.js')
			? vm.runInContext('ctors.map(ctor => ctor.name)', context, { timeout: 1000 })
			: record.includes.includes('testTypedArray.js')
				? vm.runInContext('typedArrayConstructors.map(ctor => ctor.name)', context, { timeout: 1000 })
				: []

		vm.runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: record.path, timeout: 1000 })
		results.push({
			path: record.path,
			sha256: record.sha256,
			strict,
			harness: names,
			constructors,
			direct_assertion_sites: record.direct_assertion_sites,
			property_helper_sites: record.property_helper_sites,
			passed: true
		})
	}
}

writeFileSync(
	resolve(directory, '原文结果.json'),
	JSON.stringify(
		{
			node_version: process.version,
			files: records.length,
			harness: [...harness.values()].map(({ name, sha256 }) => ({ name, sha256 })),
			results
		},
		null,
		2
	) + '\n'
)
console.log(`${results.length}/${results.length} original executions verified`)
