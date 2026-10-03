import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import checkClocked from './clocked_test.ts'

type Port = { name: string; path: string; sort: { width: number } }
type Manifest = { top: string; clocked: boolean; hardware: { inputs: Array<Port>; outputs: Array<Port> } }
type Vector = { input: Record<string, number | boolean>; value: bigint; fault: boolean }

const executable = resolve(process.argv[2])
const yosys = process.env.ZXC_TEST_YOSYS
const directory = mkdtempSync(join(tmpdir(), 'zxc-hardware-evaluation-'))

function run(args: { command: string; argv: Array<string> }): string {
	const { command, argv } = args
	const result = spawnSync(command, argv, {
		cwd: directory,
		encoding: 'utf8',
		timeout: 180_000,
		maxBuffer: 8 * 1024 * 1024
	})

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)
	assert.equal(result.status, 0, result.stdout + result.stderr)

	return result.stdout
}

function numeric(value: string): bigint {
	const bits = /^\d+'([01]+)$/.exec(value)

	if (bits) return BigInt('0b' + bits[1])

	assert.match(value, /^-?\d+$/)
	return BigInt(value)
}

function check(args: { name: string; fields: string; scalar: string; body: string; vectors: Array<Vector> }): void {
	const { name, fields, scalar, body, vectors } = args
	const source = join(directory, name + '.zx')
	const rtl = join(directory, name + '.sv')

	writeFileSync(
		source,
		`export type Input = { ${fields} };\n\nexport type Output = ${scalar};\n\nexport default function (in: Input): Output {\n${body}\n}\n`
	)
	run({ command: executable, argv: ['fpga', source, '--out', rtl] })

	const manifest = JSON.parse(readFileSync(rtl + '.json', 'utf8')) as Manifest

	assert.equal(manifest.top, 'zxc_kernel')
	assert.equal(manifest.clocked, false)
	assert.equal(manifest.hardware.outputs.length, 1)

	const output = manifest.hardware.outputs[0]
	const commands = [`read_verilog -sv ${JSON.stringify(rtl)}`, 'prep -top zxc_kernel', 'check -assert']

	for (const vector of vectors) {
		const settings = manifest.hardware.inputs
			.map(port => {
				const value = vector.input[port.path.replace(/^in\./, '')]

				assert.notEqual(value, undefined, port.path)
				const bits = BigInt.asUintN(port.sort.width, BigInt(value))

				return `-set ${port.name} ${port.sort.width}'d${bits}`
			})
			.join(' ')

		commands.push(`eval ${settings} -show ${output.name} -show fault`)
	}

	const script = join(directory, name + '.ys')

	writeFileSync(script, commands.join('\n') + '\n')
	const log = run({ command: yosys!, argv: ['-Q', '-T', '-s', script] })
	const results = [...log.matchAll(/Eval result: \\(\w+) = (\d+'[01xz]+|-?\d+)\./g)]

	assert.equal(results.length, vectors.length * 2, log)

	for (const [index, vector] of vectors.entries()) {
		const data = results[index * 2]
		const fault = results[index * 2 + 1]

		assert.equal(data[1], output.name)
		assert.equal(fault[1], 'fault')
		assert.equal(
			numeric(fault[2]),
			vector.fault ? 1n : 0n,
			`${name}/${index} fault ${JSON.stringify(vector.input)}`
		)

		if (!vector.fault) {
			assert.equal(
				BigInt.asUintN(output.sort.width, numeric(data[2])),
				BigInt.asUintN(output.sort.width, vector.value),
				`${name}/${index} value`
			)
		}
	}

	console.log(`Hardware RTL ${name}: ${vectors.length} independent input/fault checks passed`)
}

try {
	assert.ok(yosys, 'Set ZXC_TEST_YOSYS to an installed Yosys or YoWASP Yosys executable')
	const unsigned: Array<Vector> = []
	const signed: Array<Vector> = []

	for (const left of [0, 1, 127, 128, 254, 255]) {
		for (const right of [0, 1, 127, 128, 254, 255]) {
			for (const enabled of [false, true]) {
				const value = BigInt(enabled ? left + right : left)

				unsigned.push({ input: { left, right, enabled }, value, fault: enabled && value > 255n })
			}
		}
	}

	for (const left of [-2147483648, -2147483647, -1, 0, 1, 2147483647]) {
		for (const right of [-2147483648, -1, 0, 1, 2, 2147483647]) {
			for (const division of [false, true]) {
				const fault = right === 0 || (division && left === -2147483648 && right === -1)
				const value = fault ? 0n : division ? BigInt(left) / BigInt(right) : BigInt(left) % BigInt(right)

				signed.push({ input: { left, right, division }, value, fault })
			}
		}
	}

	check({
		name: 'conditional_add',
		fields: 'left: u8; right: u8; enabled: bool;',
		scalar: 'u8',
		body: '  if (in.enabled) {\n    return in.left + in.right;\n  }\n\n  return in.left;',
		vectors: unsigned
	})
	check({
		name: 'signed_division_remainder',
		fields: 'left: i32; right: i32; division: bool;',
		scalar: 'i32',
		body: '  if (in.division) {\n    return in.left / in.right;\n  }\n\n  return in.left % in.right;',
		vectors: signed
	})
	checkClocked({ executable, yosys, directory, run })
} finally {
	rmSync(directory, { recursive: true, force: true })
}
