import { readFileSync, writeFileSync } from 'node:fs'
import { createHash } from 'node:crypto'
import { fileURLToPath } from 'node:url'
import { dirname, resolve } from 'node:path'
import vm from 'node:vm'

const folder = dirname(fileURLToPath(import.meta.url))
const root = process.argv[2]
const records = JSON.parse(readFileSync(resolve(folder, '原文清单.json'), 'utf8'))
const results = []

for (const record of records) {
	const source = readFileSync(resolve(root, record.path), 'utf8')
	const digest = createHash('sha256').update(source).digest('hex')

	if (digest !== record.sha256) throw new Error(`原文指纹不匹配：${record.path}`)

	for (const strict of [false, true]) {
		const assertions = []
		const assert = {
			sameValue(actual, expected, message) {
				if (!Object.is(actual, expected)) throw new Error(`${record.path}: ${message}`)

				assertions.push({ actual, expected, message })
			}
		}

		vm.runInNewContext(`${strict ? '"use strict";\n' : ''}${source}`, { assert }, { timeout: 1000 })
		results.push({ path: record.path, sha256: digest, strict, assertions })
	}
}

writeFileSync(
	resolve(folder, '原文结果.json'),
	`${JSON.stringify({ files: records.length, executions: results.length, results }, null, 2)}\n`
)
console.log(`${records.length} files, ${results.length} executions passed`)
