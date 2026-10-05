import assert from 'node:assert/strict'
import { test } from 'node:test'
import createFixture from './fixture.ts'

for (const argv of [
	['lint', 'main.zx', '--semantic', '--semantic'],
	['lint', 'main.zx', '--project', 'pkg.yaml'],
	['lint', 'main.zx', '--semantic', '--kind', 'manifest'],
	['fmt', 'main.zx', '--semantic'],
	['lint', 'main.zx', '--semantic', '--out', 'output']
]) {
	test(`semantic lint / invalid options / ${argv.join(' ')}`, () => {
		const fixture = createFixture({ 'main.zx': '', 'pkg.yaml': 'name: options\nversion: 1.0.0\n' })

		try {
			const result = fixture.run(argv)
			assert.notEqual(result.status, 0)
			assert.match(result.stderr, /zxc lint <source/)
		} finally {
			fixture.cleanup()
		}
	})
}
