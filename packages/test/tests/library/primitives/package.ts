import type { Suite } from './catalog.ts'
import assert from 'node:assert/strict'
import { copyFileSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { parse, stringify } from 'yaml'

const package_name = 'primitive-observations'

export default function createPackage(args: { directory: string; tests: string; suites: Array<Suite> }) {
    const { directory, tests, suites } = args
    const member = join(directory, 'pkgs', package_name)
    const exports = Object.fromEntries(suites.map(suite => [`./${suite.name}`, suite.path + '.zx']))

    mkdirSync(member, { recursive: true })
    writeFileSync(join(member, 'pkg.yaml'), stringify({ name: package_name, version: '1.0.0', exports }))

    const sources = new Set(suites.flatMap(suite => [suite.path + '.zx', ...(suite.sources ?? [])]))

    for (const source of sources) {
        const destination = join(member, source)

        mkdirSync(dirname(destination), { recursive: true })
        copyFileSync(join(tests, source), destination)
    }

    return member
}

export function writeConsumer(directory: string, suite: Suite): void {
    const destination = join(directory, suite.name)
    const specifier = `${package_name}/${suite.name}`

    mkdirSync(destination, { recursive: true })
    writeFileSync(
        join(destination, 'types.zx'),
        `import type { Input, Output } from "${specifier}"\n\nexport type SharedInput = Input\n\nexport type SharedOutput = Output\n`
    )
    writeFileSync(
        join(destination, 'main.zx'),
        `import run from "${specifier}"\n\nimport type { SharedInput, SharedOutput } from "./types"\n\nexport type Input = SharedInput\n\nexport type Output = SharedOutput\n\nexport default function (in: Input): Output {\n  return run(in)\n}\n`
    )
}

export function installCompiled(args: { published: string; directory: string; suites: Array<Suite> }): void {
    const { published, directory, suites } = args
    const member = join(directory, 'pkgs', package_name)
    const manifest = parse(readFileSync(join(published, 'pkg.yaml'), 'utf8')) as {
        library: string
        exports: Record<string, { module: string }>
        entry?: string
    }

    assert.equal(manifest.library, 'library.zxcir')
    assert.equal(manifest.entry, undefined)
    assert.deepEqual(
        manifest.exports,
        Object.fromEntries(suites.map(suite => [`./${suite.name}`, { module: `./${suite.name}` }]))
    )
    mkdirSync(member, { recursive: true })

    for (const file of ['pkg.yaml', 'library.zxcir']) copyFileSync(join(published, file), join(member, file))

    assert.deepEqual(readdirSync(member).sort(), ['library.zxcir', 'pkg.yaml'])
    writeFileSync(
        join(directory, 'pkg.yaml'),
        stringify({
            name: 'primitive-consumer',
            version: '1.0.0',
            workspace: { packages: ['pkgs/*'] },
            dependencies: { [package_name]: 'workspace:*' }
        })
    )

    for (const suite of suites) writeConsumer(directory, suite)
}
