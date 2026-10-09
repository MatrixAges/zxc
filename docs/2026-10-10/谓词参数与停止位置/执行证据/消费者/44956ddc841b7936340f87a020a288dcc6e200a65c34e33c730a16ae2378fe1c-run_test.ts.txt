import type { Module, Native } from '../context_borrow/arguments.ts'
import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { basename, join, resolve } from 'node:path'
import { test } from 'node:test'
import compileArguments from '../context_borrow/arguments.ts'

const [zig, output_dir, source, optimize, native_host, oracle, method, ...compiler_flags] = process.argv.slice(2)
const directory = resolve(output_dir)
const runtime_dir = join(directory, 'runtime', basename(source, '.zig'))
const options_path = join(runtime_dir, 'options.zig')

mkdirSync(runtime_dir, { recursive: true })

assert.ok(['map', 'filter', 'every', 'some'].includes(method))
writeFileSync(options_path, `pub const method: enum { map, filter, every, some } = .${method};\n`)

test(`callback arguments ${method} (${optimize})`, () => {
    const modules = JSON.parse(readFileSync(join(directory, 'modules.json'), 'utf8')) as Array<Module>
    const native_modules = JSON.parse(readFileSync(join(directory, 'native.json'), 'utf8')) as Array<Native>

    assert.equal(native_modules.length, 1)

    const argv = compileArguments({
        modules,
        native: native_modules[0],
        directory,
        source,
        optimize,
        native_host,
        oracle,
        options_path
    })
    const binary = join(runtime_dir, 'execution_test')

    argv.push(`-femit-bin=${binary}`, ...compiler_flags)

    const result = spawnSync(zig, argv, { cwd: directory, encoding: 'utf8' })
    const output = (result.stdout ?? '') + (result.stderr ?? '')
    const expected = [...readFileSync(source, 'utf8').matchAll(/^test "([^"\n]+)"/gm)].map(match => match[1])
    const headers = new RegExp('\\d+/' + expected.length + ' .*?\\.test\\.(.+?)\\.\\.\\.', 'g')
    const names = [...output.matchAll(headers)].map(match => match[1])

    process.stdout.write(result.stdout ?? '')
    process.stderr.write(result.stderr ?? '')
    writeFileSync(join(runtime_dir, 'execution.log'), output)
    writeFileSync(
        join(runtime_dir, 'execution.json'),
        JSON.stringify(
            {
                source: resolve(source),
                optimize,
                native_identity: native_modules[0].identity,
                argv,
                status: result.status,
                signal: result.signal,
                error: result.error?.message ?? null,
                names,
                binary,
                binary_sha256:
                    result.status === 0 ? createHash('sha256').update(readFileSync(binary)).digest('hex') : null
            },
            null,
            2
        ) + '\n'
    )

    assert.ifError(result.error)
    assert.equal(result.signal, null)
    assert.equal(result.status, 0)
    assert.deepEqual(names, expected)
    assert.ok(expected.length > 0)
    assert.ok(output.includes(`All ${expected.length} tests passed.`))
})
