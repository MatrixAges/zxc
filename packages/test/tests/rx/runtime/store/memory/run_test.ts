import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { test } from 'node:test'

type Module = { name: string; imports: Array<string> }

const [zig, output_dir, source, standard_root, fixture_source] = process.argv.slice(2)
const directory = resolve(output_dir)
const optimize = process.env.ZXC_TEST_OPTIMIZE ?? 'Debug'

assert.ok(['debug', 'safe', 'fast', 'small', 'Debug', 'ReleaseSafe', 'ReleaseFast', 'ReleaseSmall'].includes(optimize))

test(`generated Store memory consumer ${source} (${optimize})`, () => {
	const modules = JSON.parse(readFileSync(join(directory, 'modules.json'), 'utf8')) as Array<Module>
	const by_name = new Map(modules.map(module => [module.name, module]))
	const needed = new Set<string>()
	const pending = ['application', 'zxc_state']

	while (pending.length) {
		const name = pending.pop()!

		if (needed.has(name) || (standard_root && name === 'zxc_standard')) continue

		const module = by_name.get(name)

		assert.ok(module, `missing generated module ${name}`)
		needed.add(name)
		pending.push(...module.imports)
	}

	const argv = [
		'test',
		`-O${optimize}`,
		'--dep',
		'application',
		'--dep',
		'zxc_state',
		'--dep',
		'allocation_testing',
		...(fixture_source ? ['--dep', 'fixture'] : []),
		`-Mroot=${resolve(source)}`
	]

	for (const module of modules) {
		if (!needed.has(module.name)) continue

		argv.push(
			`-O${optimize}`,
			'--dep',
			'zxc_abi',
			...module.imports.flatMap(name => ['--dep', name]),
			`-M${module.name}=${join(directory, module.name + '.zig')}`
		)
	}

	if (standard_root) {
		argv.push(`-O${optimize}`, '--dep', 'zxc_abi', `-Mzxc_standard=${resolve(standard_root)}`)
	}

	if (fixture_source) {
		argv.push(`-O${optimize}`, '--dep', 'standard=zxc_standard', `-Mfixture=${resolve(fixture_source)}`)
	}

	argv.push(`-O${optimize}`, `-Mzxc_abi=${join(directory, 'types.zig')}`)
	argv.push(
		`-O${optimize}`,
		`-Mallocation_testing=${fileURLToPath(new URL('../../../../support/allocation_testing.zig', import.meta.url))}`
	)

	const result = spawnSync(zig, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

	process.stdout.write(result.stdout ?? '')
	process.stderr.write(result.stderr ?? '')
	assert.ifError(result.error)
	assert.equal(result.signal, null)
	assert.equal(result.status, 0)
})
