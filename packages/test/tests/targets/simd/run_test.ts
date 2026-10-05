import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdtempSync, readFileSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import load from '../napi/load.ts'
import createHost from '../wasm/host.ts'
import checkAssembly from './assembly.ts'
import check from './check.ts'
import values, { lengths } from './values.ts'

const [compiler_path, fixture_path, optimize] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-simd-semantics-')))
const project = join(root, 'project')
let count = 0

function build(args: { type: string; cpu?: string }): string {
	const { type, cpu } = args
	const output = join(root, `${type}-${cpu ?? 'node'}.${cpu ? 'wasm' : 'node'}`)
	const argv = ['build', join(project, `${type}.zx`), '--optimize', optimize, '--out', output]

	if (cpu) argv.push('--target', 'wasm32-freestanding', '--cpu', cpu, '--asm', `${output}.s`)
	else argv.push('--host', 'node')

	const result = spawnSync(compiler, argv, { cwd: project, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	assert.equal(result.status, 0, result.stderr)

	return output
}

try {
	cpSync(realpathSync(fixture_path), project, { recursive: true })

	for (const type of ['f32', 'f64']) {
		const execute = load(build({ type }))

		for (const special of [false, true]) {
			for (const size of lengths) {
				const input = values({ size, special })
				const before = input.slice()

				check({ actual: execute(input), input, type })
				assert.deepEqual(input, before)
				count += 1
			}
		}

		console.log(`${type}: ${lengths.length * 2} Node SIMD and tail cases passed`)

		for (const cpu of ['baseline', 'baseline+simd128']) {
			const path = build({ type, cpu })
			const host = createHost(path)

			try {
				for (const size of lengths) {
					const input = values({ size, special: false })
					const result = host.invoke(JSON.stringify(input))

					assert.equal(result.status, 0, result.result)
					check({ actual: JSON.parse(result.result), input, type, json: true })
					count += 1
				}
			} finally {
				host.api.zxc_deinit()
			}

			const assembly = readFileSync(`${path}.s`, 'utf8')

			checkAssembly({ assembly, type, cpu })

			console.log(`${type}/${cpu}: ${lengths.length} WASM cases passed`)
		}
	}

	const fallback = load(build({ type: 'fallback' }))

	for (const size of lengths) {
		const input = Array.from({ length: size }, (_, index) => (index % 19) - 9)

		assert.deepEqual(fallback(input), {
			incremented: input.map(value => value + 1),
			positive: input.filter(value => value > 0),
			total: input.reduce((total, value) => total + value, 0),
			nested: input.map(value => [value * 2, -value * 2].map(value => (value === 0 ? 0 : value)))
		})
		count += 1
	}

	console.log(`${count} SIMD semantics cases passed (${optimize})`)
} finally {
	rmSync(root, { recursive: true, force: true })
}
