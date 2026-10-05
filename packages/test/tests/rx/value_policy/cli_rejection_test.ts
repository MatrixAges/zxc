import assert from 'node:assert/strict'
import { existsSync, readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import fixture from './cli_fixture.ts'

const cases = JSON.parse(readFileSync(join(import.meta.dirname, 'rejections.json'), 'utf8')) as Array<{
	name: string
	source: string
	marker: string
	store_source?: string
}>
const message = 'RX values cannot contain calls or callbacks; move logic to ZX and use Call.fn or Call.module'

for (const entry of cases) {
	test(`RX CLI rejects ${entry.name} without producing an application`, () => {
		const current = fixture()
		const source = join(current.directory, 'main.rx')
		const application = join(current.directory, process.platform === 'win32' ? 'application.exe' : 'application')

		try {
			writeFileSync(source, entry.source)

			if (entry.store_source) writeFileSync(join(current.directory, 'state.store.rx'), entry.store_source)

			const result = current.build('main.rx', application)

			assert.equal(result.status, 1, result.stderr)
			assert.ok(result.stderr.includes(message), result.stderr)
			assert.ok(result.stderr.includes('unsupported'), result.stderr)
			assert.equal(result.stdout, '')
			assert.equal(existsSync(application), false)
			assert.equal(readFileSync(source, 'utf8'), entry.source)
			if (entry.store_source)
				assert.equal(readFileSync(join(current.directory, 'state.store.rx'), 'utf8'), entry.store_source)
		} finally {
			current.cleanup()
		}
	})
}
