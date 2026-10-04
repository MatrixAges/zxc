import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import cases from './index_cases.ts'
import createFixture from './fixture.ts'

for (const entry of cases) {
	test(`index formatting / ${entry.name}`, () => {
		const fixture = createFixture()

		try {
			const file = entry.file ?? 'registry.json'
			const path = join(fixture.root, file)
			writeFileSync(path, entry.source)

			if (entry.diagnostic) {
				for (const mode of [['fmt'], ['fmt', '--check'], ['fmt', '--write'], ['lint']]) {
					const result = fixture.run([mode[0], file, '--kind', 'index', ...mode.slice(1)])
					assert.equal(result.status, 1, result.stderr)
					assert.equal(result.stderr, `${file}: configuration: ${entry.diagnostic}\n`)
					assert.equal(result.stdout, '')
					assert.equal(readFileSync(path, 'utf8'), entry.source)
				}

				return
			}

			const expected = JSON.stringify(JSON.parse(entry.source), null, '\t') + '\n'
			const formatted = fixture.run(['fmt', file, '--kind', 'index'])
			assert.equal(formatted.status, 0, formatted.stderr)
			assert.equal(formatted.stdout, expected)
			assert.equal(formatted.stderr, '')
			assert.deepEqual(JSON.parse(formatted.stdout), JSON.parse(entry.source))
			assert.equal(readFileSync(path, 'utf8'), entry.source)

			for (const mode of [['fmt', '--check'], ['lint']]) {
				const checked = fixture.run([mode[0], file, '--kind', 'index', ...mode.slice(1)])
				assert.equal(checked.status, 1, checked.stderr)
				assert.match(checked.stderr, /configuration formatting required/)
				assert.equal(checked.stdout, '')
				assert.equal(readFileSync(path, 'utf8'), entry.source)
			}
			const written = fixture.run(['fmt', file, '--kind', 'index', '--write'])
			assert.equal(written.status, 0, written.stderr)
			assert.equal(written.stdout, '')
			assert.equal(written.stderr, '')
			assert.equal(readFileSync(path, 'utf8'), expected)
			const repeated = fixture.run(['fmt', file, '--kind', 'index'])
			assert.equal(repeated.status, 0, repeated.stderr)
			assert.equal(repeated.stdout, expected)
			for (const argv of [
				['lint', file, '--kind', 'index'],
				['fmt', file, '--kind', 'index', '--check']
			]) {
				const clean = fixture.run(argv)
				assert.equal(clean.status, 0, clean.stderr)
				assert.equal(clean.stdout, '')
				assert.equal(clean.stderr, '')
			}
		} finally {
			fixture.cleanup()
		}
	})
}

test('configuration kind must be explicit for an index and invalid choices preserve the file', () => {
	const fixture = createFixture()

	try {
		const source = '{"format_version":1,"packages":[]}'
		const path = join(fixture.root, 'registry.json')
		writeFileSync(path, source)

		for (const argv of [
			['fmt', 'registry.json', '--write'],
			['lint', 'registry.json'],
			['fmt', 'registry.json', '--kind', 'unknown', '--write'],
			['lint', 'registry.json', '--kind', 'index', '--write'],
			['fmt', 'registry.json', '--kind', 'index', '--kind', 'manifest']
		]) {
			const result = fixture.run(argv)
			assert.equal(result.status, 1, result.stderr)
			assert.notEqual(result.stderr, '')
			assert.equal(result.stdout, '')
			assert.equal(readFileSync(path, 'utf8'), source)
		}
	} finally {
		fixture.cleanup()
	}
})
