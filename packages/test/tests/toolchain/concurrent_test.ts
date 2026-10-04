import assert from 'node:assert/strict'
import { spawn, spawnSync } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

const executable = resolve(process.argv[2])
const extension = process.platform === 'win32' ? '.exe' : ''

test('embedded toolchain / concurrent cold cache and stale staging', async () => {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-cache-race-'))
	const cache = join(directory, 'shared cache')
	const environment = { ...process.env, PATH: '', ZIG_LIB_DIR: join(directory, 'missing-library'), ZXC_CACHE_DIR: cache, ZIG_GLOBAL_CACHE_DIR: join(directory, 'zig-global') }
	const projects = ['left', 'right'].map(name => join(directory, name))

	try {
		for (const [index, project] of projects.entries()) {
			mkdirSync(project)
			writeFileSync(join(project, 'main.zx'), `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return in ${index === 0 ? '+ 11' : '* 7'}
}
`)
		}

		let digest = ''

		for (const round of ['empty', 'stale']) {
			if (round === 'stale') {
				rmSync(join(cache, 'toolchains', digest), { recursive: true })
				mkdirSync(join(cache, 'toolchains', digest + '.partial'))
				writeFileSync(join(cache, 'toolchains', digest + '.partial', 'stale-sentinel'), 'old incomplete extraction')
			}

			const results = await Promise.allSettled(projects.map(project => new Promise<void>((resolve, reject) => {
				const application = join(project, round + extension)
				const child = spawn(executable, ['build', 'main.zx', '--mode', 'app', '--out', application], { cwd: project, env: environment, timeout: 180_000 })
				let stderr = ''

				child.stdout.resume()
				child.stderr.on('data', (data: Buffer) => { stderr += data.toString() })
				child.on('error', reject)
				child.on('close', (status, signal) => {
					if (status !== 0 || signal !== null) reject(new Error(`${round}: ${status}/${signal}: ${stderr}`))
					else resolve()
				})
			})))

			for (const result of results) if (result.status === 'rejected') throw result.reason

			const entries = readdirSync(join(cache, 'toolchains'))
			const digests = entries.filter(name => /^[a-f0-9]{64}$/.test(name))

			assert.equal(digests.length, 1, round)
			if (digest) assert.equal(digests[0], digest)

			digest = digests[0]

			const root = join(cache, 'toolchains', digest)

			assert.equal(readFileSync(join(root, 'ready'), 'utf8'), digest)
			assert.equal(entries.some(name => name.endsWith('.partial')), false)
			assert.equal(existsSync(join(root, 'stale-sentinel')), false)

			for (const [index, project] of projects.entries()) {
				for (const input of [0, 5, 29]) {
					const result = spawnSync(join(project, round + extension), [String(input)], { cwd: project, env: environment, encoding: 'utf8', timeout: 10_000 })

					assert.ifError(result.error)
					assert.equal(result.signal, null)
					assert.equal(result.status, 0, result.stderr)
					assert.equal(result.stdout.trim(), String(index === 0 ? input + 11 : input * 7))
				}
			}
		}
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
})
