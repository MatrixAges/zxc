import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { Script, createContext } from 'node:vm'

const root = process.argv[2]
const rows = readFileSync('packages/test/upstream/reviews/language/literals/decimal_boundaries.jsonl', 'utf8').trim().split('\n').map(row => JSON.parse(row))
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(join(root, 'harness', name), 'utf8')).join('\n')
let checks = 0
let parse_checks = 0

for (const row of rows) {
	const source = readFileSync(join(root, row.path), 'utf8')

	assert.equal(createHash('sha256').update(source).digest('hex'), row.sha256)
	assert.equal(/flags:/.test(source), false)
	assert.equal(/includes:/.test(source), false)

	for (const strict of [false, true]) {
		const text = (strict ? '"use strict";\n' : '') + source

		if (/negative:\s*phase: parse\s*type: SyntaxError/.test(source)) {
			assert.throws(() => new Script(text, { filename: row.path }), SyntaxError)
			parse_checks++
		} else {
			const context = createContext({})

			new Script(harness).runInContext(context, { timeout: 1000 })
			new Script(text, { filename: row.path }).runInContext(context, { timeout: 1000 })
		}

		checks++
		console.log('CHECK ' + (strict ? 'strict ' : 'normal ') + row.path)
	}
}

console.log('Files: ' + rows.length + '; checks: ' + checks + '; parse-only: ' + parse_checks)
