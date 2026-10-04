import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'

type Case = {
	name: string
	input: string
	output: string
	clauses?: string
	body: string
	result: 'proved' | 'counterexample' | 'infeasible' | 'unsupported'
}

const executable = resolve(process.argv[2])
const solver = process.env.ZXC_TEST_SOLVER ?? 'z3'
const cases: Array<Case> = [
	{
		name: 'bounded increment',
		input: 'u8',
		output: 'u8',
		clauses: 'requires(in < 255) ensures(out > in)',
		body: 'return in + 1\n',
		result: 'proved'
	},
	{ name: 'overflow counterexample', input: 'u8', output: 'u8', body: 'return in + 1\n', result: 'counterexample' },
	{
		name: 'false postcondition',
		input: 'u8',
		output: 'u8',
		clauses: 'requires(in < 255) ensures(out == in)',
		body: 'return in + 1\n',
		result: 'counterexample'
	},
	{
		name: 'false precondition',
		input: 'u8',
		output: 'u8',
		clauses: 'requires(false)',
		body: 'return in\n',
		result: 'infeasible'
	},
	{
		name: 'branch excludes overflow',
		input: 'u8',
		output: 'u8',
		clauses: 'ensures(out >= in)',
		body: 'if (in == 255) {\n    return in\n  }\n\n  return in + 1\n',
		result: 'proved'
	},
	{
		name: 'division nonzero',
		input: '{ a: u8\n b: u8 }',
		output: 'u8',
		clauses: 'requires(in.b > 0) ensures(out <= in.a)',
		body: 'return in.a / in.b\n',
		result: 'proved'
	},
	{
		name: 'division zero counterexample',
		input: '{ a: u8\n b: u8 }',
		output: 'u8',
		body: 'return in.a / in.b\n',
		result: 'counterexample'
	},
	{
		name: 'short circuit guards division',
		input: 'u8',
		output: 'bool',
		body: 'return in == 0 || 10 / in > 0\n',
		result: 'proved'
	},
	{
		name: 'conditional guards division',
		input: 'u8',
		output: 'u8',
		body: 'return in == 0 ? 0 : 10 / in\n',
		result: 'proved'
	},
	{
		name: 'signed negation counterexample',
		input: 'i32',
		output: 'i32',
		body: 'return -in\n',
		result: 'counterexample'
	},
	{
		name: 'signed bounded negation',
		input: 'i32',
		output: 'i32',
		clauses: 'requires(in > -2147483648)',
		body: 'return -in\n',
		result: 'proved'
	},
	{
		name: 'boolean postcondition',
		input: 'bool',
		output: 'bool',
		clauses: 'ensures(out == !in)',
		body: 'return !in\n',
		result: 'proved'
	},
	{ name: 'floating unsupported', input: 'f64', output: 'f64', body: 'return in\n', result: 'unsupported' },
	{
		name: 'match guards division',
		input: 'u8',
		output: 'u8',
		body: 'return match in { 0 => 0, _ => 10 / in }\n',
		result: 'proved'
	},
	{
		name: 'match selected unsafe arm',
		input: 'u8',
		output: 'u8',
		body: 'return match in { 0 => 10 / in, _ => 0 }\n',
		result: 'counterexample'
	},
	{
		name: 'guard match skips later condition',
		input: 'u8',
		output: 'u8',
		body: 'return match { in == 0 => 0, 10 / in > 0 => 1, _ => 2 }\n',
		result: 'proved'
	},
	{
		name: 'guard match first arm wins',
		input: 'u8',
		output: 'u8',
		clauses: 'ensures(out == in)',
		body: 'return match { true => in, 10 / in > 0 => 0, _ => 0 }\n',
		result: 'proved'
	},
	{
		name: 'match false postcondition',
		input: 'u8',
		output: 'u8',
		clauses: 'ensures(out == in)',
		body: 'return match in { 0 => 1, _ => in }\n',
		result: 'counterexample'
	},
	{
		name: 'match unsafe subject',
		input: 'u8',
		output: 'u8',
		body: 'return match 10 / in { 0 => 0, _ => 0 }\n',
		result: 'counterexample'
	},
	{
		name: 'match bounded subject',
		input: 'u8',
		output: 'u8',
		clauses: 'requires(in > 0) ensures(out == 0)',
		body: 'return match 10 / in { 0 => 0, _ => 0 }\n',
		result: 'proved'
	}
]

for (const scenario of cases) {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-verification-'))

	try {
		const source = `export type Input = ${scenario.input}

export type Output = ${scenario.output}

export default function (in: Input): Output ${scenario.clauses ?? ''} {\n  ${scenario.body.trimEnd()}\n}\n`

		writeFileSync(join(directory, 'main.zx'), source)

		const result = spawnSync(executable, ['verify', 'main.zx', '--solver', solver, '--out', 'proof.smt2'], {
			cwd: directory,
			encoding: 'utf8',
			timeout: 60_000
		})
		const context = `${scenario.name}: ${result.stderr}`

		assert.ifError(result.error)
		assert.equal(result.signal, null, context)
		assert.equal(result.status, scenario.result === 'proved' ? 0 : 1, context)
		assert.equal(result.stdout, '', context)

		if (scenario.result === 'unsupported') {
			assert.match(
				result.stderr,
				/verification currently supports boolean and fixed-width integer inputs/,
				context
			)
			assert.equal(existsSync(join(directory, 'proof.smt2')), false, context)
			continue
		}

		assert.match(readFileSync(join(directory, 'proof.smt2'), 'utf8'), /\(check-sat\)/, context)
		assert.match(readFileSync(join(directory, 'proof.smt2.preconditions.smt2'), 'utf8'), /\(check-sat\)/, context)
		assert.match(readFileSync(join(directory, 'proof.smt2.solver.txt'), 'utf8'), /Z3 version/, context)
		const evidence = JSON.parse(readFileSync(join(directory, 'proof.smt2.source.json'), 'utf8')) as {
			sources: Array<{ source: string }>
		}

		assert.equal(evidence.sources[0].source, source, context)

		if (scenario.result === 'infeasible') {
			assert.match(result.stderr, /preconditions are unsat/, context)
			assert.equal(readFileSync(join(directory, 'proof.smt2.result.txt'), 'utf8'), 'not_proved', context)
			assert.equal(readFileSync(join(directory, 'proof.smt2.preconditions.result.txt'), 'utf8'), 'unsat', context)
		} else {
			assert.equal(readFileSync(join(directory, 'proof.smt2.preconditions.result.txt'), 'utf8'), 'sat', context)
			assert.equal(
				readFileSync(join(directory, 'proof.smt2.result.txt'), 'utf8').trim(),
				scenario.result === 'proved' ? 'unsat' : 'sat',
				context
			)

			if (scenario.result === 'proved') assert.match(result.stderr, /^verified:/, context)
			else {
				assert.match(result.stderr, /verification failed: counterexample/, context)
				assert.match(
					readFileSync(join(directory, 'proof.smt2.model.txt'), 'utf8'),
					/define-fun input_/,
					context
				)
			}
		}
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
}

console.log(`Verification CLI: ${cases.length} scenarios passed`)
