import type createFixture from './fixture.ts'
import assert from 'node:assert/strict'
import { cpSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { zig } from './fixture.ts'

type Module = { name: string; path: string; dependencies: Array<string> }
type Initializer = { identity: string; schema_version: number; module_name: string; type_name: string }
type Metadata = {
	generated_modules: Array<Module>
	public_modules: Array<Module>
	store_initializers: Array<Initializer>
}

export default function consume(args: {
	fixture: ReturnType<typeof createFixture>
	library: string
	inputs: string
	host: boolean
	name: string
}): Array<string> {
	const { fixture, library, inputs, host, name } = args
	const metadata = JSON.parse(readFileSync(join(library, 'library.json'), 'utf8')) as Metadata
	assert.equal(metadata.store_initializers.length, 2)
	assert.equal(new Set(metadata.store_initializers.map(initial => initial.identity)).size, 2)
	const directory = join(fixture.root, name)
	mkdirSync(directory)
	cpSync(join(inputs, 'consumer'), directory, { recursive: true })
	const initializers = ['counter', 'settings'].map(object => {
		const initial = metadata.store_initializers.find(value => value.identity.endsWith(':' + object))
		assert.ok(initial)
		assert.equal(initial.schema_version, 7)
		assert.equal(metadata.generated_modules.filter(module => module.name === initial.module_name).length, 1)
		return { ...initial, object }
	})
	writeFileSync(
		join(directory, 'bindings.zig'),
		initializers
			.map(
				initial =>
					`pub const ${initial.object === 'counter' ? 'Counter' : 'Settings'} = @field(@import("zxc_abi"), ${JSON.stringify(initial.type_name)});`
			)
			.join('\n') + '\n'
	)
	const dependencies = [
		'--dep',
		'zxc_abi',
		...initializers.flatMap(initial => ['--dep', `${initial.object}_initial=${initial.module_name}`])
	]
	const modules = [...metadata.generated_modules]

	if (host) {
		for (const name of ['advance', 'again', 'read', 'settings']) {
			const entry = metadata.public_modules.find(module => module.name === './' + name)
			assert.ok(entry)
			dependencies.push('--dep', name)
			modules.push({ ...entry, name })
		}
	}

	const mappings = modules.flatMap(module => [
		'--dep',
		'zxc_abi',
		...module.dependencies.flatMap(name => ['--dep', name]),
		`-M${module.name}=${join(library, module.path)}`
	])
	for (const file of host ? ['initial_test.zig', 'host_test.zig'] : ['initial_test.zig']) {
		const result = fixture.run({
			command: zig,
			cwd: directory,
			argv: [
				'test',
				...dependencies,
				'--dep',
				'allocation_testing',
				`-Mroot=${file}`,
				...mappings,
				`-Mzxc_abi=${join(library, 'abi.zig')}`,
				`-Mallocation_testing=${fileURLToPath(new URL('../support/allocation_testing.zig', import.meta.url))}`
			]
		})
		assert.equal(result.status, 0, result.stderr)
		assert.match(result.stderr, /All 3 tests passed/)
	}

	return initializers.map(initial => initial.identity)
}
