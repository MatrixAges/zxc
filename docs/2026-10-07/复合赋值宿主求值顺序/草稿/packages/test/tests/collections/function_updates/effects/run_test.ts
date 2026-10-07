import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'

type Native = { import_name: string; identity: string | null }

const [zig, source, types, metadata, root, optimize, probe, allocation, mode, output] = process.argv.slice(2)
const native_modules = JSON.parse(readFileSync(metadata, 'utf8')) as Array<Native>

assert.equal(native_modules.length, 1)
assert.match(mode, /^effects_(?:nested_)?(?:set|add|subtract|multiply|divide|remainder)$/)

const native = native_modules[0]
const directory = dirname(resolve(output))
const options = join(directory, 'options.zig')

writeFileSync(options, `pub const mode: []const u8 = "${mode}";\n`)

const argv = [
    'test',
    '--test-no-exec',
    `-femit-bin=${resolve(output)}`,
    `-O${optimize}`,
    '--dep',
    'program',
    '--dep',
    `probe=${native.import_name}`,
    '--dep',
    'options',
    '--dep',
    'allocation_testing',
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
    `-Mallocation_testing=${resolve(allocation)}`,
    `-Moptions=${options}`,
    `-O${optimize}`,
    `-Mzxc_abi=${resolve(types)}`
]
const compilation = spawnSync(zig, argv, { encoding: 'utf8', timeout: 180_000 })

process.stdout.write(compilation.stdout ?? '')
process.stderr.write(compilation.stderr ?? '')
assert.ifError(compilation.error)
assert.equal(compilation.signal, null)
assert.equal(compilation.status, 0)

const execution = spawnSync(resolve(output), [], { encoding: 'utf8', timeout: 60_000 })
const raw = (execution.stdout ?? '') + (execution.stderr ?? '')

process.stdout.write(execution.stdout ?? '')
process.stderr.write(execution.stderr ?? '')
writeFileSync(join(directory, 'execution.log'), raw)
writeFileSync(
    join(directory, 'execution.json'),
    JSON.stringify({ argv, mode, optimize, native, binary: resolve(output), status: execution.status }, null, 2) + '\n'
)

assert.ifError(execution.error)
assert.equal(execution.signal, null)
assert.equal(execution.status, 0)
