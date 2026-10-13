#!/usr/bin/env node
import { constants } from 'node:fs'
import { access, mkdir, open, realpath, writeFile } from 'node:fs/promises'
import os from 'node:os'
import path from 'node:path'
import { parseArgs } from 'node:util'
import { describeFile } from './lib/artifacts.mjs'
import runProcess from './lib/run_process.mjs'

const usage = `Usage: measure.mjs --scenario LABEL --out REPORT.json [--runs 3]
  [--timeout 120] [--cwd DIR] [--input FILE ...] -- COMMAND ARG...
Runs sequentially without a shell. Does not clear caches or edit inputs.
Each run logs stdout/stderr. Timeout terminates the command process group.
macOS and Linux require /usr/bin/time. Node.js 20+; no npm dependencies.`

async function readTail(file) {
    const handle = await open(file, 'r')

    try {
        const { size } = await handle.stat()
        const buffer = Buffer.alloc(Math.min(size, 131072))
        const { bytesRead } = await handle.read(buffer, 0, buffer.length, size - buffer.length)

        return buffer.subarray(0, bytesRead).toString('utf8')
    } finally {
        await handle.close()
    }
}

async function resolveCommand(command, cwd) {
    const candidates = command.includes('/')
        ? [path.resolve(cwd, command)]
        : (process.env.PATH ?? '').split(path.delimiter).map(entry => path.resolve(cwd, entry, command))

    for (const candidate of candidates) {
        try {
            await access(candidate, constants.X_OK)
            return await realpath(candidate)
        } catch (error) {
            if (!['ENOENT', 'EACCES', 'ENOTDIR'].includes(error.code)) throw error
        }
    }

    throw new Error(`Executable not found: ${command}`)
}

function parseMetrics(stderr) {
    const time =
        process.platform === 'darwin'
            ? stderr
                  .match(/([\d.]+) real\s+([\d.]+) user\s+([\d.]+) sys/g)
                  ?.at(-1)
                  ?.match(/[\d.]+/g)
            : stderr.match(/COMPILER_PERF real=([\d.]+) user=([\d.]+) sys=([\d.]+) rss_kib=(\d+)/)

    const values = process.platform === 'darwin' ? time : time?.slice(1)
    const rss =
        process.platform === 'darwin'
            ? stderr
                  .match(/(\d+)\s+maximum resident set size/g)
                  ?.at(-1)
                  ?.match(/\d+/)?.[0]
            : values?.[3]

    return {
        tool_wall_seconds: values ? Number(values[0]) : null,
        user_seconds: values ? Number(values[1]) : null,
        system_seconds: values ? Number(values[2]) : null,
        max_rss_bytes: rss === undefined ? null : Number(rss) * (process.platform === 'linux' ? 1024 : 1)
    }
}

