import assert from 'node:assert/strict'
import { test } from 'node:test'
import files from './rx_cases.ts'
import createFixture from './fixture.ts'

for (const input of ['main.gateway.rx', 'empty.gateway.rx', 'state.store.rx', 'read.rx', 'pkg.yaml']) {
	test(`semantic lint / RX valid / ${input}`, () => {
		const fixture = createFixture(files)

		try {
			const result = fixture.run(['lint', input, '--semantic'])
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
		} finally {
			fixture.cleanup()
		}
	})
}

for (const input of ['state.store.rx', 'read.rx', 'main.gateway.rx', 'pkg.yaml']) {
	test(`semantic lint / Store initial type / ${input}`, () => {
		const fixture = createFixture({
			...files,
			'state.store.rx': files['state.store.rx'].replace('value="3"', 'value="true"')
		})

		try {
			const ordinary = fixture.run(['lint', 'state.store.rx'])
			assert.equal(ordinary.status, 0, ordinary.stderr)

			const result = fixture.run(['lint', input, '--semantic'])
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, /type|Type/)
		} finally {
			fixture.cleanup()
		}
	})
}

for (const entry of [
	{
		name: 'missing service',
		file: 'main.gateway.rx',
		source: files['main.gateway.rx'].replace('service="read"', 'service="absent"'),
		diagnostic: /FileNotFound|not found|missing/i
	},
	{
		name: 'duplicate route',
		file: 'main.gateway.rx',
		source: files['main.gateway.rx'].replace(
			'</Gateway>',
			'  <Route method="GET" path="/read" service="read" />\n</Gateway>'
		),
		diagnostic: /routes overlap/i
	},
	{
		name: 'service type',
		file: 'read.zx',
		source: files['read.zx'].replace('return in', 'return true'),
		diagnostic: /type|Type/
	}
]) {
	test(`semantic lint / Gateway rejects ${entry.name}`, () => {
		const fixture = createFixture({ ...files, [entry.file]: entry.source })

		try {
			const result = fixture.run(['lint', 'main.gateway.rx', '--semantic'])
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, entry.diagnostic)
		} finally {
			fixture.cleanup()
		}
	})
}

for (const input of ['state.store.rx', 'read.rx', 'main.gateway.rx', 'pkg.yaml']) {
	test(`semantic lint / reachable Store formatting / ${input}`, () => {
		const fixture = createFixture({ ...files, 'state.store.rx': files['state.store.rx'].replace('\n', '\n\n') })

		try {
			const result = fixture.run(['lint', input, '--semantic'])
			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, /format|blank/i)
			assert.match(result.stderr, /state\.store\.rx/)
		} finally {
			fixture.cleanup()
		}
	})
}

for (const input of ['state.store.rx', 'empty.gateway.rx']) {
	test(`semantic lint / dedicated manifest entry / ${input}`, () => {
		const fixture = createFixture({ ...files, 'pkg.yaml': files['pkg.yaml'].replace('main.gateway.rx', input) })

		try {
			const result = fixture.run(['lint', 'pkg.yaml', '--semantic'])
			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
		} finally {
			fixture.cleanup()
		}
	})
}
