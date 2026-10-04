import assert from 'node:assert/strict'
import { cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { test } from 'node:test'
import createFixture, { snapshot, solver } from './fixture.ts'
import readInventory, { checkInventory } from './inventory.ts'
import rejectMutations from './inventory_rejections.ts'

test('managed inventory retires exact old outputs and protects unknown or unsafe files', async context => {
	const fixture = createFixture()

	try {
		const initial = fixture.publish()
		assert.equal(initial.status, 0, initial.stderr)
		const old_files = checkInventory(fixture.published)
		const baseline = join(fixture.root, 'baseline')
		const own_files = ['keep.txt', 'public/manual.zig', 'modules/manual.zig', 'interfaces/manual.d.zx']

		for (const path of own_files) {
			mkdirSync(dirname(join(fixture.published, path)), { recursive: true })
			writeFileSync(
				join(fixture.published, path),
				path === 'keep.txt' ? 'unmanaged root file\n' : `user file ${path}\n`
			)
		}
		cpSync(fixture.published, baseline, { recursive: true })
		fixture.manifest({ './types': 'types.zx' })
		const candidate = join(fixture.root, 'candidate')
		const generated = fixture.run({
			argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', candidate, '--solver', solver]
		})
		assert.equal(generated.status, 0, generated.stderr)
		const new_files = checkInventory(candidate)
		const new_paths = new Set(new_files.map(file => file.path))
		const retired = old_files.filter(file => !new_paths.has(file.path))
		assert.ok(retired.some(file => file.path.startsWith('public/')))
		assert.ok(retired.some(file => file.path.startsWith('modules/')))

		await rejectMutations({ context, fixture, baseline, retired })

		for (const mode of ['managed', 'missing retired file', 'legacy without managed list']) {
			await context.test(mode, () => {
				rmSync(fixture.published, { recursive: true })
				cpSync(baseline, fixture.published, { recursive: true })
				const metadata = readInventory(fixture.published)

				if (mode === 'missing retired file') rmSync(join(fixture.published, retired[0].path))
				if (mode === 'legacy without managed list') delete metadata.managed_files
				else for (const file of metadata.managed_files!) file.sha256 = file.sha256.toUpperCase()
				writeFileSync(join(fixture.published, 'library.json'), JSON.stringify(metadata))
				const result = fixture.publish()
				assert.equal(result.status, 0, result.stderr)

				for (const file of retired)
					assert.equal(
						existsSync(join(fixture.published, file.path)),
						mode === 'legacy without managed list',
						file.path
					)
				for (const path of own_files)
					assert.deepEqual(readFileSync(join(fixture.published, path)), readFileSync(join(baseline, path)))
				assert.deepEqual(readInventory(fixture.published), readInventory(candidate))
				const current = snapshot(fixture.published)
				for (const [path, value] of Object.entries(snapshot(candidate)))
					assert.equal(current[path], value, path)
			})
		}
	} finally {
		fixture.cleanup()
	}
})
