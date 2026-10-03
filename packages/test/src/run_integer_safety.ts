import { spawnSync } from 'node:child_process'
import { writeFileSync } from 'node:fs'
import { basename } from 'node:path'
import { readRows, stringify } from './shared/json.ts'

type Case = { id: string; arguments: Array<string>; expected: { panic?: string; value?: number | bigint } }

const [executable, catalog, report] = process.argv.slice(2)
const rows = readRows<Case>(catalog)

if (!rows.length || new Set(rows.map(row => row.id)).size !== rows.length)
	throw new Error('empty catalog or duplicate case ID')

const results = []

for (const row of rows) {
	const panic = row.expected.panic
	const expected_code = panic === undefined ? 0 : 86
	const expected_stderr =
		'ZX_EXECUTE\n' + (panic === undefined ? `ZX_RESULT=${row.expected.value}\n` : `ZX_PANIC=${panic}\n`)
	const actual = spawnSync(executable, row.arguments, { encoding: 'utf8', timeout: 10_000, killSignal: 'SIGKILL' })
	const timed_out = actual.error && 'code' in actual.error && actual.error.code === 'ETIMEDOUT'
	const result = timed_out
		? { id: row.id, passed: false, failure: 'timeout' }
		: {
				id: row.id,
				passed:
					!actual.error &&
					actual.signal === null &&
					actual.status === expected_code &&
					actual.stdout === '' &&
					actual.stderr === expected_stderr,
				returncode: actual.status,
				stderr: actual.stderr,
				...(actual.signal ? { signal: actual.signal } : {}),
				...(actual.error ? { failure: actual.error.message } : {})
			}

	results.push(result)
	if (!result.passed) console.error(stringify(result))
}

writeFileSync(report, results.map(result => stringify(result) + '\n').join(''))
const passed = results.filter(result => result.passed).length
console.log(`${basename(catalog, '.jsonl')} isolated runtime: ${passed}/${rows.length} passed`)

if (passed !== rows.length) process.exitCode = 1
