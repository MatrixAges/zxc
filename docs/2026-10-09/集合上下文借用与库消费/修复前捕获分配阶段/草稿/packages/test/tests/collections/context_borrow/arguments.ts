import assert from 'node:assert/strict'
import { join, resolve } from 'node:path'

export type Native = { import_name: string; identity: string | null }
export type Module = { name: string; imports: Array<string> }

type Args = {
    modules: Array<Module>
    native: Native
    directory: string
    source: string
    optimize: string
    native_host: string
    oracle: string
}

export default function compileArguments(args: Args): Array<string> {
    const { modules, native, directory, source, optimize, native_host, oracle } = args
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
        'oracle',
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
        'options',
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
        `-Moracle=${resolve(oracle)}`,
        `-O${optimize}`,
        `-Moptions=${join(directory, 'options.zig')}`,
        `-O${optimize}`,
        `-Mzxc_abi=${join(directory, 'types.zig')}`
    )

    return argv
}
