import assert from 'node:assert/strict'
import { mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import { parse, stringify } from 'yaml'
import writeArchive, { readDirectory } from './archive.ts'
import createFixture from './fixture.ts'

const suffix = process.platform === 'win32' ? '.exe' : ''

for (const aggregate of [false, true]) {
	test(`installed native packages / same module names with ${aggregate ? 'distinct object ABI' : 'scalar control'}`, () => {
		const fixture = createFixture(aggregate)

		try {
			fixture.run(['pkg', 'install', '--index', join(fixture.registry, 'index.json')])

			const output = join(fixture.root, 'application' + suffix)

			for (let round = 0; round < 2; round++) {
				rmSync(output, { force: true })
				fixture.run(['build', 'main.zx', '--out', output])
				fixture.execute(output)
			}
		} finally {
			fixture.cleanup()
		}
	})
}

for (const aggregate of [false, true]) {
	test(`installed native packages / republished ${aggregate ? 'object ABI' : 'scalar'} library is independently installable`, () => {
		const fixture = createFixture(aggregate)

		try {
			fixture.run(['pkg', 'install', '--index', join(fixture.registry, 'index.json')])

			const library = join(fixture.root, 'library')

			fixture.run(['build', 'main.zx', '--mode', 'lib', '--out', library])

			const manifest: { name: string, version: string } = parse(readFileSync(join(library, 'pkg.yaml'), 'utf8'))

			assert.equal(manifest.name, 'combined')

			const registry = join(fixture.root, 'published')

			mkdirSync(registry)

			const release = writeArchive(join(registry, 'combined.tgz'), readDirectory(library))

			writeFileSync(join(registry, 'index.json'), JSON.stringify({ format_version: 1, packages: [{ name: manifest.name, versions: [{ version: manifest.version, ...release }] }] }))

			const consumer = join(fixture.root, 'consumer')

			mkdirSync(consumer)
			writeFileSync(join(consumer, 'pkg.yaml'), stringify({ name: 'consumer', version: '1.0.0', dependencies: { combined: manifest.version } }))
			writeFileSync(join(consumer, 'main.zx'), 'import combined from "combined"\n\nexport type Input = i32\n\nexport type Output = { left: i32\n right: i32 }\n\nexport default function (in: Input): Output {\n  return combined(in)\n}\n')
			rmSync(fixture.project, { recursive: true })
			rmSync(library, { recursive: true })
			rmSync(fixture.registry, { recursive: true })
			rmSync(join(fixture.root, 'cache/packages'), { recursive: true })
			fixture.run(['pkg', 'install', '--index', join(registry, 'index.json')], consumer)

			const output = join(fixture.root, 'consumer-app' + suffix)

			fixture.run(['build', 'main.zx', '--out', output], consumer)
			fixture.execute(output)
		} finally {
			fixture.cleanup()
		}
	})
}
