import type { Module, Native } from './arguments.ts'
import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import compileArguments from './arguments.ts'

const [zig, output_dir, source, optimize, native_host, oracle, method, kind, ...compiler_flags] = process.argv.slice(2)
const directory = resolve(output_dir)

assert.ok(['map', 'filter', 'every', 'some'].includes(method))
assert.ok(['list', 'object', 'nested'].includes(kind))
writeFileSync(
    join(directory, 'options.zig'),
    `pub const method: []const u8 = "${method}";\npub const kind: enum { list, object, nested } = .${kind};\n`
)

test(`shared collection context ${method}/${kind} (${optimize})`, () => {
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
        oracle
    })
    const binary = join(directory, 'execution_test')

    argv.push(`-femit-bin=${binary}`, ...compiler_flags)

    const result = spawnSync(zig, argv, { cwd: directory, encoding: 'utf8' })
    const output = (result.stdout ?? '') + (result.stderr ?? '')
    const names = [...output.matchAll(/\d+\/6 .*\.test\.(.+)\.\.\.OK/g)].map(match => match[1])
    const expected = [...readFileSync(source, 'utf8').matchAll(/^test "([^"\n]+)"/gm)].map(match => match[1])

    process.stdout.write(result.stdout ?? '')
    process.stderr.write(result.stderr ?? '')
    writeFileSync(join(directory, 'execution.log'), output)
    writeFileSync(
        join(directory, 'execution.json'),
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
    assert.equal(names.length, 6)
    assert.ok(output.includes('All 6 tests passed.'))
})
