import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { globSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import vm from 'node:vm'

const directory = dirname(fileURLToPath(import.meta.url))
const root = resolve(directory, '../../..')
const boundary = JSON.parse(
    readFileSync(resolve(directory, '../输入不可变与原生引用回归/Debug核心/应用边界原始报告.txt'))
)
const compiler = boundary.reports[0].commands[0].command
const source = resolve(directory, '草稿/packages/test/tests/language/expressions/template_primitives/bool.zx')
const catalog = source.replace(/\.zx$/, '.jsonl')
const metadata = JSON.parse(readFileSync(resolve(directory, '原文metadata.json')))
const original = readFileSync(resolve(directory, '完整原文.txt'), 'utf8')
const harness_path = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd/harness/sta.js'
const harness = readFileSync(harness_path, 'utf8')
const digest = bytes => createHash('sha256').update(bytes).digest('hex')
const source_fingerprints = Object.fromEntries(
    globSync(
        [
            'packages/test/src/**/*.ts',
            'packages/test/tests/support/**/*.zig',
            'packages/test/tests/targets/application_json/**/*.ts',
            'packages/test/tests/targets/wasm/**/*.ts'
        ],
        { cwd: root }
    ).map(path => [path, digest(readFileSync(resolve(root, path)))])
)
source_fingerprints['执行草稿.mjs'] = digest(readFileSync(fileURLToPath(import.meta.url)))
const references = []
const commands = []
const reports = []
const working = mkdtempSync(resolve(directory, '编译-'))

assert.equal(digest(original), metadata.sha256)

for (const strict of [false, true]) {
    const context = vm.createContext({})

    vm.runInContext(harness, context, { filename: 'sta.js', timeout: 2000 })
    vm.runInContext((strict ? '"use strict";\n' : '') + original, context, { filename: metadata.path, timeout: 5000 })
    references.push({ strict, passed: true, sha256: digest(original) })
}

function run(command, argv) {
    const result = spawnSync(command, argv, { cwd: working, encoding: 'utf8', timeout: 180000 })

    commands.push({
        command,
        argv,
        status: result.status,
        signal: result.signal,
        error: result.error?.message ?? null,
        stdout: result.stdout,
        stderr: result.stderr
    })
    assert.ifError(result.error)
    assert.equal(result.signal, null)
    assert.equal(result.status, 0, result.stderr)

    return result
}

try {
    const program = resolve(working, 'program.zig')
    const cases = resolve(working, 'cases.zig')
    const rows = readFileSync(catalog, 'utf8')
        .trim()
        .split('\n')
        .map(line => JSON.parse(line))
    const json_catalog = resolve(working, 'application.jsonl')

    assert.deepEqual(
        rows.map(row => row.input),
        [false, true]
    )
    writeFileSync(
        json_catalog,
        rows
            .map(row => JSON.stringify({ id: row.id, json_text: JSON.stringify(row.input), expected: row.expected }))
            .join('\n') + '\n'
    )
    run(compiler, [source, '--out', program])
    run(process.execPath, [resolve(root, 'packages/test/src/emit_control_tests.ts'), catalog, cases])
    writeFileSync(resolve(directory, '生成Zig原始源码.txt'), readFileSync(program))
    writeFileSync(resolve(directory, '具名Zig原始断言.txt'), readFileSync(cases))

    for (const optimize of ['debug', 'safe']) {
        const native = run('zig', [
            'test',
            '-O' + optimize,
            '--dep',
            'support',
            '--dep',
            'program',
            '-Mroot=' + cases,
            '-O' + optimize,
            '-Msupport=' + resolve(root, 'packages/test/tests/support/control.zig'),
            '-O' + optimize,
            '-Mprogram=' + program
        ])

        assert.match(native.stderr, /All 2 tests passed\./)

        const report_path = resolve(directory, optimize + '应用原始报告.txt')

        run(process.execPath, [
            resolve(root, 'packages/test/tests/targets/application_json/run_test.ts'),
            compiler,
            source,
            json_catalog,
            optimize,
            report_path
        ])

        const report = JSON.parse(readFileSync(report_path))

        assert.equal(report.optimize, optimize)
        assert.equal(report.observations.length, 6)
        assert.ok(report.observations.every(row => row.executed && row.passed && row.response.status === 0))
        assert.equal(report.commands.length, 7)
        reports.push({
            optimize,
            raw_report: report_path,
            sha256: digest(readFileSync(report_path)),
            native_named_cases: 2,
            three_target_observations: 6
        })
    }
} finally {
    writeFileSync(
        resolve(directory, '实际执行.json'),
        JSON.stringify(
            {
                compiler,
                compiler_sha256: digest(readFileSync(compiler)),
                production_commit: 'f38d9b4f',
                references,
                harness_sha256: digest(harness),
                source_fingerprints,
                commands,
                reports,
                source_sha256: digest(readFileSync(source)),
                catalog_sha256: digest(readFileSync(catalog))
            },
            null,
            2
        ) + '\n'
    )
    rmSync(working, { recursive: true, force: true })
}

assert.equal(reports.length, 2)
console.log(
    '2 unchanged original runs; 4 named native executions; 12 supplementary application observations; no input-specific output branches'
)
