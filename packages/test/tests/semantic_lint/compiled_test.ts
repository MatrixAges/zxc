import assert from 'node:assert/strict'
import { test } from 'node:test'
import { parseDocument } from 'yaml'
import createFixture from './fixture.ts'
import publishLibrary, { identity } from './compiled_fixture.ts'

const archive = publishLibrary()
const consumer = {
	...archive,
	'pkg.yaml': `name: consumer
version: 1.0.0
entry: main.zx

workspace:
    packages: ['pkgs/*']

dependencies:
    bundle: workspace:*
`,
	'main.zx': `import run from "bundle"\n\n${identity.replace('return in', 'return run(in)')}`,
	'main.rx': `<Module>
  <Call module="bundle/flow" in={$in} out="ctx.result" />

  <Return value={ctx.result} />
</Module>
`
}

for (const argv of [
	['lint', 'main.zx', '--semantic'],
	['lint', 'main.rx', '--semantic'],
	['lint', 'pkg.yaml', '--semantic'],
	['lint', 'pkgs/bundle/pkg.yaml', '--semantic'],
	['lint', 'pkg.yaml', '--workspace']
]) {
	test(`compiled semantic lint / no original sources / ${argv.join(' ')}`, () => {
		const fixture = createFixture(consumer)

		try {
			const result = fixture.run(argv)
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
		} finally {
			fixture.cleanup()
		}
	})
}

for (const input of ['main.zx', 'pkg.yaml']) {
	test(`compiled semantic lint / dependency input type / ${input}`, () => {
		const fixture = createFixture({ ...consumer, 'main.zx': consumer['main.zx'].replace('run(in)', 'run(true)') })

		try {
			const result = fixture.run(['lint', input, '--semantic'])
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, /type|Type/)
		} finally {
			fixture.cleanup()
		}
	})
}

for (const mode of ['damaged digest', 'missing public module']) {
	for (const input of ['main.zx', 'pkgs/bundle/pkg.yaml', 'workspace']) {
		test(`compiled semantic lint / ${mode} / ${input}`, () => {
			const changed = { ...consumer }

			if (mode === 'damaged digest') {
				const bytes = Buffer.from(archive['pkgs/bundle/library.zxcir'])
				const offset = bytes.indexOf(10) + 1
				assert.ok(offset > 0 && offset < bytes.length)
				bytes[offset] = bytes[offset] === 48 ? 49 : 48
				changed['pkgs/bundle/library.zxcir'] = bytes
			} else {
				const manifest = parseDocument(archive['pkgs/bundle/pkg.yaml'])
				manifest.setIn(['exports', '.', 'module'], './missing')
				changed['pkgs/bundle/pkg.yaml'] = manifest.toString()
			}

			const fixture = createFixture(changed)

			try {
				const argv = input === 'workspace' ? ['lint', 'pkg.yaml', '--workspace'] : ['lint', input, '--semantic']
				const result = fixture.run(argv)
				assert.equal(result.status, 1, result.stderr)
				assert.match(
					result.stderr,
					mode === 'damaged digest' ? /InvalidLibrary/ : /MissingPublicModule|not found|missing/
				)
			} finally {
				fixture.cleanup()
			}
		})
	}
}

for (const valid of [true, false]) {
	test(`compiled semantic lint / explicit source has independent status / ${valid}`, () => {
		const fixture = createFixture({
			...consumer,
			'pkgs/bundle/selected.zx': valid ? identity : identity.replace('return in', 'return true')
		})

		try {
			const manifest = fixture.run(['lint', 'pkgs/bundle/pkg.yaml', '--semantic'])
			assert.equal(manifest.status, 0, manifest.stderr)

			const source = fixture.run(['lint', 'pkgs/bundle/selected.zx', '--semantic'])
			assert.equal(source.status, valid ? 0 : 1, source.stderr)
			if (!valid) assert.match(source.stderr, /type|Type/)
		} finally {
			fixture.cleanup()
		}
	})
}

test('compiled semantic lint / explicit source does not consume its package archive', () => {
	const fixture = createFixture({
		...consumer,
		'pkgs/bundle/library.zxcir': new Uint8Array(),
		'pkgs/bundle/selected.zx': identity
	})

	try {
		const source = fixture.run(['lint', 'pkgs/bundle/selected.zx', '--semantic'])
		assert.equal(source.status, 0, source.stderr)

		const manifest = fixture.run(['lint', 'pkgs/bundle/pkg.yaml', '--semantic'])
		assert.equal(manifest.status, 1, manifest.stderr)
		assert.match(manifest.stderr, /InvalidLibrary/)
	} finally {
		fixture.cleanup()
	}
})
