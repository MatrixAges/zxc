import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

type Native = { import_name: string }

type Module = { name: string; path?: string; imports: Array<string> }

const [zig, output_dir, source, native_host] = process.argv.slice(2)
const directory = resolve(output_dir)

test(`unified library runtime consumer ${source}`, () => {
	const modules = JSON.parse(readFileSync(join(directory, 'modules.json'), 'utf8')) as Array<Module>
	const native_modules = native_host
		? (JSON.parse(readFileSync(join(directory, 'native.json'), 'utf8')) as Array<Native>)
		: []
	if (native_host) assert.equal(native_modules.length, 1)

	const native_names = new Set(native_modules.map(module => module.import_name))
	const by_name = new Map(modules.map(module => [module.name, module]))
	const needed = new Set<string>()
	const pending = ['alpha', 'beta', 'repeat']

	while (pending.length) {
		const name = pending.pop()!

		if (needed.has(name) || native_names.has(name)) continue

		const module = by_name.get(name)

		assert.ok(module, `missing generated module ${name}`)
		needed.add(name)
		pending.push(...module.imports)
	}

	const argv = [
		'test',
		...(native_host ? ['--dep', `host=${native_modules[0].import_name}`] : []),
		'--dep',
		'alpha',
		'--dep',
		'beta',
		'--dep',
		'repeat',
		`-Mroot=${resolve(source)}`
	]

	for (const module of modules) {
		if (!needed.has(module.name)) continue

		argv.push(
			'--dep',
			'zxc_abi',
			...module.imports.flatMap(name => ['--dep', name]),
			`-M${module.name}=${join(directory, module.path ?? module.name + '.zig')}`
		)
	}

	if (native_host) {
		argv.push('--dep', 'zxc_abi', `-M${native_modules[0].import_name}=${resolve(native_host)}`)
	}

	argv.push(`-Mzxc_abi=${join(directory, 'types.zig')}`)

	const result = spawnSync(zig, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

	process.stdout.write(result.stdout ?? '')
	process.stderr.write(result.stderr ?? '')
	assert.ifError(result.error)
	assert.equal(result.signal, null)
	assert.equal(result.status, 0)
})
