import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdtempSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { fileURLToPath } from 'node:url'
import checkProtocol from './protocol.ts'
import checkScalars from './scalars.ts'
import checkState from './state.ts'

const [compiler_path, fixture_path, optimize] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-wasm-protocol-')))
const project = join(root, 'project')
let count = 0

function run(args: { command: string; argv: Array<string>; failure?: boolean }): string {
	const { command, argv, failure = false } = args
	const result = spawnSync(command, argv, { cwd: project, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)

	if (failure) assert.notEqual(result.status, 0, result.stderr)
	else assert.equal(result.status, 0, result.stderr)

	return result.stdout
}

function build(args: { source: string; name: string; wasi?: boolean; discard?: boolean }): string {
	const { source, name, wasi = false, discard = false } = args
	const output = join(root, `${name}.wasm`)
	const argv = [
		'build',
		join(project, source),
		'--target',
		wasi ? 'wasm32-wasi' : 'wasm32-freestanding',
		'--optimize',
		optimize,
		'--out',
		output
	]

	if (discard) argv.push('--result', 'discard')

	run({ command: compiler, argv })

	return output
}

try {
	cpSync(realpathSync(fixture_path), project, { recursive: true })

	for (const type of ['bool', 'u8', 'u16', 'u32', 'u64', 'i32', 'i64', 'f32', 'f64', 'void']) {
		const path = build({ source: `scalars/${type}.zx`, name: type })
		const checks = checkScalars({ path, type })

		count += checks
		console.log(`${type}: ${checks} scalar and JSON cases passed`)
	}

	const record = build({ source: 'record.zx', name: 'record' })
	const discard = build({ source: 'scalars/u8.zx', name: 'discard', discard: true })
	const state = build({ source: 'state/main.rx', name: 'state' })

	const state_count = checkState(state)

	count += state_count
	console.log(`${state_count} RX state lifecycle cases passed`)

	const wasi_host = fileURLToPath(new URL('wasi_host.ts', import.meta.url))

	for (const [source, input] of [
		['scalars/u32.zx', '42'],
		['scalars/void.zx', null],
		['record.zx', JSON.stringify({ message: 'WASI 中', values: [1, 2], flag: true, optional: null })]
	] as const) {
		const path = build({ source, name: `wasi-${count}`, wasi: true })
		const output = run({ command: process.execPath, argv: [wasi_host, path, ...(input === null ? [] : [input])] })

		assert.deepEqual(JSON.parse(output), input === null ? null : JSON.parse(input))
		run({ command: process.execPath, argv: [wasi_host, path, '{'], failure: true })
		count += 2
	}

	console.log('6 WASI command cases passed')
	count += checkProtocol({ scalar: join(root, 'u8.wasm'), record, discard, state })

	console.log(`${count} WASM scalar, JSON, lifecycle, state and WASI cases passed (${optimize})`)
} finally {
	rmSync(root, { recursive: true, force: true })
}
