import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'

type Native = { import_name: string; identity: string | null }
type Module = { name: string; imports: Array<string> }

const [zig, output_dir, source, optimize, native_host, allocation, mode] = process.argv.slice(2)
const directory = resolve(output_dir)

assert.ok(['string', 'list', 'nested', 'optional'].includes(mode))
writeFileSync(join(directory, 'options.zig'), `pub const mode: enum { string, list, nested, optional } = .${mode};\n`)

test(`borrowed native payload runtime ${source} (${optimize})`, () => {
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
        `-O${optimize}`,
        '--dep',
        'program',
        '--dep',
        `host=${native.import_name}`,
        '--dep',
        'options',
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

    argv.push(
        `-O${optimize}`,
        '--dep',
        'native_impl',
        '--dep',
        `zxc_abi=${abi_name}`,
        `-M${native.import_name}=${resolve(native_host)}`
    )

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
        `-Mnative_impl=${resolve(dirname(native_host), '../../host.zig')}`,
        `-O${optimize}`,
        `-Moptions=${join(directory, 'options.zig')}`,
        `-O${optimize}`,
        `-Mzxc_abi=${join(directory, 'types.zig')}`
    )

    const result = spawnSync(zig, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

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
