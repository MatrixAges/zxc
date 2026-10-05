import assert from 'node:assert/strict'
import { existsSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

export type Build = (args: { source: string; output: string; extra?: Array<string>; failure?: string }) => void

export default function checkPublication(args: { build: Build; project: string; root: string }): number {
	const { build, project, root } = args
	const paths = ['addon.node', 'addon.cjs', 'addon.d.cts'].map(name => join(root, name))
	const snapshots = paths.map(path => readFileSync(path))
	const source = join(project, 'record.zx')
	const original = readFileSync(source)

	writeFileSync(source, 'export default function broken(')
	build({ source: 'record.zx', output: paths[0], failure: 'syntax:' })
	paths.forEach((path, index) => assert.deepEqual(readFileSync(path), snapshots[index]))
	writeFileSync(source, original)

	for (const index of [1, 2]) {
		const sentinel = Buffer.from('user owned file\n')

		writeFileSync(paths[index], sentinel)
		build({ source: 'record.zx', output: paths[0], failure: 'NodeBindingWouldOverwriteFile' })
		paths.forEach((path, position) =>
			assert.deepEqual(readFileSync(path), position === index ? sentinel : snapshots[position])
		)
		writeFileSync(paths[index], snapshots[index])
	}

	for (const path of paths.slice(1)) {
		build({ source: 'record.zx', output: paths[0], extra: ['--asm', path], failure: 'ConflictingOutputPaths' })
		paths.forEach((path, index) => assert.deepEqual(readFileSync(path), snapshots[index]))
	}

	const invalid = join(root, 'wrong.bin')

	build({ source: 'record.zx', output: invalid, failure: 'NodeAddonExtensionRequired' })
	assert.equal(existsSync(invalid), false)
	build({ source: 'record.zx', output: paths[0] })
	assert.deepEqual(readFileSync(paths[1]), snapshots[1])
	assert.deepEqual(readFileSync(paths[2]), snapshots[2])

	writeFileSync(source, readFileSync(join(project, 'scalars/void.zx')))
	build({ source: 'record.zx', output: paths[0] })
	assert.ok(readFileSync(paths[2], 'utf8').includes('export function execute()'))
	assert.notDeepEqual(readFileSync(paths[0]), snapshots[0])

	return 8
}
