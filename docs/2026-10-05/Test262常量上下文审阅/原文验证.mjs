import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const folder = dirname(fileURLToPath(import.meta.url))
const records = JSON.parse(readFileSync(resolve(folder, '原文清单.json'), 'utf8'))
const results = []

for (const record of records) {
	const source = readFileSync(resolve(process.argv[2], record.path), 'utf8')
	const digest = createHash('sha256').update(source).digest('hex')

	if (digest !== record.sha256) throw new Error(`原文指纹不匹配：${record.path}`)

	for (const strict of [false, true]) {
		let script
		let rejected = false

		try {
			script = new vm.Script(`${strict ? '"use strict";\n' : ''}${source}`, { filename: record.path })
		} catch (error) {
			if (!(error instanceof SyntaxError)) throw error

			rejected = true
		}

		if (rejected !== record.parse_error) throw new Error(`解析结果不符合原文：${record.path}`)
		if (!rejected) script.runInNewContext({}, { timeout: 1000 })

		results.push({ path: record.path, sha256: digest, strict, parse_error: rejected, executed: !rejected })
	}
}

writeFileSync(resolve(folder, '原文结果.json'), `${JSON.stringify({ files: records.length, results }, null, 2)}\n`)
console.log(`${results.length}/${results.length} original expectations verified`)
