import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

type Native = { import_name: string; identity: string | null }
type Module = { name: string; imports: Array<string> }

const [zig, output_dir, source, optimize, native_host, allocation, output] = process.argv.slice(2)
const directory = resolve(output_dir)

test(`effectful object reduction match ${source} (${optimize})`, () => {
    const modules = JSON.parse(readFileSync(join(directory, 'modules.json'), 'utf8')) as Array<Module>
    const native_modules = JSON.parse(readFileSync(join(directory, 'native.json'), 'utf8')) as Array<Native>

    assert.equal(native_modules.length, 1)

    const native = native_modules[0]
    const by_name = new Map(modules.map(module => [module.name, module]))
    const needed = new Set<string>()
    const pending = ['program']

    while (pending.length) {
        const name = pending.pop()!

        if (needed.has(name) || name === native.import_name) continue

        const module = by_name.get(name)

        assert.ok(module, `missing generated module ${name}`)
        needed.add(name)
        pending.push(...module.imports)
    }

    const argv = [
        'test',
        '--test-no-exec',
        `-femit-bin=${resolve(output)}`,
        `-O${optimize}`,
        '--dep',
        'program',
        '--dep',
        `host=${native.import_name}`,
        '--dep',
        'allocation_testing',
        `-Mroot=${resolve(source)}`
    ]

    for (const module of modules) {
        if (!needed.has(module.name)) continue

        argv.push(
            `-O${optimize}`,
            '--dep',
            'zxc_abi',
            ...module.imports.flatMap(name => ['--dep', name]),
            `-M${module.name}=${join(directory, module.name + '.zig')}`
        )
    }

    const abi_name = native.identity ? `${native.import_name}_abi` : 'zxc_abi'

    argv.push(`-O${optimize}`, '--dep', `zxc_abi=${abi_name}`, `-M${native.import_name}=${resolve(native_host)}`)

    if (native.identity)
        argv.push(
            `-O${optimize}`,
            '--dep',
            'zxc_abi_canonical=zxc_abi',
            `-M${abi_name}=${join(directory, abi_name + '.zig')}`
        )

    argv.push(
        `-O${optimize}`,
        `-Mallocation_testing=${resolve(allocation)}`,
        `-O${optimize}`,
        `-Mzxc_abi=${join(directory, 'types.zig')}`
    )

    const compilation = spawnSync(zig, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

    process.stdout.write(compilation.stdout ?? '')
    process.stderr.write(compilation.stderr ?? '')
    assert.ifError(compilation.error)
    assert.equal(compilation.signal, null)
    assert.equal(compilation.status, 0)

    const result = spawnSync(resolve(output), [], { encoding: 'utf8', timeout: 60_000 })

    process.stdout.write(result.stdout ?? '')
    process.stderr.write(result.stderr ?? '')
    writeFileSync(join(directory, 'execution.log'), (result.stdout ?? '') + (result.stderr ?? ''))
    writeFileSync(
        join(directory, 'execution.json'),
        JSON.stringify(
            {
                source: resolve(source),
                optimize,
                native_identity: native.identity,
                argv,
                binary: resolve(output),
                status: result.status,
                signal: result.signal,
                error: result.error?.message ?? null
            },
            null,
            2
        ) + '\n'
    )

    assert.ifError(result.error)
    assert.equal(result.signal, null)
    assert.equal(result.status, 0)
})
