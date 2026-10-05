import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdtempSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import checkBytes from './bytes.ts'
import checkCollections from './collections.ts'
import load from './load.ts'
import checkProperties from './properties.ts'
import checkRecords from './records.ts'
import checkScalars from './scalars.ts'
import checkState from './state.ts'

const [compiler_path, fixture_path, optimize] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-napi-protocol-')))
const project = join(root, 'project')
let count = 0

function build(args: { source: string; name: string }): string {
	const { source, name } = args
	const output = join(root, `${name}.node`)
	const result = spawnSync(
		compiler,
		['build', join(project, source), '--host', 'node', '--optimize', optimize, '--out', output],
		{ cwd: project, encoding: 'utf8', timeout: 180_000 }
	)

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	assert.equal(result.status, 0, result.stderr)

	return output
}

try {
	cpSync(realpathSync(fixture_path), project, { recursive: true })

	for (const type of ['void', 'bool', 'u8', 'u16', 'u32', 'u64', 'i32', 'i64', 'f32', 'f64', 'string']) {
		const path = build({ source: `scalars/${type}.zx`, name: type })
		const checks = checkScalars({ execute: load(path), type })

		count += checks
		console.log(`${type}: ${checks} scalar cases passed`)
	}

	const bytes = checkBytes(load(build({ source: 'bytes.zx', name: 'bytes' })))
	const records = checkRecords(load(build({ source: 'record.zx', name: 'record' })))
	const properties = checkProperties(load(build({ source: 'properties.zx', name: 'properties' })))
	const collections = checkCollections({
		optional: load(build({ source: 'optional.zx', name: 'optional' })),
		tuple: load(build({ source: 'tuple.zx', name: 'tuple' }))
	})
	const state = await checkState(build({ source: 'state/main.rx', name: 'state' }))

	count += bytes + records + properties + collections + state
	console.log(`${bytes} byte, ${records} record, ${collections} collection and ${state} state cases passed`)
	console.log(`${count} NAPI protocol cases passed (${optimize})`)
} finally {
	rmSync(root, { recursive: true, force: true })
}
