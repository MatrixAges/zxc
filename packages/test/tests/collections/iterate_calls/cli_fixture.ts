import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { cpSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { stringify } from 'yaml'

const executable = resolve(process.argv[2])
const inputs = resolve(process.argv[4])

export const modes = ['identity', 'child', 'pair', 'branch_return', 'tuple_identity', 'list_alias']

function snapshot(directory: string): Record<string, string> {
	return Object.fromEntries(
		readdirSync(directory, { recursive: true, withFileTypes: true })
			.filter(entry => entry.isFile())
			.map(entry => {
				const path = join(entry.parentPath, entry.name)

				return [path.slice(directory.length + 1), createHash('sha256').update(readFileSync(path)).digest('hex')]
			})
	)
}

export default function createFixture() {
	const root = mkdtempSync(join(tmpdir(), 'zxc loop aliases '))
	const source = join(root, 'source')
	const published = join(root, 'published')
	const consumer = join(root, 'consumer')
	const package_dir = join(consumer, 'pkgs', 'loops')

	cpSync(inputs, source, { recursive: true })
	writeFileSync(
		join(source, 'pkg.yaml'),
		stringify({
			name: 'loops',
			version: '1.0.0',
			exports: Object.fromEntries(modes.map(mode => [`./${mode}`, `${mode}_main.zx`]))
		})
	)

	const original_sources = snapshot(source)

	function run(args: { argv: Array<string>; cwd?: string; command?: string; cache?: string }) {
		const { argv, cwd = source, command = executable, cache = 'publication_cache' } = args
		const result = spawnSync(command, argv, {
			cwd,
			env: { ...process.env, ZXC_CACHE_DIR: join(root, cache) },
			encoding: 'utf8',
			timeout: 180_000
		})

		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	return {
		root,
		source,
		published,
		consumer,
		package_dir,
		run,
		publish() {
			const result = run({ argv: ['build', 'pkg.yaml', '--mode', 'lib', '--out', published] })

			assert.equal(result.status, 0, result.stderr)

			for (const [path, hash] of Object.entries(original_sources))
				assert.equal(
					createHash('sha256')
						.update(readFileSync(join(source, path)))
						.digest('hex'),
					hash
				)
		},
		relocate() {
			mkdirSync(join(consumer, 'pkgs'), { recursive: true })
			cpSync(published, package_dir, { recursive: true })
			writeFileSync(
				join(consumer, 'pkg.yaml'),
				stringify({
					name: 'consumer',
					version: '1.0.0',
					workspace: { packages: ['pkgs/*'] },
					dependencies: { loops: 'workspace:*' }
				})
			)
			rmSync(source, { recursive: true })
			rmSync(published, { recursive: true })
		},
		snapshot() {
			return snapshot(package_dir)
		},
		cleanup() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
