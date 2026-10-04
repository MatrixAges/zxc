import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'
import cases from './cases.ts'

const executable = resolve(process.argv[2])
const solver = process.env.ZXC_TEST_SOLVER ?? 'z3'

for (const entry of cases) {
	test(`enum verification / ${entry.name}`, () => {
		const directory = mkdtempSync(join(tmpdir(), 'zxc enum verification '))

		try {
			writeFileSync(join(directory, 'main.zx'), entry.source)
			for (const [name, source] of Object.entries(entry.files)) writeFileSync(join(directory, name), source)
			const result = spawnSync(executable, ['verify', 'main.zx', '--solver', solver, '--out', 'proof.smt2'], {
				cwd: directory,
				encoding: 'utf8',
				timeout: 60_000
			})
			assert.ifError(result.error)
			assert.equal(result.signal, null)
			assert.equal(result.status, entry.result === 'proved' ? 0 : 1, result.stderr)
			assert.equal(result.stdout, '')

			const prefix = join(directory, 'proof.smt2')
			const query = readFileSync(prefix, 'utf8')
			const width = Math.max(1, Math.ceil(Math.log2(entry.count)))
			const declaration = query.match(/\(declare-fun (input_\d+) \(\) \(_ BitVec (\d+)\)\)/)
			assert.ok(declaration, query)
			const symbol = declaration[1]
			assert.equal(Number(declaration[2]), width)
			assert.ok(query.includes(`(assert (bvule ${symbol} (_ bv${entry.count - 1} ${width})))`), query)
			assert.match(readFileSync(prefix + '.solver.txt', 'utf8'), /Z3 version/)
			const evidence = JSON.parse(readFileSync(prefix + '.source.json', 'utf8')) as {
				sources: Array<{ source: string }>
			}
			assert.ok(evidence.sources.some(source => source.source === entry.source))
			assert.equal(
				readFileSync(prefix + '.preconditions.result.txt', 'utf8').trim(),
				entry.result === 'infeasible' ? 'unsat' : 'sat'
			)
			assert.equal(
				readFileSync(prefix + '.result.txt', 'utf8').trim(),
				entry.result === 'proved' ? 'unsat' : entry.result === 'counterexample' ? 'sat' : 'not_proved'
			)

			if (entry.result === 'proved') assert.match(result.stderr, /^verified:/)
			else if (entry.result === 'infeasible') assert.match(result.stderr, /preconditions are unsat/)
			else {
				assert.match(result.stderr, /verification failed: counterexample/)
				const model = readFileSync(prefix + '.model.txt', 'utf8')
				const value = model.match(
					new RegExp(`define-fun ${symbol} \\(\\) \\(_ BitVec ${width}\\)\\s+(#b[01]+|#x[0-9a-f]+)`)
				)
				assert.ok(value, model)
				assert.equal(Number.parseInt(value[1].slice(2), value[1].startsWith('#b') ? 2 : 16), entry.count - 1)
			}
		} finally {
			rmSync(directory, { recursive: true, force: true })
		}
	})
}
