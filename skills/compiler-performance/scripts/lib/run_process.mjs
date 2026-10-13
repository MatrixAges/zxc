import { spawn } from 'node:child_process'
import { performance } from 'node:perf_hooks'

export default function runProcess(args) {
    const { command, argv, cwd, stdout, stderr, timeout_ms } = args

    return new Promise(resolve => {
        const started = performance.now()
        const child = spawn(command, argv, {
            cwd,
            detached: true,
            stdio: ['ignore', stdout, stderr]
        })

        let reason = null
        let escalation
        let spawn_error = null

        function signalGroup(signal) {
            if (!child.pid) return

            try {
                process.kill(-child.pid, signal)
            } catch (error) {
                if (error.code !== 'ESRCH') spawn_error = error.message
            }
        }

        function stop(value) {
            if (reason) return

            reason = value
            signalGroup('SIGTERM')
            escalation = setTimeout(() => signalGroup('SIGKILL'), 1000)
        }

        const interrupt = () => stop('SIGINT')
        const terminate = () => stop('SIGTERM')
        const deadline = setTimeout(() => stop('timeout'), timeout_ms)

        process.once('SIGINT', interrupt)
        process.once('SIGTERM', terminate)
        child.once('error', error => {
            spawn_error = error.message
        })

        child.once('close', (code, signal) => {
            clearTimeout(deadline)
            clearTimeout(escalation)
            process.removeListener('SIGINT', interrupt)
            process.removeListener('SIGTERM', terminate)

            if (reason) signalGroup('SIGKILL')

            resolve({
                pid: child.pid ?? null,
                elapsed_wall_ms: performance.now() - started,
                exit_code:
                    reason === 'timeout'
                        ? 124
                        : reason === 'SIGINT'
                          ? 130
                          : reason === 'SIGTERM'
                            ? 143
                            : spawn_error
                              ? 125
                              : (code ?? 125),
                signal,
                reason,
                spawn_error
            })
        })
    })
}
