import assert from 'node:assert/strict'
import { rmSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture, { public_exports, snapshot } from './fixture.ts'

const cases = [
	{ name: 'missing public source', source: undefined, diagnostic: /FileNotFound/ },
	{ name: 'invalid unreferenced public source', source: 'invalid source\n', diagnostic: /broken\.zx/ },
	{
		name: 'false contract on a public module',
		source: 'export type Input = u8\n\nexport type Output = u8\n\nexport default function (in: Input): Output ensures(out == in) {\n  return 0\n}\n',
		diagnostic: /verification did not succeed/
	}
]

test('failed unified public updates preserve every previously published file', async context => {
	const fixture = createFixture()

	try {
		const initial = fixture.publish()
		assert.equal(initial.status, 0, initial.stderr)
		const previous = snapshot(fixture.published)

		for (const entry of cases) {
			await context.test(entry.name, () => {
				fixture.manifest({ ...public_exports, './broken': 'broken.zx' })
				const path = join(fixture.source, 'broken.zx')

				if (entry.source === undefined) rmSync(path, { force: true })
				else writeFileSync(path, entry.source)

				const rejected = fixture.publish()
				assert.equal(rejected.status, 1, rejected.stderr)
				assert.match(rejected.stderr, entry.diagnostic)
				assert.deepEqual(snapshot(fixture.published), previous)
			})
		}
	} finally {
		fixture.cleanup()
	}
})
