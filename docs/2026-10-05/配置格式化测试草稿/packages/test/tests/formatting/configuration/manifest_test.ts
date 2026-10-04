import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import { parse } from 'yaml'
import rejected_cases from '../../package_manifest/inspect_cases.ts'
import cases from './manifest_cases.ts'
import createFixture from './fixture.ts'

for (const entry of cases) {
	for (const newline of ['\n', '\r\n']) {
		test(`manifest formatting / ${entry.name} / ${newline === '\n' ? 'LF' : 'CRLF'}`, () => {
			const fixture = createFixture()

			try {
				const file = entry.custom ? 'custom.yaml' : 'pkg.yaml'
				const selection = entry.custom ? ['--kind', 'manifest'] : []
				const source = entry.source.replaceAll('\n', newline)
				const expected = (entry.expected ?? entry.source).replaceAll('\n', newline)
				const path = join(fixture.root, file)
				writeFileSync(path, source)
				const formatted = fixture.run(['fmt', file, ...selection])
				assert.equal(formatted.status, 0, formatted.stderr)
				assert.equal(formatted.stderr, '')
				assert.equal(formatted.stdout, expected)
				assert.deepEqual(parse(formatted.stdout), parse(source))
				assert.equal(readFileSync(path, 'utf8'), source)

				for (const argv of [
					['fmt', file, ...selection, '--check'],
					['lint', file, ...selection]
				]) {
					const result = fixture.run(argv)
					assert.equal(result.status, source === expected ? 0 : 1, result.stderr)
					assert.equal(result.stdout, '')
					if (source !== expected) assert.match(result.stderr, /configuration formatting required/)
					assert.equal(readFileSync(path, 'utf8'), source)
				}
				const written = fixture.run(['fmt', file, ...selection, '--write'])
				assert.equal(written.status, 0, written.stderr)
				assert.equal(written.stdout, '')
				assert.equal(written.stderr, '')
				assert.equal(readFileSync(path, 'utf8'), expected)
				const repeated = fixture.run(['fmt', file, ...selection])
				assert.equal(repeated.status, 0, repeated.stderr)
				assert.equal(repeated.stdout, expected)
				for (const argv of [
					['lint', file, ...selection],
					['fmt', file, ...selection, '--check']
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
}

for (const entry of rejected_cases.filter(entry => entry.diagnostic !== undefined)) {
	for (const mode of [['fmt'], ['fmt', '--check'], ['fmt', '--write'], ['lint']]) {
		test(`manifest invalid input preserves file / ${entry.name} / ${mode}`, () => {
			const fixture = createFixture()

			try {
				const path = join(fixture.root, 'pkg.yaml')
				writeFileSync(path, entry.source)
				const result = fixture.run([mode[0], 'pkg.yaml', ...mode.slice(1)])
				const { line, column, message } = entry.diagnostic!
				assert.equal(result.status, 1, result.stderr)
				assert.equal(result.stderr, `pkg.yaml:${line}:${column}: manifest: ${message}\n`)
				assert.equal(result.stdout, '')
				assert.equal(readFileSync(path, 'utf8'), entry.source)
			} finally {
				fixture.cleanup()
			}
		})
	}
}
