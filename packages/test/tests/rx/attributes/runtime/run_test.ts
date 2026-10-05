import type { Json } from '../../../../src/shared/json.ts'
import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdtempSync, readFileSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

type Case = { entry: string; input: Json; expected: Json }

const [compiler_path, fixture_path, optimize] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const fixture_source = realpathSync(fixture_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-rx-attributes-')))
const fixtures = join(root, 'project')
const cases = JSON.parse(readFileSync(new URL('cases.json', import.meta.url), 'utf8')) as Array<Case>
let count = 0

function run(command: string, argv: Array<string>): string {
	const result = spawnSync(command, argv, { cwd: fixtures, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	assert.equal(result.status, 0, result.stderr)

	return result.stdout
}

try {
	cpSync(fixture_source, fixtures, { recursive: true })

	for (const entry of new Set(cases.map(row => row.entry))) {
		const output = join(root, entry.replaceAll('/', '_') + (process.platform === 'win32' ? '.exe' : ''))

		run(compiler, ['build', join(fixtures, entry), '--out', output, '--optimize', optimize])

		for (const row of cases.filter(row => row.entry === entry)) {
			const result = run(output, row.input === null ? [] : [JSON.stringify(row.input)])

			assert.deepEqual(JSON.parse(result), row.expected, `${entry}: ${JSON.stringify(row.input)}`)
			count += 1
		}
	}

	assert.equal(count, 55)
	console.log(`${count} RX attribute executions passed (${optimize})`)
} finally {
	rmSync(root, { recursive: true, force: true })
}
