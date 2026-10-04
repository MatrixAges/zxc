import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { existsSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import { stringify } from 'yaml'
import cases from './public_cases.ts'

const executable = resolve(process.argv[2])
const solver = process.env.ZXC_TEST_SOLVER ?? 'z3'

for (const entry of cases) {
	test(`public verification / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc public verify '))

		try {
			writeFileSync(
				join(directory, 'pkg.yaml'),
				stringify({ name: 'proofs', version: '1.0.0', exports: entry.exports })
			)
			for (const [name, source] of Object.entries(entry.files)) writeFileSync(join(directory, name), source)

			const result = spawnSync(
				executable,
				[
					'verify',
					'pkg.yaml',
					'--solver',
					entry.no_solver ? join(directory, 'absent-solver') : solver,
					'--out',
					'proof'
				],
				{ cwd: directory, encoding: 'utf8', timeout: 60_000 }
			)

			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, entry.failed ? 1 : 0, result.stderr)
			assert.equal(result.stdout, '')
			if (entry.diagnostic) assert.ok(result.stderr.includes(entry.diagnostic), result.stderr)

			for (const proof of entry.proofs) {
				assert.ok(result.stderr.includes(`public module ${proof.name}:`), result.stderr)
				const digest = createHash('sha256').update(proof.name).digest('hex')
				const path = join(directory, `proof.${digest}.smt2`)

				if (proof.result === 'types') {
					assert.ok(result.stderr.includes('type interface validated; no executable proof obligation'))
					assert.equal(existsSync(path), false)
				} else {
					assert.match(readFileSync(path, 'utf8'), /\(check-sat\)/)
					assert.equal(readFileSync(path + '.result.txt', 'utf8').trim(), proof.result)
					assert.match(readFileSync(path + '.solver.txt', 'utf8'), /Z3 version/)
				}
			}

			assert.equal(
				readdirSync(directory).filter(name => /^proof\.[0-9a-f]{64}\.smt2$/.test(name)).length,
				entry.proofs.filter(proof => proof.result !== 'types').length
			)
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
