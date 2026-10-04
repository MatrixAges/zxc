import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import cases from './graph_cases.ts'
import range_cases from './range_cases.ts'

type Package = { path: string; manifest: { name: string }; dependencies: Array<{ name: string; target: number; development: boolean }> }
const executable = resolve(process.argv[2])

for (const entry of [...cases, ...range_cases]) {
	test(`package graph / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc-graph-'))

		try {
			writeFileSync(join(directory, 'pkg.yaml'), stringify({ name: 'root', version: '1.0.0', workspace: { packages: ['pkgs/*'] }, ...entry.root }))

			for (const [path, manifest] of Object.entries(entry.members)) {
				mkdirSync(join(directory, path), { recursive: true })
				writeFileSync(join(directory, path, 'pkg.yaml'), stringify({ version: '1.2.3', ...manifest }))
			}

			const result = spawnSync(executable, ['pkg', 'graph'], { cwd: directory, encoding: 'utf8', timeout: 10_000 })

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, entry.diagnostic ? 1 : 0, result.stderr)

			if (entry.diagnostic) {
				assert.equal(result.stdout, '')
				assert.equal(result.stderr, entry.diagnostic)
			} else {
				assert.equal(result.stderr, '')

				const actual = JSON.parse(result.stdout) as Array<Package>
				const expected_nodes = [['.', 'root'], ...Object.entries(entry.members).sort(([left], [right]) => left < right ? -1 : left > right ? 1 : 0).map(([path, manifest]) => [path, manifest.name])]
				const edges = actual.flatMap(owner => owner.dependencies.map(edge => {
					assert.ok(Number.isSafeInteger(edge.target) && edge.target >= 0 && edge.target < actual.length)

					return [owner.manifest.name, edge.name, actual[edge.target].manifest.name, edge.development]
				}))

				assert.deepEqual(actual.map(item => [item.path, item.manifest.name]), expected_nodes)
				assert.deepEqual(edges, entry.edges)
			}
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
