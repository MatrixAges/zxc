import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { copyFileSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import Fixture, { stats } from './fixture.ts'

test('native object ABI executes across generation reuse and declaration reordering', () => {
	const fixture = new Fixture()

	try {
		for (const name of ['main.zx', 'bridge.d.zx', 'bridge.zig']) {
			copyFileSync(new URL(`../../build_modes/native_declarations/${name}`, import.meta.url), join(fixture.directory, name))
		}

		writeFileSync(join(fixture.directory, 'pkg.yaml'), stringify({
			name: 'native-cache-test',
			version: '0.0.0',
			native_interfaces: [{ specifier: 'zig:bridge', path: 'bridge.d.zx', module: 'bridge' }],
			native_modules: [{ name: 'bridge', path: 'bridge.zig' }]
		}))

		stats(fixture.build(), [3, 0, 0, 3, 0, 0])
		check(fixture)
		stats(fixture.build(), [0, 3, 3, 0, 0, 0])
		check(fixture)

		const path = join(fixture.directory, 'bridge.d.zx')
		const original = readFileSync(path, 'utf8')
		const enumeration = 'export enum Mode { Add, Keep }'
		const object = 'export type Item = { value: i32; };'

		assert.ok(original.startsWith(`${enumeration}\n\n${object}`))
		writeFileSync(path, original.replace(`${enumeration}\n\n${object}`, `${object}\n\n${enumeration}`))

		stats(fixture.build(), [1, 2, 2, 1, 0, 0])
		check(fixture)
		assert.match(fixture.build(['--no-cache']), /zxc generation: disabled/)
		check(fixture)
	} finally {
		fixture.close()
	}
})

function check(fixture: Fixture) {
	for (const size of [0, 2]) {
		for (const mode of [null, 'Add', 'Keep']) {
			const items = Array.from({ length: size }, (_, index) => ({ value: index * 7 - 12 }))
			const baseline = [{ value: 91 }]
			const result = run(fixture, { items, baseline, offset: 3, mode })

			assert.equal(result.status, 0, result.stderr)
			assert.deepEqual(JSON.parse(result.stdout), {
				items: items.map(item => ({ value: item.value + (mode === 'Add' ? 3 : 0) })),
				baseline,
				mode
			})
		}
	}

	const rejected = run(fixture, { items: [{ value: 1 }], baseline: [], offset: -1, mode: 'Add' })

	assert.notEqual(rejected.status, 0)
	assert.match(rejected.stderr, /NegativeOffset/)
	assert.equal(rejected.stdout, '')
}

function run(fixture: Fixture, input: unknown) {
	const result = spawnSync(fixture.application, [JSON.stringify(input)], { cwd: fixture.directory, encoding: 'utf8', timeout: 10_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null)

	return result
}
