import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const directory = dirname(fileURLToPath(import.meta.url))
const upstream_root = process.argv[2]
const path = 'test/language/expressions/relational/S9.1_A1_T4.js'
const sha256 = '89427f1aa0a8d99bfd99d0fe2130fa31cc6f2275b7500aae844742defaa15498'
const source = readFileSync(resolve(upstream_root, path), 'utf8')
const harness = ['sta.js', 'assert.js'].map(name => {
	const source = readFileSync(resolve(upstream_root, 'harness', name), 'utf8')

	return { name, source, sha256: createHash('sha256').update(source).digest('hex') }
})

assert.equal(createHash('sha256').update(source).digest('hex'), sha256)

const results = []

for (const strict of [false, true]) {
	const context = vm.createContext({})

	for (const entry of harness) vm.runInContext(entry.source, context, { filename: entry.name, timeout: 1000 })

	vm.runInContext((strict ? '"use strict";\n' : '') + source, context, { filename: path, timeout: 1000 })
	results.push({ path, sha256, strict, passed: true })
}

writeFileSync(
	resolve(directory, '原文结果.json'),
	JSON.stringify(
		{
			files: 1,
			static_checks: 2,
			node: process.version,
			harness: harness.map(({ name, sha256 }) => ({ name, sha256 })),
			results
		},
		null,
		2
	) + '\n'
)

console.log(`${results.length}/${results.length} original executions verified`)
