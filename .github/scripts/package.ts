import { mkdirSync, rmSync, statSync } from 'node:fs'
import { basename, dirname, resolve } from 'node:path'
import targets from '../tsflows/targets'
import verifyStandalone from './verify_standalone'

const target = process.env.ZXC_TARGET

if (!target || !targets.some(item => item.target === target)) {
	throw new Error('ZXC_TARGET must name one of the workflow targets')
}

const root = resolve(import.meta.dir, '../..')
const prefix = resolve(root, '.zxc/distribution', `zxc-${target}`)
const artifact_dir = resolve(root, '.zxc/artifacts')
const executable_suffix = target.includes('windows') ? '.exe' : ''
const zig_path = Bun.which('zig')

if (!zig_path) throw new Error('Building zxc requires an official Zig distribution')

function run(command: Array<string>) {
	const result = Bun.spawnSync(command, { cwd: root, stdio: ['ignore', 'inherit', 'inherit'] })

	if (result.exitCode !== 0) throw new Error(`Command failed (${result.exitCode}): ${command[0]}`)
}

rmSync(prefix, { recursive: true, force: true })
mkdirSync(artifact_dir, { recursive: true })

run([zig_path, 'build', 'dist', `-Dtarget=${target}`, '-Doptimize=ReleaseSafe', '--prefix', prefix])

for (const file of ['LICENSE', 'share/zxc/licenses/libyaml.txt', 'share/zxc/licenses/zig.txt']) {
	if (!statSync(resolve(prefix, file)).isFile()) throw new Error(`Missing distribution file: ${file}`)
}

const compiler_path = resolve(prefix, 'bin', `zxc${executable_suffix}`)

verifyStandalone({ root, compiler_path, target })

const archive_path = resolve(artifact_dir, `${basename(prefix)}.tar.gz`)

run(['tar', '-czf', archive_path, '-C', dirname(prefix), basename(prefix)])

const checksum = new Bun.CryptoHasher('sha256').update(await Bun.file(archive_path).arrayBuffer()).digest('hex')

await Bun.write(`${archive_path}.sha256`, `${checksum}  ${basename(archive_path)}\n`)
