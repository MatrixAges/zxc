import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { globSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const directory = dirname(fileURLToPath(import.meta.url))
const fixed = '/Users/xiewendao/.codex/worktrees/json-output-conformance/zxc'
const compiler = resolve(process.argv[2])
const mapping = JSON.parse(readFileSync(resolve(directory, '原文观察映射.json')))
const digest = bytes => createHash('sha256').update(bytes).digest('hex')
const fingerprints = Object.fromEntries(
    globSync(
        [
            'packages/test/src/shared/*.ts',
            'packages/test/tests/targets/application_json/**/*.ts',
            'packages/test/tests/targets/wasm/**/*.ts'
        ],
        { cwd: fixed }
    ).map(path => [path, digest(readFileSync(resolve(fixed, path)))])
)
const commands = []
const reports = []

for (const operation of ['escape', 'unescape']) {
    const unique = new Map()

    for (const group of mapping.filter(row => row.operation === operation)) {
        for (const row of group.observations) unique.set(row.case, row)
    }

    const source = resolve(fixed, 'packages/test/tests/standard/querystring', operation, 'cases.zx')
    const catalog = resolve(directory, operation + '应用输入.jsonl')
    const rows = Array.from(unique.values()).map(row => ({
        id: row.case,
        json_text: JSON.stringify(row.input),
        expected: { value: row.expected }
    }))

    writeFileSync(catalog, rows.map(row => JSON.stringify(row)).join('\n') + '\n')
    fingerprints[source] = digest(readFileSync(source))
    fingerprints[catalog] = digest(readFileSync(catalog))

    for (const optimize of ['debug', 'safe']) {
        const report_path = resolve(directory, optimize + '-' + operation + '应用原始报告.txt')
        const command = process.execPath
        const argv = [
            resolve(fixed, 'packages/test/tests/targets/application_json/run_test.ts'),
            compiler,
            source,
            catalog,
            optimize,
            report_path
        ]
        const result = spawnSync(command, argv, { cwd: fixed, encoding: 'utf8', timeout: 600000 })

        commands.push({
            command,
            argv,
            status: result.status,
            signal: result.signal,
            error: result.error?.message ?? null,
            stdout: result.stdout,
            stderr: result.stderr
        })
        writeFileSync(
            resolve(directory, '应用执行.json'),
            JSON.stringify(
                {
                    production_commit: 'a7662c5c',
                    compiler,
                    compiler_sha256: digest(readFileSync(compiler)),
                    script_sha256: digest(readFileSync(fileURLToPath(import.meta.url))),
                    fingerprints,
                    commands,
                    reports
                },
                null,
                4
            ) + '\n'
        )
        assert.ifError(result.error)
        assert.equal(result.signal, null)
        assert.equal(result.status, 0, result.stderr)

        const report = JSON.parse(readFileSync(report_path))

        assert.equal(report.observations.length, rows.length * 3)
        assert.ok(report.observations.every(row => row.executed && row.passed && row.response.status === 0))
        assert.equal(report.artifacts.length, 3)
        assert.ok(report.commands.every(row => row.status === 0 && row.signal === null && row.error === null))
        reports.push({ operation, optimize, path: report_path, sha256: digest(readFileSync(report_path)) })
    }
}

assert.equal(reports.length, 4)
writeFileSync(
    resolve(directory, '应用执行.json'),
    JSON.stringify(
        {
            production_commit: 'a7662c5c',
            compiler,
            compiler_sha256: digest(readFileSync(compiler)),
            script_sha256: digest(readFileSync(fileURLToPath(import.meta.url))),
            fingerprints,
            commands,
            reports
        },
        null,
        4
    ) + '\n'
)
console.log('All 130 unique URI cases passed in three application targets and two optimization modes')
