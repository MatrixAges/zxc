import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import cases from './cases.ts'
import createFixture from './fixture.ts'

for (const entry of cases) {
    for (const newline of ['\n', '\r\n']) {
        test(`RX fmt ${entry.name} / ${newline === '\n' ? 'LF' : 'CRLF'}`, () => {
            const fixture = createFixture()

            try {
                const source = entry.source.replaceAll('\n', newline)
                const expected = (entry.expected ?? entry.source).replaceAll('\n', newline)
                const path = join(fixture.root, entry.file)
                writeFileSync(path, source)
                writeFileSync(join(fixture.root, 'pkg.yaml'), 'malformed: [ project\n')
                const formatted = fixture.run(['fmt', entry.file])
                assert.equal(formatted.status, 0, formatted.stderr)
                assert.equal(formatted.stderr, '')
                assert.equal(formatted.stdout, expected)
                assert.equal(readFileSync(path, 'utf8'), source)
                const checked = fixture.run(['fmt', entry.file, '--check'])
                assert.equal(checked.status, source === expected ? 0 : 1, checked.stderr)
                assert.equal(checked.stdout, '')

                if (source !== expected)
                    assert.match(checked.stderr, /import order, blank lines or indentation require formatting/)
                else assert.equal(checked.stderr, '')

                assert.equal(readFileSync(path, 'utf8'), source)
                const written = fixture.run(['fmt', entry.file, '--write'])
                assert.equal(written.status, 0, written.stderr)
                assert.equal(written.stdout, '')
                assert.equal(readFileSync(path, 'utf8'), expected)
                const repeated = fixture.run(['fmt', entry.file])
                assert.equal(repeated.status, 0, repeated.stderr)
                assert.equal(repeated.stdout, expected)
                const clean = fixture.run(['fmt', entry.file, '--check'])
                assert.equal(clean.status, 0, clean.stderr)
                assert.equal(clean.stdout, '')
            } finally {
                fixture.cleanup()
            }
        })
    }
}

for (const source of [
    '',
    '<Module><Call></Module>',
    '<Module value="unterminated>',
    '<Module><!-- unfinished</Module>',
    '<Module>\n</Other>'
]) {
    for (const mode of [[], ['--check'], ['--write']]) {
        test(`RX fmt malformed XML / ${JSON.stringify(source)} / ${mode}`, () => {
            const fixture = createFixture()

            try {
                const path = join(fixture.root, 'invalid.rx')
                writeFileSync(path, source)
                const result = fixture.run(['fmt', 'invalid.rx', ...mode])
                assert.equal(result.status, 1, result.stderr)
                assert.match(result.stderr, /invalid\.rx:[1-9]\d*:[1-9]\d*: syntax:/)
                assert.equal(result.stdout, '')
                assert.equal(readFileSync(path, 'utf8'), source)
            } finally {
                fixture.cleanup()
            }
        })
    }
}

for (const argv of [
    ['--write', '--check'],
    ['--write', '--write'],
    ['--out', 'saved.rx'],
    ['--project', 'pkg.yaml'],
    ['--watch']
]) {
    test(`RX fmt rejects incompatible options / ${argv}`, () => {
        const fixture = createFixture()

        try {
            const source = '<Module>\n\n <Return value="$in" />\n</Module>\n'
            writeFileSync(join(fixture.root, 'module.rx'), source)
            writeFileSync(join(fixture.root, 'saved.rx'), 'existing output\n')
            const result = fixture.run(['fmt', 'module.rx', ...argv])
            assert.equal(result.status, 1, result.stderr)
            assert.equal(result.stdout, '')
            assert.equal(readFileSync(join(fixture.root, 'module.rx'), 'utf8'), source)
            assert.equal(readFileSync(join(fixture.root, 'saved.rx'), 'utf8'), 'existing output\n')
        } finally {
            fixture.cleanup()
        }
    })
}
