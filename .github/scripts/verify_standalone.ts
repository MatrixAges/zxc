import { copyFileSync, cpSync, mkdtempSync, readFileSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'

export default function verifyStandalone(args: { root: string; compiler_path: string; target: string }) {
	const { root, compiler_path, target } = args
	const directory = mkdtempSync(join(tmpdir(), 'zxc-standalone-'))
	const suffix = target.includes('windows') ? '.exe' : ''
	const executable = resolve(directory, `zxc${suffix}`)
	const environment = {
		...Object.fromEntries(Object.entries(process.env).filter(([name]) => name.toUpperCase() !== 'PATH')),
		PATH: '',
		ZIG_LIB_DIR: resolve(directory, 'unavailable-external-zig'),
		ZXC_CACHE_DIR: resolve(directory, 'cache'),
		ZIG_GLOBAL_CACHE_DIR: resolve(directory, 'zig-cache')
	}

	function run(command: Array<string>) {
		const result = Bun.spawnSync(command, {
			cwd: directory,
			env: environment,
			stdio: ['ignore', 'pipe', 'inherit']
		})

		if (result.exitCode !== 0) throw new Error(`Standalone command failed (${result.exitCode}): ${command[0]}`)

		return result.stdout.toString()
	}

	try {
		copyFileSync(compiler_path, executable)
		copyFileSync(resolve(root, 'packages/compiler/examples/quote.zx'), resolve(directory, 'quote.zx'))
		copyFileSync(resolve(root, 'docs/2026-10-03/标准库示例/digest.zx'), resolve(directory, 'digest.zx'))
		run([executable, 'pkg', 'index'])
		run([executable, 'build', 'quote.zx', '--out', `quote${suffix}`])
		verifyArchitecture(resolve(directory, `quote${suffix}`), target)

		const quote: unknown = JSON.parse(
			run([
				resolve(directory, `quote${suffix}`),
				JSON.stringify({ amount: 100, discount: 20, enabled: true, factor: 1.5 })
			])
		)

		if (
			!quote ||
			typeof quote !== 'object' ||
			!('amount' in quote) ||
			quote.amount !== 80 ||
			!('factor' in quote) ||
			quote.factor !== 0.75
		) {
			throw new Error('Standalone quote result differs')
		}

		run([executable, 'build', 'digest.zx', '--out', `digest${suffix}`])

		const digest: unknown = JSON.parse(run([resolve(directory, `digest${suffix}`), JSON.stringify('hello')]))
		const expected = new Bun.CryptoHasher('sha256').update('hello').digest('hex')

		if (!digest || typeof digest !== 'object' || !('sha256' in digest) || digest.sha256 !== expected) {
			throw new Error('Standalone standard-library result differs')
		}

		cpSync(resolve(root, 'docs/2026-10-03/原生构建示例'), resolve(directory, 'native'), { recursive: true })
		run([executable, 'build', 'native/native_math.zx', '--out', `native_math${suffix}`])

		const native: unknown = JSON.parse(
			run([resolve(directory, `native_math${suffix}`), JSON.stringify({ value: 9, factor: 2 })])
		)

		if (
			!native ||
			typeof native !== 'object' ||
			!('scaled' in native) ||
			native.scaled !== 18 ||
			!('root' in native) ||
			native.root !== 3
		) {
			throw new Error('Standalone Zig/C module result differs')
		}

		console.log('Standalone compiler: empty PATH, embedded Zig, standard library and C module verified')
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
}

function verifyArchitecture(path: string, target: string) {
	const bytes = readFileSync(path)
	const arm = target.startsWith('aarch64')
	const actual = target.includes('windows')
		? bytes.readUInt16LE(bytes.readUInt32LE(0x3c) + 4)
		: target.includes('macos')
			? bytes.readUInt32LE(4)
			: bytes.readUInt16LE(18)
	const expected = target.includes('windows')
		? arm
			? 0xaa64
			: 0x8664
		: target.includes('macos')
			? arm
				? 0x0100000c
				: 0x01000007
			: arm
				? 183
				: 62

	if (actual !== expected) throw new Error(`Standalone output architecture differs from ${target}`)
}
