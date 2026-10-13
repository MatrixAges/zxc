#!/usr/bin/env node
import { spawnSync } from 'node:child_process'
import { mkdir, writeFile } from 'node:fs/promises'
import path from 'node:path'
import { parseArgs } from 'node:util'

function identify(pid) {
    const result = spawnSync('/bin/ps', ['-p', String(pid), '-o', 'pid=,ppid=,lstart=,comm='], {
        encoding: 'utf8',
        timeout: 3000,
        killSignal: 'SIGKILL'
    })

    return result.status === 0 ? result.stdout.trim() : null
}

async function main() {
    const { values, positionals } = parseArgs({
        allowPositionals: true,
        options: {
            help: { type: 'boolean' },
            pid: { type: 'string' },
            out: { type: 'string' },
            seconds: { type: 'string', default: '3' },
            interval: { type: 'string', default: '1' }
        }
    })

    if (values.help)
        return console.log(
            'Usage: profile.mjs --pid PID --out NEW_DIRECTORY [--seconds 3] [--interval 1]\nmacOS sample, interval in milliseconds. Records target identity before/after. Never selects PID by name.'
        )
    if (process.platform !== 'darwin')
        throw new Error('This profiler supports macOS sample only; use the host profiler on other systems.')

    const pid = Number(values.pid)
    const seconds = Number(values.seconds)
    const interval = Number(values.interval)

    if (
        positionals.length ||
        !values.out ||
        !Number.isInteger(pid) ||
        pid <= 1 ||
        !Number.isInteger(seconds) ||
        seconds < 1 ||
        seconds > 60 ||
        !Number.isInteger(interval) ||
        interval < 1 ||
        interval > seconds * 1000
    )
        throw new Error('Invalid arguments; see --help.')

    const before = identify(pid)
    if (!before) throw new Error(`Target process is unavailable: ${pid}`)

    const output = path.resolve(values.out)
    await mkdir(path.dirname(output), { recursive: true })
    await mkdir(output)

    const argv = [
        String(pid),
        String(seconds),
        String(interval),
        '-mayDie',
        '-fullPaths',
        '-file',
        path.join(output, 'sample.txt')
    ]
    const result = spawnSync('/usr/bin/sample', argv, {
        encoding: 'utf8',
        timeout: (seconds + 10) * 1000,
        killSignal: 'SIGKILL',
        maxBuffer: 4 * 1024 * 1024
    })
    const after = identify(pid)
    const report = {
        command: '/usr/bin/sample',
        argv,
        before,
        after,
        identity_unchanged: after === null ? null : before === after,
        exit_code: result.status,
        signal: result.signal,
        error: result.error?.message ?? null,
        limitations: [
            'Samples cover this PID and time window only; they are not whole-build percentages.',
            'Missing symbols require same-build symbol mapping or stage timers; do not infer inlining from main alone.'
        ]
    }

    await writeFile(path.join(output, 'profiler.log'), `${result.stdout ?? ''}\n${result.stderr ?? ''}`)
    await writeFile(path.join(output, 'target.json'), `${JSON.stringify(report, null, 2)}\n`)
    console.log(JSON.stringify({ directory: output, ...report }))
    process.exitCode = result.error || report.identity_unchanged === false ? 2 : (result.status ?? 2)
}

main().catch(error => {
    console.error(error.message)
    process.exitCode = 2
})
