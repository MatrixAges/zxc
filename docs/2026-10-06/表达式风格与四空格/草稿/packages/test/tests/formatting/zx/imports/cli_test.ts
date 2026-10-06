import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import cases from './cli_cases.ts'
import createFixture from './cli_fixture.ts'

for (const entry of cases) {
    for (const newline of ['\n', '\r\n']) {
        test(`ZX import order / ${entry.name} / ${newline === '\n' ? 'LF' : 'CRLF'}`, () => {
            const fixture = createFixture()

            try {
                const source = entry.source.replaceAll('\n', newline)
                const expected = entry.expected.replaceAll('\n', newline)
                const path = join(fixture.root, 'imports.zx')

                writeFileSync(path, source)
                writeFileSync(join(fixture.root, 'pkg.yaml'), 'malformed: [ project\n')

                const original_lint = fixture.run(['lint', 'imports.zx'])

                assert.equal(original_lint.status, source === expected ? 0 : 1, original_lint.stderr)
                assert.equal(original_lint.stdout, '')

                if (source !== expected)
                    assert.match(
                        original_lint.stderr,
                        /^imports\.zx:\d+:\d+: spacing: import order or blank lines do not match built-in rules; run zxc fmt\n$/
                    )
                else assert.equal(original_lint.stderr, '')

                const formatted = fixture.run(['fmt', 'imports.zx'])

                assert.equal(formatted.status, 0, formatted.stderr)
                assert.equal(formatted.stderr, '')
                assert.equal(formatted.stdout, expected)
                assert.equal(readFileSync(path, 'utf8'), source)

                const checked = fixture.run(['fmt', 'imports.zx', '--check'])

                assert.equal(checked.status, source === expected ? 0 : 1, checked.stderr)
                assert.equal(checked.stdout, '')

                if (source !== expected)
                    assert.match(checked.stderr, /import order, blank lines or indentation require formatting/)
                else assert.equal(checked.stderr, '')

                assert.equal(readFileSync(path, 'utf8'), source)

                const written = fixture.run(['fmt', 'imports.zx', '--write'])

                assert.equal(written.status, 0, written.stderr)
                assert.equal(written.stdout, '')
                assert.equal(readFileSync(path, 'utf8'), expected)

                const repeated = fixture.run(['fmt', 'imports.zx'])

                assert.equal(repeated.status, 0, repeated.stderr)
                assert.equal(repeated.stdout, expected)
                assert.equal(readFileSync(path, 'utf8'), expected)

                for (const argv of [
                    ['lint', 'imports.zx'],
                    ['fmt', 'imports.zx', '--check']
                ]) {
                    const clean = fixture.run(argv)

                    assert.equal(clean.status, 0, clean.stderr)
                    assert.equal(clean.stdout, '')
                    assert.equal(clean.stderr, '')
                    assert.equal(readFileSync(path, 'utf8'), expected)
                }
            } finally {
                fixture.cleanup()
            }
        })
    }
}
