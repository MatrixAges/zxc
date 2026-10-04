import { readFileSync } from 'node:fs'
import { resolve, join } from 'node:path'
import { runInNewContext } from 'node:vm'

const repo = resolve(import.meta.dirname, '../../..')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const reviews = readFileSync(join(repo, 'packages/test/upstream/reviews/language/expressions/addition_protocols.jsonl'), 'utf8').trim().split('\n').map(line => JSON.parse(line))
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(join(upstream, 'harness', name), 'utf8')).join('\n')
let executions = 0

for (const review of reviews) {
	const source = readFileSync(join(upstream, review.path), 'utf8')

	for (const strict of [false, true]) {
		runInNewContext((strict ? '"use strict";\n' : '') + harness + '\n' + source, Object.create(null), { filename: review.path, timeout: 2000 })
		executions++
	}
}

console.log(`Reference engine ${process.version}: ${reviews.length} Test262 files, ${executions} strict/sloppy executions PASS; these are not zxc executions`)