async function main() {
    const { values, positionals } = parseArgs({
        allowPositionals: true,
        options: {
            help: { type: 'boolean' },
            scenario: { type: 'string' },
            out: { type: 'string' },
            runs: { type: 'string', default: '3' },
            timeout: { type: 'string', default: '120' },
            cwd: { type: 'string', default: process.cwd() },
            input: { type: 'string', multiple: true, default: [] }
        }
    })

    if (values.help) return console.log(usage)

    const runs = Number(values.runs)
    const timeout_ms = Number(values.timeout) * 1000

    if (
        !values.scenario ||
        !values.out ||
        !positionals.length ||
        !Number.isInteger(runs) ||
        runs < 1 ||
        !Number.isFinite(timeout_ms) ||
        timeout_ms <= 0 ||
        timeout_ms > 2147483647
    )
        throw new Error(usage)

    if (!['darwin', 'linux'].includes(process.platform)) throw new Error('Supported hosts: macOS, Linux.')

    const cwd = await realpath(values.cwd)
    const executable = await resolveCommand(positionals[0], cwd)
    const inputs = await Promise.all(values.input.map(file => describeFile(path.resolve(cwd, file))))
    const executable_before = await describeFile(executable)
    const output = path.resolve(values.out)
    const log_directory = `${output}.logs`

    await access('/usr/bin/time', constants.X_OK)
    await mkdir(path.dirname(output), { recursive: true })
    await mkdir(log_directory)

    const report = {
        schema: 1,
        started_at: new Date().toISOString(),
        scenario: values.scenario,
        cwd,
        argv: [executable, ...positionals.slice(1)],
        executable: executable_before,
        inputs,
        host: { platform: process.platform, release: os.release(), arch: os.arch(), cpus: os.cpus().length },
        requested_runs: runs,
        timeout_ms,
        samples: [],
        limitations: [
            'Scenario/cache state is caller-declared; caches are not cleared.',
            'RSS is the time utility metric, not aggregate simultaneous RSS of the process tree.',
            'Only explicitly listed inputs and the command executable are fingerprinted.',
            'Stage summaries are extracted only from the final 128 KiB of each log.'
        ]
    }

    await writeFile(output, `${JSON.stringify(report, null, 2)}\n`, { flag: 'wx' })

    for (let index = 1; index <= runs; index++) {
        const stdout_path = path.join(log_directory, `${index}.stdout.log`)
        const stderr_path = path.join(log_directory, `${index}.stderr.log`)
        const stdout = await open(stdout_path, 'wx')
        const stderr = await open(stderr_path, 'wx')
        const time_args =
            process.platform === 'darwin' ? ['-l'] : ['-f', 'COMPILER_PERF real=%e user=%U sys=%S rss_kib=%M']
        let sample

        try {
            sample = await runProcess({
                command: '/usr/bin/time',
                argv: [...time_args, executable, ...positionals.slice(1)],
                cwd,
                stdout: stdout.fd,
                stderr: stderr.fd,
                timeout_ms
            })
        } finally {
            await stdout.close()
            await stderr.close()
        }

        const stderr_text = await readTail(stderr_path)
        const stdout_text = await readTail(stdout_path)
        const stage_summaries = `${stdout_text}\n${stderr_text}`
            .split('\n')
            .filter(line => /\binfer\s+\d+(?:\.\d+)?ms\b/.test(line) && /\bemit\s+\d+(?:\.\d+)?ms\b/.test(line))

        report.samples.push({ ...sample, ...parseMetrics(stderr_text), stdout_path, stderr_path, stage_summaries })
        await writeFile(output, `${JSON.stringify(report, null, 2)}\n`)
        if (sample.exit_code !== 0) break
    }

    report.inputs_after = await Promise.all(
        values.input.map(async file => {
            try {
                return await describeFile(path.resolve(cwd, file))
            } catch (error) {
                return { path: path.resolve(cwd, file), error: error.message }
            }
        })
    )
    report.executable_after = await describeFile(executable).catch(error => ({ error: error.message }))
    report.inputs_unchanged =
        JSON.stringify(inputs) === JSON.stringify(report.inputs_after) &&
        executable_before.sha256 === report.executable_after.sha256
    report.valid =
        report.inputs_unchanged &&
        report.samples.length === runs &&
        report.samples.every(sample => sample.exit_code === 0)

    const sorted = report.samples.map(sample => sample.elapsed_wall_ms).sort((a, b) => a - b)
    const middle = Math.floor(sorted.length / 2)
    report.median_wall_ms = report.valid
        ? sorted.length % 2
            ? sorted[middle]
            : (sorted[middle - 1] + sorted[middle]) / 2
        : null

    await writeFile(output, `${JSON.stringify(report, null, 2)}\n`)
    console.log(JSON.stringify({ report: output, valid: report.valid, median_wall_ms: report.median_wall_ms }))
    process.exitCode = report.samples.find(sample => sample.exit_code !== 0)?.exit_code ?? (report.valid ? 0 : 2)
}

main().catch(error => {
    console.error(error.message)
    process.exitCode = 2
})
