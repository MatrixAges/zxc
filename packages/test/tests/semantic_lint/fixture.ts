import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, mkdirSync, readdirSync, readFileSync, readlinkSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'

const executable = resolve(process.argv[2])

export default function createFixture(files: Record<string, string | Uint8Array>) {
	const root = mkdtempSync(join(tmpdir(), 'zxc semantic lint '))

	for (const [name, source] of Object.entries(files)) {
		const path = join(root, name)
		mkdirSync(dirname(path), { recursive: true })
		writeFileSync(path, source)
	}

	function snapshot(): Array<[string, string | null]> {
		return readdirSync(root, { recursive: true, withFileTypes: true })
			.map((entry): [string, string | null] => {
				const path = join(entry.parentPath, entry.name)
				let content: string | null = null

				if (entry.isSymbolicLink()) content = `symlink:${readlinkSync(path)}`
				else if (!entry.isDirectory()) content = readFileSync(path).toString('base64')

				return [path, content]
			})
			.sort(([left], [right]) => left.localeCompare(right))
	}

	return {
		root,
		run(argv: Array<string>) {
			const before = snapshot()
			const result = spawnSync(executable, argv, {
				cwd: root,
				encoding: 'utf8',
				timeout: 60_000,
				env: { ...process.env, ZXC_CACHE_DIR: join(root, 'cache') }
			})

			assert.ifError(result.error)
			assert.equal(result.signal, null, result.stderr)
			assert.deepEqual(snapshot(), before, 'lint must preserve all project files and directories')
			assert.equal(result.stdout, '')

			return result
		},
		cleanup() {
			rmSync(root, { recursive: true, force: true })
		}
	}
}
