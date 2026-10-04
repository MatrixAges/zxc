import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { parse } from 'yaml'

type Metadata = {
	native_sources_bundled: boolean
	bundled_files: Array<{ path: string; kind: string; sha256: string }>
}
type Manifest = { native_modules: Array<{ name: string; abi_aliases: Array<{ name: string; specifier: string }> }> }

export default function checkResources(directory: string): Array<string> {
	const metadata = JSON.parse(readFileSync(join(directory, 'library.json'), 'utf8')) as Metadata
	const manifest = parse(readFileSync(join(directory, 'pkg.yaml'), 'utf8')) as Manifest
	assert.equal(metadata.native_sources_bundled, true)
	assert.equal(metadata.bundled_files.length, 6)
	assert.equal(new Set(metadata.bundled_files.map(file => file.path)).size, 6)
	assert.equal(manifest.native_modules.length, 2)
	assert.equal(new Set(manifest.native_modules.map(module => module.name)).size, 2)
	const aliases = manifest.native_modules.map(module => module.abi_aliases.find(alias => alias.name === 'zig:bridge'))
	assert.ok(aliases.every(alias => alias !== undefined))
	assert.equal(new Set(aliases.map(alias => alias?.specifier)).size, 2)

	for (const file of metadata.bundled_files) {
		const content = readFileSync(join(directory, file.path))
		assert.equal(createHash('sha256').update(content).digest('hex'), file.sha256)
	}

	const assets = metadata.bundled_files.filter(file => file.kind === 'asset').map(file => file.path)
	assert.equal(assets.length, 2)
	assert.deepEqual(assets.map(path => readFileSync(join(directory, path), 'utf8')).sort(), ['abc', 'abcdefghijk'])

	return assets
}
