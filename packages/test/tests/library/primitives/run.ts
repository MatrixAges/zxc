import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, renameSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import loadCatalog from './catalog.ts'
import createCommand from './command.ts'
import createPackage, { installCompiled } from './package.ts'

const [cli, zig, optimize, catalog, tests, output] = process.argv.slice(2)

mkdirSync(resolve(output), { recursive: true })

const directory = mkdtempSync(join(resolve(output), 'execution-'))
const test_directory = resolve(tests)
const source = join(directory, 'source')
const compiled = join(directory, 'compiled')
const published = join(directory, 'published')
const suites = loadCatalog(catalog)
const execute = createCommand(directory)
const observations = []

assert.ok(['debug', 'safe', 'fast', 'small'].includes(optimize))
writeFileSync(join(output, 'execution.json'), JSON.stringify({ directory, optimize }, null, 2) + '\n')

const member = createPackage({ directory: source, tests: test_directory, suites })

execute({
    name: 'publish',
    command: cli,
    cwd: member,
    argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', published]
})
installCompiled({ published, directory: compiled, suites })

for (const route of ['source', 'compiled']) {
    const consumer = join(directory, route)

    if (route === 'compiled') {
        renameSync(source, join(directory, 'source-completed'))
        renameSync(published, join(directory, 'published-completed'))
        assert.equal(existsSync(source), false)
        assert.equal(existsSync(published), false)
    }

    for (const suite of suites) {
        const name = `${route}-${suite.name}`
        const generated = join(directory, 'generated', name)
        const program = join(generated, 'program.zig')
        const cases = join(generated, 'cases.zig')
        const binary = join(generated, 'execution_test')
        const case_catalog = join(test_directory, suite.path + '.jsonl')
        const emitter = suite.kind.startsWith('floating') ? 'floating' : 'control'
        const entry = route === 'source' ? join(member, suite.path + '.zx') : join(consumer, suite.name, 'main.zx')
        const project = route === 'source' ? join(member, 'pkg.yaml') : join(consumer, 'pkg.yaml')

        mkdirSync(generated, { recursive: true })

        const compiler_output = execute({
            name: `${name}-generate`,
            command: cli,
            cwd: consumer,
            argv: [entry, '--project', project, '--cache-stats', '--out', program]
        })

        if (route === 'compiled') assert.match(compiler_output, /compiled library inputs bypass semantic artifacts/)

        execute({
            name: `${name}-emit`,
            command: process.execPath,
            cwd: consumer,
            argv: [join(test_directory, '../src', `emit_${emitter}_tests.ts`), case_catalog, cases]
        })

        const argv = [
            'test',
            `-O${optimize}`,
            '--dep',
            'support',
            '--dep',
            'program',
            `-Mroot=${cases}`,
            `-O${optimize}`,
            `-Msupport=${join(test_directory, 'support', suite.kind + '.zig')}`,
            `-O${optimize}`
        ]

        if (readFileSync(program, 'utf8').includes('@import("zxc_abi")')) argv.push('--dep', 'zxc_abi')
        argv.push(`-Mprogram=${program}`)
        if (readFileSync(program, 'utf8').includes('@import("zxc_abi")'))
            argv.push(`-O${optimize}`, `-Mzxc_abi=${program}.abi.zig`)
        argv.push(
            '--cache-dir',
            join(directory, 'local-cache'),
            '--global-cache-dir',
            join(directory, 'global-cache'),
            '--zig-lib-dir',
            join(dirname(zig), 'lib'),
            `-femit-bin=${binary}`
        )

        const result = execute({ name: `${name}-execute`, command: zig, cwd: consumer, argv })
        const expected = readFileSync(case_catalog, 'utf8')
            .trim()
            .split('\n')
            .map(line => (JSON.parse(line) as { id: string }).id)
        const actual = [...result.matchAll(/\d+\/\d+ .*?\.test\.(.+?)\.\.\./g)].map(match => match[1])

        assert.ok(expected.length > 0)
        assert.deepEqual(actual, expected)
        assert.ok(result.includes(`All ${expected.length} tests passed.`))
        observations.push({
            route,
            suite: suite.name,
            expected,
            actual,
            binary,
            binary_sha256: createHash('sha256').update(readFileSync(binary)).digest('hex')
        })
        writeFileSync(join(directory, 'observations.json'), JSON.stringify({ optimize, observations }, null, 2) + '\n')
    }
}
