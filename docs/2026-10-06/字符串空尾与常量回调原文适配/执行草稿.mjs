import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { globSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const directory = dirname(fileURLToPath(import.meta.url))
const root = resolve(directory, '../../..')
const fixed = '/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc'
const compiler = resolve(fixed, 'zig-out/bin/zxc')
const digest = bytes => createHash('sha256').update(bytes).digest('hex')
const working = mkdtempSync(resolve(directory, '编译-'))
const suites = [
    { name: 'addition', path: 'language/expressions/addition/explicit_strings', count: 10 },
    { name: 'map', path: 'built_ins/list/map_true/i64', count: 5 },
    { name: 'filter', path: 'built_ins/list/filter_true/i64', count: 5 }
]
const fingerprints = Object.fromEntries(
    globSync(
        [
            'packages/test/src/emit_control_tests.ts',
            'packages/test/src/zig_string.ts',
            'packages/test/src/shared/json.ts',
            'packages/test/src/shared/zig_literal.ts',
            'packages/test/tests/support/control.zig',
            'packages/test/tests/targets/application_json/**/*.ts',
            'packages/test/tests/targets/wasm/**/*.ts'
        ],
        { cwd: root }
    ).map(path => [path, digest(readFileSync(resolve(root, path)))])
)
const commands = []
const reports = []

fingerprints['执行草稿.mjs'] = digest(readFileSync(fileURLToPath(import.meta.url)))

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
    for (const suite of suites) {
        const base = resolve(directory, '草稿/packages/test/tests', suite.path)
        const program = resolve(working, suite.name + '.zig')
        const cases = resolve(working, suite.name + '-cases.zig')
        const rows = readFileSync(base + '.jsonl', 'utf8')
            .trim()
            .split('\n')
            .map(line => JSON.parse(line))
        const added = rows.at(-1)
        const application = resolve(working, suite.name + '-application.jsonl')

        assert.equal(rows.length, suite.count)
        if (suite.name === 'addition') {
            assert.deepEqual(added.input, { left: 'lego', right: '' })
            assert.equal(added.expected.value, 'lego')
        } else {
            assert.deepEqual(added.input, { items: [11] })
            assert.deepEqual(added.expected.value, suite.name === 'map' ? [true] : [11])
        }

        fingerprints[suite.path + '.zx'] = digest(readFileSync(base + '.zx'))
        fingerprints[suite.path + '.jsonl'] = digest(readFileSync(base + '.jsonl'))
        writeFileSync(
            application,
            JSON.stringify({ id: added.id, json_text: JSON.stringify(added.input), expected: added.expected }) + '\n'
        )
        run(compiler, [base + '.zx', '--out', program])
        run(process.execPath, [resolve(root, 'packages/test/src/emit_control_tests.ts'), base + '.jsonl', cases])
        writeFileSync(resolve(directory, suite.name + '生成Zig原始源码.txt'), readFileSync(program))
        writeFileSync(resolve(directory, suite.name + '具名Zig原始断言.txt'), readFileSync(cases))

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

            assert.ok(native.stderr.includes('All ' + suite.count + ' tests passed.'))

            const report_path = resolve(directory, suite.name + '-' + optimize + '应用原始报告.txt')

            run(process.execPath, [
                resolve(root, 'packages/test/tests/targets/application_json/run_test.ts'),
                compiler,
                base + '.zx',
                application,
                optimize,
                report_path
            ])

            const report = JSON.parse(readFileSync(report_path))

            assert.equal(report.optimize, optimize)
            assert.equal(report.observations.length, 3)
            assert.ok(report.observations.every(row => row.executed && row.passed && row.response.status === 0))
            assert.equal(new Set(report.observations.map(row => row.target)).size, 3)
            reports.push({
                suite: suite.name,
                optimize,
                added_case: added.id,
                native_named_cases: suite.count,
                raw_report: report_path,
                sha256: digest(readFileSync(report_path)),
                nested_commands: report.commands.length,
                application_observations: 3
            })
        }
    }
} finally {
    writeFileSync(
        resolve(directory, '实际执行.json'),
        JSON.stringify(
            {
                production_commit: 'b7f882ccaf9cdc6f6aa671f6d1b373317209d7d5',
                compiler,
                compiler_sha256: digest(readFileSync(compiler)),
                source_fingerprints: fingerprints,
                commands,
                reports
            },
            null,
            4
        ) + '\n'
    )
    rmSync(working, { recursive: true, force: true })
}

assert.equal(reports.length, 6)
assert.equal(
    reports.reduce((sum, row) => sum + row.native_named_cases, 0),
    40
)
console.log(
    '40 named native executions and 18 supplementary three-target observations passed; three unique catalog inputs added'
)
