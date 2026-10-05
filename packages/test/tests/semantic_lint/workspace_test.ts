import assert from 'node:assert/strict'
import { symlinkSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import files from './workspace_cases.ts'
import createFixture from './fixture.ts'

for (const semantic of [false, true]) {
	test(`workspace lint / declared scope / explicit semantic ${semantic}`, () => {
		const fixture = createFixture(files)

		try {
			const result = fixture.run(['lint', 'pkg.yaml', '--workspace', ...(semantic ? ['--semantic'] : [])])
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
		} finally {
			fixture.cleanup()
		}
	})
}

test('workspace lint / independent member errors accumulate', () => {
	const fixture = createFixture({
		...files,
		'packages/app/main.zx': files['packages/app/main.zx'].replace('return numbers(in)', 'return true'),
		'packages/other/main.zx': files['packages/other/main.zx'].replace('return in', 'return true')
	})

	try {
		const result = fixture.run(['lint', 'pkg.yaml', '--workspace'])
		assert.equal(result.status, 1, result.stderr)
		assert.match(result.stderr, /packages[/\\]app[/\\]main.zx/)
		assert.match(result.stderr, /packages[/\\]other[/\\]main.zx/)
		assert.match(result.stderr, /type|Type/)
	} finally {
		fixture.cleanup()
	}
})

for (const entry of [
	{
		name: 'duplicate package name',
		path: 'packages/other/pkg.yaml',
		source: files['packages/other/pkg.yaml'].replace('lint-other', 'lint-numbers'),
		diagnostic: /duplicate/i
	},
	{
		name: 'missing workspace dependency',
		path: 'packages/app/pkg.yaml',
		source: files['packages/app/pkg.yaml'].replace('lint-numbers', 'absent'),
		diagnostic: /dependency absent: workspace dependency has no matching local package/
	},
	{
		name: 'dependency cycle',
		path: 'packages/numbers/pkg.yaml',
		source: `${files['packages/numbers/pkg.yaml']}\ndependencies:\n    lint-app: workspace:*\n`,
		diagnostic: /cycl/i
	},
	{
		name: 'missing entry',
		path: 'packages/other/pkg.yaml',
		source: files['packages/other/pkg.yaml'].replace('main.zx', 'absent.zx'),
		diagnostic: /FileNotFound|not found|missing/i
	},
	{
		name: 'uninstalled external',
		path: 'packages/other/pkg.yaml',
		source: `${files['packages/other/pkg.yaml']}\ndependencies:\n    external: ^1.0.0\n`,
		diagnostic: /dependency external: external dependency is not installed/
	},
	{
		name: 'organization formatting',
		path: 'packages/organization/pkg.yaml',
		source: 'name: organization\nversion: 1.0.0\n\nprivate: true\n',
		diagnostic: /format/i
	}
]) {
	test(`workspace lint / rejects ${entry.name}`, () => {
		const fixture = createFixture({ ...files, [entry.path]: entry.source })

		try {
			const result = fixture.run(['lint', 'pkg.yaml', '--workspace'])
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, entry.diagnostic)
		} finally {
			fixture.cleanup()
		}
	})
}

test('workspace lint / root manifest directory symlink', () => {
	const fixture = createFixture(files)

	try {
		symlinkSync(fixture.root, join(fixture.root, 'alias'), 'dir')
		const result = fixture.run(['lint', 'alias/pkg.yaml', '--workspace'])
		assert.equal(result.status, 0, result.stderr)
		assert.equal(result.stderr, '')
	} finally {
		fixture.cleanup()
	}
})

for (const argv of [
	['lint', 'pkg.yaml', '--workspace', '--workspace'],
	['lint', 'pkg.yaml', '--workspace', '--project', 'pkg.yaml'],
	['lint', 'pkg.yaml', '--workspace', '--kind', 'manifest'],
	['fmt', 'pkg.yaml', '--workspace']
]) {
	test(`workspace lint / invalid options / ${argv.join(' ')}`, () => {
		const fixture = createFixture(files)

		try {
			const result = fixture.run(argv)
			assert.notEqual(result.status, 0)
			assert.match(result.stderr, /zxc lint <source/)
		} finally {
			fixture.cleanup()
		}
	})
}

test('workspace lint / source input rejected', () => {
	const fixture = createFixture(files)

	try {
		const result = fixture.run(['lint', 'packages/app/main.zx', '--workspace'])
		assert.equal(result.status, 1, result.stderr)
		assert.match(result.stderr, /WorkspaceManifestRequired/)
	} finally {
		fixture.cleanup()
	}
})
