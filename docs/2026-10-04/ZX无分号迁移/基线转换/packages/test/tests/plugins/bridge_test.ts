import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdirSync, renameSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

export default function checkBridge(args: { directory: string; compiler_dir: string; library: string }): void {
    const { directory, compiler_dir, library } = args
    const installation = join(directory, 'installed')
    const project = join(directory, 'project')
    const extension = process.platform === 'win32' ? '.exe' : ''
    const executable = join(installation, 'bin', 'zxc' + extension)
    const application = join(directory, 'application' + extension)

    function run(args: { command: string; argv: Array<string>; failure?: string }): string {
        const { command, argv, failure } = args
        const result = spawnSync(command, argv, { cwd: project, encoding: 'utf8', timeout: 180_000 })

        assert.ifError(result.error)
        assert.equal(result.signal, null, result.stderr)

        if (failure) {
            assert.notEqual(result.status, 0)
            assert.ok(result.stderr.includes(failure), result.stderr)
        } else assert.equal(result.status, 0, result.stderr)

        return result.stdout.trim()
    }

    mkdirSync(project)
    run({
        command: 'zig',
        argv: [
            'build',
            '--build-file',
            join(compiler_dir, 'build.zig'),
            '--prefix',
            installation,
            '-Doptimize=ReleaseSafe'
        ]
    })
    writeFileSync(
        join(project, 'main.zx'),
        'import plugin from "c:protocol"\n\nexport type Input = { enabled: bool\n value: u32 }\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  if (!in.enabled) {\n    return 0\n  }\n\n  return plugin.raw(in.value)\n}\n'
    )
    writeFileSync(
        join(project, 'zxc.json'),
        JSON.stringify({
            externals: [
                {
                    specifier: 'c:protocol',
                    export_name: 'raw',
                    signature: 'export type Input = u32\n export type Output = u64\n',
                    implementation: {
                        module: 'protocol_plugin',
                        member: 'raw',
                        allocator_argument: true,
                        fallible: true
                    }
                }
            ],
            native_modules: [{ name: 'protocol_plugin', library }]
        })
    )

    renameSync(library, library + '.hidden')
    run({ command: executable, argv: ['build', 'main.zx', '--out', application] })
    assert.equal(run({ command: application, argv: ['{"enabled":false,"value":0}'] }), '0')
    run({ command: application, argv: ['{"enabled":true,"value":0}'], failure: 'FileNotFound' })
    renameSync(library + '.hidden', library)
    assert.equal(run({ command: application, argv: ['{"enabled":true,"value":0}'] }), '12')
    run({ command: application, argv: ['{"enabled":true,"value":3}'], failure: 'PluginCallFailed' })
    run({ command: application, argv: ['{"enabled":true,"value":4}'], failure: 'PluginOutputTooLarge' })

    console.log('Plugin bridge: missing library build, lazy branch, load and protocol errors passed')
}
