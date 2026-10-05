import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const folder = dirname(fileURLToPath(import.meta.url))
const root = process.argv[2]
const records = JSON.parse(readFileSync(resolve(folder, '原文清单.json'), 'utf8'))
const harness = ['sta.js', 'assert.js', 'propertyHelper.js'].map(name => {
	const source = readFileSync(resolve(root, 'harness', name), 'utf8')

	return { name, source, sha256: createHash('sha256').update(source).digest('hex') }
})
const results = []

for (const record of records) {
	const source = readFileSync(resolve(root, record.path), 'utf8')
	const digest = createHash('sha256').update(source).digest('hex')

	if (digest !== record.sha256) throw new Error(`原文指纹不匹配：${record.path}`)

	for (const strict of [false, true]) {
		const context = vm.createContext({})

		for (const item of harness) vm.runInContext(item.source, context, { filename: item.name, timeout: 1000 })

		vm.runInContext(`${strict ? '"use strict";\n' : ''}${source}`, context, {
			filename: record.path,
			timeout: 1000
		})
		results.push({ path: record.path, sha256: digest, strict, passed: true })
	}
}

const result = {
	files: records.length,
	executions: results.length,
	harness: harness.map(({ name, sha256 }) => ({ name, sha256 })),
	results
}

writeFileSync(resolve(folder, '原文结果.json'), `${JSON.stringify(result, null, 2)}\n`)
console.log(`${result.executions}/${result.executions} original executions passed`)
