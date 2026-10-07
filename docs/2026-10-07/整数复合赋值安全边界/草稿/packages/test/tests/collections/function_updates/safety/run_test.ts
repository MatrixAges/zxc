import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'

type Native = { import_name: string; identity: string | null }

const [zig, source, types, metadata, root, optimize, probe, mode, output] = process.argv.slice(2)
const native_modules = JSON.parse(readFileSync(metadata, 'utf8')) as Array<Native>

assert.equal(native_modules.length, 1)
assert.match(mode, /^effects_(?:nested_)?(?:add|subtract|multiply|divide|remainder)$/)
assert.ok(optimize === 'debug' || optimize === 'safe')

const native = native_modules[0]
const directory = dirname(resolve(output))
const argv = [
    'build-exe',
    `-femit-bin=${resolve(output)}`,
    `-O${optimize}`,
    '--dep',
    'program',
    '--dep',
    `probe=${native.import_name}`,
    `-Mroot=${resolve(root)}`,
    `-O${optimize}`,
    '--dep',
    'zxc_abi',
    '--dep',
    native.import_name,
    `-Mprogram=${resolve(source)}`,
    `-O${optimize}`,
    `-M${native.import_name}=${resolve(probe)}`,
    `-O${optimize}`,
    `-Mzxc_abi=${resolve(types)}`
]
const compilation = spawnSync(zig, argv, { encoding: 'utf8', timeout: 180_000 })

process.stdout.write(compilation.stdout ?? '')
process.stderr.write(compilation.stderr ?? '')
assert.ifError(compilation.error)
assert.equal(compilation.signal, null)
assert.equal(compilation.status, 0)
writeFileSync(
    join(directory, 'compilation.json'),
    JSON.stringify({ zig, argv, source, types, metadata, root, optimize, probe, mode, native }, null, 2) + '\n'
)

const execution = spawnSync(
    process.execPath,
    [join(dirname(root), 'run_process.ts'), resolve(output), mode, join(directory, 'results.json')],
    { encoding: 'utf8', timeout: 60_000 }
)

process.stdout.write(execution.stdout ?? '')
process.stderr.write(execution.stderr ?? '')
assert.ifError(execution.error)
assert.equal(execution.signal, null)
assert.equal(execution.status, 0)
