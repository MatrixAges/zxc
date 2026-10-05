import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, existsSync, mkdtempSync, readFileSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

const [compiler_path, fixture_path] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-rx-attribute-errors-')))
const project = join(root, 'project')
const output = join(root, process.platform === 'win32' ? 'rejected.exe' : 'rejected')
const cases = JSON.parse(readFileSync(new URL('rejections.json', import.meta.url), 'utf8')) as Array<{
	entry: string
	code: string
}>

try {
	cpSync(realpathSync(fixture_path), project, { recursive: true })

	for (const row of cases) {
		const result = spawnSync(compiler, ['build', join(project, row.entry), '--out', output], {
			cwd: project,
			encoding: 'utf8',
			timeout: 180_000
		})

		assert.ifError(result.error)
		assert.equal(result.signal, null, result.stderr)
		assert.notEqual(result.status, 0, row.entry)
		assert.ok(result.stderr.includes(row.entry), result.stderr)
		assert.ok(result.stderr.includes(`: ${row.code}:`), result.stderr)
		assert.equal(existsSync(output), false)
	}

	assert.equal(cases.length, 6)
	console.log('6 RX attribute semantic rejection cases passed')
} finally {
	rmSync(root, { recursive: true, force: true })
}
