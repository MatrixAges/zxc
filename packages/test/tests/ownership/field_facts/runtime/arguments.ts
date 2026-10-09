import type { Module } from '../../../collections/context_borrow/arguments.ts'
import assert from 'node:assert/strict'
import { join, resolve } from 'node:path'

type Args = {
    modules: Array<Module>
    directory: string
    source: string
    optimize: string
    allocation: string
    options: string
}

export default function compileArguments(args: Args): Array<string> {
    const { modules, directory, source, optimize, allocation, options } = args
    const by_name = new Map(modules.map(module => [module.name, module]))
    const needed = new Set<string>()
    const pending = ['program']

    while (pending.length) {
        const name = pending.pop()!

        if (needed.has(name)) continue

        const module = by_name.get(name)

        assert.ok(module, `missing generated module ${name}`)
        needed.add(name)
        pending.push(...module.imports)
    }

    const mode = `-O${optimize}`
    const argv = [
        'test',
        mode,
        '--dep',
        'program',
        '--dep',
        'options',
        '--dep',
        'allocation_testing',
        `-Mroot=${resolve(source)}`
    ]

    for (const module of modules) {
        if (!needed.has(module.name)) continue

        argv.push(
            mode,
            '--dep',
            'zxc_abi',
            ...module.imports.flatMap(name => ['--dep', name]),
            `-M${module.name}=${join(directory, module.name + '.zig')}`
        )
    }

    argv.push(
        mode,
        `-Moptions=${options}`,
        mode,
        `-Mallocation_testing=${resolve(allocation)}`,
        mode,
        `-Mzxc_abi=${join(directory, 'types.zig')}`
    )

    return argv
}
