import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const folder = dirname(fileURLToPath(import.meta.url))
const repo = resolve(folder, '../../..')
const record = readFileSync(resolve(repo, 'packages/test/src/data/keyword_bindings.jsonl'), 'utf8')
	.trim()
	.split('\n')
	.map(line => JSON.parse(line))
	.find(item => item.path.endsWith('const-declaring-let-split-across-two-lines.js'))
const source = readFileSync(resolve(process.argv[2], record.path), 'utf8')
const digest = createHash('sha256').update(source).digest('hex')

if (digest !== record.sha256) throw new Error('原文指纹不匹配')

const results = []

for (const strict of [false, true]) {
	let rejected = false

	try {
		new vm.Script(`${strict ? '"use strict";\n' : ''}${source}`)
	} catch (error) {
		if (!(error instanceof SyntaxError)) throw error

		rejected = true
	}

	if (!rejected) throw new Error('原文跨行保留名称绑定意外通过解析')

	results.push({ strict, phase: 'parse', error: 'SyntaxError' })
}

writeFileSync(
	resolve(folder, '原文结果.json'),
	`${JSON.stringify({ path: record.path, sha256: digest, results }, null, 2)}\n`
)
console.log('2/2 original parse rejections verified')
