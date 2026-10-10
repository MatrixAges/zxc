import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { mkdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

export default function createCommand(directory: string) {
    const environment = { ...process.env, ZXC_CACHE_DIR: join(directory, 'semantic-cache') }
    let sequence = 0

    return function execute(args: { name: string; command: string; argv: Array<string>; cwd: string }): string {
        const { name, command, argv, cwd } = args
        const prefix = join(directory, 'commands', `${++sequence}-${name}`)
        const started_at = new Date().toISOString()

        mkdirSync(join(directory, 'commands'), { recursive: true })

        const result = spawnSync(command, argv, {
            cwd,
            env: environment,
            encoding: 'utf8',
            maxBuffer: 16 * 1024 * 1024
        })
        const stdout = result.stdout ?? ''
        const stderr = result.stderr ?? ''

        writeFileSync(prefix + '.stdout.txt', stdout)
        writeFileSync(prefix + '.stderr.txt', stderr)
        writeFileSync(
            prefix + '.json',
            JSON.stringify(
                {
                    command,
                    argv,
                    cwd,
                    pid: result.pid,
                    started_at,
                    finished_at: new Date().toISOString(),
                    status: result.status,
                    signal: result.signal,
                    error: result.error?.message ?? null,
                    stdout_sha256: createHash('sha256').update(stdout).digest('hex'),
                    stderr_sha256: createHash('sha256').update(stderr).digest('hex')
                },
                null,
                2
            ) + '\n'
        )
        process.stdout.write(stdout)
        process.stderr.write(stderr)

        assert.ifError(result.error)
        assert.equal(result.signal, null)
        assert.equal(result.status, 0, name)

        return stdout + stderr
    }
}
