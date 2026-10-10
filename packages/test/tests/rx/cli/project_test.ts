import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, unlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'
import { failures, files, helper } from './project_cases.ts'

const executable = resolve(process.argv[2])

function writeFiles(directory: string, sources: Record<string, string>): void {
    for (const [name, source] of Object.entries(sources)) {
        const path = join(directory, name)

        mkdirSync(dirname(path), { recursive: true })
        writeFileSync(path, source)
    }
}

function run(args: { command?: string; argv: Array<string>; directory: string; diagnostic?: RegExp }): string {
    const { command = executable, argv, directory, diagnostic } = args
    const result = spawnSync(command, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

    assert.ifError(result.error)
    assert.equal(result.signal, null, result.stderr)
    assert.equal(result.status, diagnostic ? 1 : 0, result.stderr)

    if (diagnostic) assert.match(result.stderr, diagnostic)

    return result.stdout
}

test('RX disk project rebuilds ZX dependency and preserves last app on failure', () => {
    const directory = mkdtempSync(join(tmpdir(), 'zxc rx project '))
    const application = join(directory, process.platform === 'win32' ? 'app.exe' : 'app')
    const build = ['build', 'main.rx', '--out', application]

    try {
        writeFiles(directory, files)
        run({ argv: ['check-rx', '--entry', 'main.rx'], directory })
        run({ argv: build, directory })
        assert.equal(run({ command: application, argv: ['0'], directory }).trim(), '6')
        assert.equal(run({ command: application, argv: ['7'], directory }).trim(), '20')

        writeFiles(directory, { 'functions/helper.zx': helper(5) })
        run({ argv: build, directory })
        assert.equal(run({ command: application, argv: ['7'], directory }).trim(), '24')

        const original = createHash('sha256').update(readFileSync(application)).digest('hex')

        writeFiles(directory, { 'flows/forward.rx': '<Module>\n<Return value={missing}/>\n</Module>' })
        run({ argv: build, directory, diagnostic: /flows\/forward\.rx:2:\d+: name:/ })
        assert.equal(createHash('sha256').update(readFileSync(application)).digest('hex'), original)
        assert.equal(run({ command: application, argv: ['7'], directory }).trim(), '24')
        assert.equal(readFileSync(join(directory, 'functions/helper.zx'), 'utf8'), helper(5))
    } finally {
        rmSync(directory, { recursive: true, force: true })
    }
})

for (const scenario of failures) {
    test('RX disk project rejects ' + scenario.name, () => {
        const directory = mkdtempSync(join(tmpdir(), 'zxc rx rejection '))
        const sources = { ...files, ...scenario.changes }
        const output = join(directory, 'generated.zig')

        try {
            writeFiles(directory, sources)
            run({ argv: ['main.rx', '--out', output], directory, diagnostic: scenario.diagnostic })
            assert.equal(existsSync(output), false)
            assert.equal(existsSync(output + '.abi.zig'), false)

            for (const [name, source] of Object.entries(sources))
                assert.equal(readFileSync(join(directory, name), 'utf8'), source)
        } finally {
            rmSync(directory, { recursive: true, force: true })
        }
    })
}

for (const scenario of [
    {
        name: 'invalid RX body',
        path: 'flows/forward.rx',
        source: '<Module><Return value={missing}/></Module>',
        diagnostic: /forward\.rx:1:\d+: name:/
    },
    { name: 'deleted RX service', path: 'flows/forward.rx', source: null, diagnostic: /FileNotFound/ },
    {
        name: 'deleted transitive ZX import',
        path: 'functions/helper.zx',
        source: null,
        diagnostic:
            /(?:^|[\\/])functions[\\/]plus\.zx:1:1: module: source module dependency is missing from the registered input set\r?$/m
    }
]) {
    test('RX disk project recovers from ' + scenario.name, () => {
        const directory = mkdtempSync(join(tmpdir(), 'zxc rx recovery '))
        const application = join(directory, process.platform === 'win32' ? 'app.exe' : 'app')
        const build = ['build', 'main.rx', '--out', application]

        try {
            writeFiles(directory, files)
            run({ argv: build, directory })
            assert.equal(run({ command: application, argv: ['7'], directory }).trim(), '20')

            const original = createHash('sha256').update(readFileSync(application)).digest('hex')

            if (scenario.source === null) unlinkSync(join(directory, scenario.path))
            else writeFiles(directory, { [scenario.path]: scenario.source })

            run({ argv: build, directory, diagnostic: scenario.diagnostic })
            assert.equal(createHash('sha256').update(readFileSync(application)).digest('hex'), original)
            assert.equal(run({ command: application, argv: ['7'], directory }).trim(), '20')
            writeFiles(directory, { [scenario.path]: files[scenario.path], 'functions/helper.zx': helper(9) })
            run({ argv: build, directory })
            assert.equal(run({ command: application, argv: ['7'], directory }).trim(), '32')
            assert.equal(run({ command: application, argv: ['0'], directory }).trim(), '18')

            for (const [name, source] of Object.entries({ ...files, 'functions/helper.zx': helper(9) }))
                assert.equal(readFileSync(join(directory, name), 'utf8'), source)
        } finally {
            rmSync(directory, { recursive: true, force: true })
        }
    })
}
