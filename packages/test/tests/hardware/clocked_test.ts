import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

type Run = (args: { command: string; argv: Array<string> }) => string

export default function checkClocked(args: { executable: string; yosys: string; directory: string; run: Run }): void {
	const { executable, yosys, directory, run } = args
	const source = join(directory, 'clocked.zx')
	const rtl = join(directory, 'clocked.sv')

	writeFileSync(
		source,
		'export type Input = u8;\n\nexport type Output = u8;\n\nexport default function (in: Input): Output {\n  return in + 3;\n}\n'
	)
	run({ command: executable, argv: ['fpga', source, '--clocked', '--out', rtl] })

	const manifest = JSON.parse(readFileSync(rtl + '.json', 'utf8')) as {
		clocked: boolean
		latency_cycles: number
		reset: string
	}

	assert.equal(manifest.clocked, true)
	assert.equal(manifest.latency_cycles, 1)
	assert.equal(manifest.reset, 'synchronous_active_high')

	const cycles = [
		[1, 1, 0, 255],
		[0, 1, 0, 5],
		[0, 1, 0, 255],
		[0, 1, 0, 2],
		[0, 1, 1, 255],
		[0, 0, 0, 7],
		[0, 0, 1, 9],
		[0, 1, 0, 1],
		[1, 1, 0, 255],
		[0, 0, 1, 255],
		[0, 1, 1, 252],
		[0, 1, 1, 253],
		[0, 0, 1, 0],
		[0, 0, 1, 0]
	]
	const expected: Array<Record<string, number>> = []
	let valid = 1
	let value = 255
	let fault = 1
	const settings: Array<string> = []

	for (const [index, [reset, input_valid, output_ready, input]] of cycles.entries()) {
		const ready = reset === 0 && (valid === 0 || output_ready === 1) ? 1 : 0

		expected.push({ input_ready: ready, output_valid: valid, output_0: value, fault })

		for (const [name, data] of Object.entries({ reset, input_valid, output_ready, input_0: input })) {
			settings.push(`-set-at ${index + 1} ${name} ${data}`)
		}

		if (reset) {
			valid = 0
			value = 0
			fault = 0
		} else if (ready) {
			valid = input_valid

			if (input_valid) {
				value = (input + 3) % 256
				fault = input + 3 > 255 ? 1 : 0
			}
		}
	}

	const script = join(directory, 'clocked.ys')

	writeFileSync(
		script,
		[
			`read_verilog -sv ${JSON.stringify(rtl)}`,
			'prep -top zxc_kernel -flatten',
			'check -assert',
			`sat -seq ${cycles.length} -set-init output_0 255 -set-init output_valid 1 -set-init fault 1 ${settings.join(' ')} -show input_ready -show output_valid -show output_0 -show fault`
		].join('\n') + '\n'
	)
	const log = run({ command: yosys, argv: ['-Q', '-T', '-s', script] })
	const rows = [
		...log.matchAll(/^\s+(\d+)\s+\\(input_ready|output_valid|output_0|fault)\s+(-?\d+)\s+\S+\s+[01]+\s*$/gm)
	]

	assert.equal(rows.length, cycles.length * 4, log)
	const seen = new Map<string, number>()

	for (const row of rows) {
		const cycle = Number(row[1])
		const signal = row[2]
		const key = `${cycle}/${signal}`

		assert.ok(cycle >= 1 && cycle <= cycles.length, key)
		assert.ok(!seen.has(key), key)
		seen.set(key, Number(row[3]))

		if (signal !== 'output_0' || (expected[cycle - 1]?.output_valid === 1 && expected[cycle - 1]?.fault === 0)) {
			assert.equal(Number(row[3]), expected[cycle - 1]?.[signal], key)
		}
	}

	for (let index = 1; index < cycles.length; index += 1) {
		if (cycles[index - 1][0] === 0 && expected[index - 1].input_ready === 0) {
			assert.equal(
				seen.get(`${index + 1}/output_0`),
				seen.get(`${index}/output_0`),
				`cycle ${index + 1} stalled output`
			)
		}
	}

	console.log(`Hardware clocked RTL: ${cycles.length} cycles and ${rows.length} signal records checked`)
}
