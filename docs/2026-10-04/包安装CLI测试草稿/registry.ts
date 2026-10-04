import { createHash } from 'node:crypto'
import { mkdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { gzipSync } from 'node:zlib'
import { stringify } from 'yaml'
import { tarArchive, tarEntry } from '../../src/shared/tar.ts'

export function source(increment: number, dependency?: string): string {
	return `${dependency ? `import dependency from "${dependency}";\n\n` : ''}export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return ${dependency ? 'dependency(in)' : 'in'} + ${increment};\n}\n`
}

export default function createRegistry(directory: string): string {
	mkdirSync(directory)
	const packages: Array<{ name: string, versions: Array<{ version: string, archive: string, sha256: string }> }> = []

	for (const entry of [
		{ name: 'core', version: '1.1.0', increment: 2 },
		{ name: 'core', version: '2.2.0', increment: 11 },
		{ name: 'calc', version: '1.0.0', increment: 3, dependency: '^1.0.0' },
		{ name: 'calc', version: '1.4.0', increment: 7, dependency: '^1.0.0' },
		{ name: 'calc', version: '2.0.0', increment: 13, dependency: '^2.0.0' },
	]) {
		const manifest = { name: entry.name, version: entry.version, entry: 'main.zx', dependencies: entry.dependency ? { core: entry.dependency } : undefined }
		const contents = gzipSync(tarArchive([
			tarEntry({ name: 'pkg.yaml', content: stringify(manifest) }),
			tarEntry({ name: 'main.zx', content: source(entry.increment, entry.dependency ? 'core' : undefined) }),
		]))
		const archive = `${entry.name}-${entry.version}.tgz`
		writeFileSync(join(directory, archive), contents)
		const release = { version: entry.version, archive, sha256: createHash('sha256').update(contents).digest('hex') }
		const previous = packages.find(package_entry => package_entry.name === entry.name)

		if (previous) previous.versions.push(release)
		else packages.push({ name: entry.name, versions: [release] })
	}

	const index = join(directory, 'index.json')
	writeFileSync(index, JSON.stringify({ format_version: 1, packages }))

	return index
}
