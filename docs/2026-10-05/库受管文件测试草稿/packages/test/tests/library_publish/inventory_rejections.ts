import type { TestContext } from 'node:test'
import type createFixture from './fixture.ts'
import type { File } from './inventory.ts'
import assert from 'node:assert/strict'
import { cpSync, lstatSync, mkdirSync, readFileSync, readlinkSync, rmSync, symlinkSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { snapshot } from './fixture.ts'
import readInventory from './inventory.ts'

export default async function rejectMutations(args: {
	context: TestContext
	fixture: ReturnType<typeof createFixture>
	baseline: string
	retired: Array<File>
}): Promise<void> {
	const { context, fixture, baseline, retired } = args
	const obsolete = retired.find(file => file.path.startsWith('public/'))
	assert.ok(obsolete)
	const output = fixture.published
	const target = join(output, obsolete.path)
	const metadata_path = join(output, 'library.json')
	const outside = join(fixture.root, 'outside')
	mkdirSync(outside)
	writeFileSync(join(outside, 'keep.zig'), 'external user file\n')
	const external_bytes = snapshot(outside)

	for (const mode of [
		'modified file',
		'directory',
		'file symlink',
		'parent symlink',
		'outside path',
		'unmanaged path',
		'version',
		'malformed'
	]) {
		await context.test(mode, () => {
			rmSync(output, { recursive: true })
			cpSync(baseline, output, { recursive: true })
			const metadata = readInventory(output)
			let diagnostic = /InvalidLibraryInventory/
			let link: string | undefined

			if (mode === 'modified file') {
				writeFileSync(target, 'user modified generated file\n')
				diagnostic = /LibraryResourceModified/
			} else if (mode === 'directory') {
				rmSync(target)
				mkdirSync(target)
				writeFileSync(join(target, 'keep.txt'), 'directory payload\n')
				diagnostic = /LibraryResourceModified/
			} else if (mode === 'file symlink') {
				rmSync(target)
				symlinkSync(join(outside, 'keep.zig'), target)
				link = target
				diagnostic = /LibraryResourceModified/
			} else if (mode === 'parent symlink') {
				const parent = dirname(target)
				const external_parent = join(outside, 'public')
				cpSync(parent, external_parent, { recursive: true })
				rmSync(parent, { recursive: true })
				symlinkSync(external_parent, parent)
				link = parent
				diagnostic = /LibraryResourceOutsideOutput/
			} else if (mode === 'outside path' || mode === 'unmanaged path') {
				metadata.managed_files!.push({
					path: mode === 'outside path' ? '../outside/keep.zig' : 'keep.txt',
					sha256: obsolete.sha256
				})
				writeFileSync(metadata_path, JSON.stringify(metadata))
			} else if (mode === 'version') {
				metadata.format_version = 99
				writeFileSync(metadata_path, JSON.stringify(metadata))
			} else {
				writeFileSync(metadata_path, '{broken json')
				diagnostic = /SyntaxError/
			}
			const before = snapshot(output)
			const external_before = snapshot(outside)
			const link_target = link === undefined ? undefined : readlinkSync(link)
			const result = fixture.publish()
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, diagnostic)
			assert.deepEqual(snapshot(output), before)
			assert.deepEqual(snapshot(outside), external_before)

			if (link !== undefined) assert.equal(readlinkSync(link), link_target)
			if (mode === 'directory') assert.equal(lstatSync(target).isDirectory(), true)
			if (mode === 'parent symlink') rmSync(join(outside, 'public'), { recursive: true })
			assert.deepEqual(snapshot(outside), external_bytes)
			assert.equal(readFileSync(join(output, 'keep.txt'), 'utf8'), 'unmanaged root file\n')
		})
	}
}
