import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync, writeFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { resolve } from 'node:path'
import vm from 'node:vm'

const require = createRequire(new URL('../../../packages/test/package.json', import.meta.url))
const { parse } = require('yaml')
const base = process.argv[2]
const indexed = new Map(
	readFileSync(new URL('../../../packages/test/upstream/index/built-ins.jsonl', import.meta.url), 'utf8')
		.trim()
		.split('\n')
		.map(line => {
			const row = JSON.parse(line)
			return [row.path, row.sha256]
		})
)
const results = []
const inventory = []

for (const method of ['sort', 'map', 'filter', 'reduce']) {
	const directory = `test/built-ins/Array/prototype/${method}`

	for (const name of readdirSync(resolve(base, directory))
		.filter(name =>
			[
				'S15.4.4.11_A2.1_T1.js',
				'15.4.4.19-8-c-ii-10.js',
				'15.4.4.19-9-1.js',
				'15.4.4.19-9-2.js',
				'15.4.4.20-10-1.js',
				'15.4.4.20-10-2.js',
				'15.4.4.21-7-10.js'
			].includes(name)
		)
		.sort()) {
		const path = `${directory}/${name}`
		const raw = readFileSync(resolve(base, path))
		const sha256 = createHash('sha256').update(raw).digest('hex')
		const metadata = parse(raw.toString().match(/\/\*---([\s\S]*?)---\*\//)[1])
		const flags = metadata.flags ?? []
		const includes = metadata.includes ?? []

		assert.equal(sha256, indexed.get(path))
		assert.equal(flags.includes('async') || flags.includes('module') || flags.includes('raw'), false)
		inventory.push({ path, sha256, flags, includes, description: metadata.description })

		for (const strict of flags.includes('onlyStrict')
			? [true]
			: flags.includes('noStrict')
				? [false]
				: [false, true]) {
			const harness = ['sta.js', 'assert.js', ...includes]
				.map(name => readFileSync(resolve(base, 'harness', name), 'utf8'))
				.join('\n')
			const context = vm.createContext({
				$262: { createRealm: () => ({ global: vm.runInNewContext('globalThis') }) }
			})
			const source = (strict ? '"use strict";\n' : '') + harness + '\n' + raw.toString()

			try {
				assert.equal(metadata.negative, undefined)
				new vm.Script(source, { filename: path }).runInContext(context, { timeout: 30000 })
				results.push({ path, strict, passed: true })
			} catch (error) {
				results.push({ path, strict, passed: false, error: String(error) })
			}
		}
	}
}

writeFileSync(new URL('./原文清单.jsonl', import.meta.url), inventory.map(row => JSON.stringify(row) + '\n').join(''))
writeFileSync(
	new URL('./原文结果.json', import.meta.url),
	JSON.stringify({ node: process.version, files: inventory.length, results }, null, 2) + '\n'
)
console.log(
	JSON.stringify({
		files: inventory.length,
		executions: results.length,
		failures: results.filter(row => !row.passed)
	})
)
assert.ok(results.every(row => row.passed))
