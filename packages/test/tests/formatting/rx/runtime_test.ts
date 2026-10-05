import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { test } from 'node:test'
import createFixture from './fixture.ts'

const solver = process.env.ZXC_TEST_SOLVER ?? 'z3'

test('RX formatting preserves execution before and after writing through the real CLI', () => {
	const fixture = createFixture()

	try {
		writeFileSync(join(fixture.root, 'pkg.yaml'), 'name: formatting\nversion: 1.0.0\n')
		const source =
			'<Module>\n\n  <Call fn="identity" in={$in} out="ctx.value" />\n  <!-- 保留运行路径 -->\n  <Return value={ctx.value} />\n\n</Module>\n'
		const path = join(fixture.root, 'main.rx')
		writeFileSync(path, source)
		writeFileSync(
			join(fixture.root, 'identity.zx'),
			'export type Input = u8\n\nexport type Output = u8\n\nexport default function (in: Input): Output {\n  return in\n}\n'
		)
		const outputs: Array<Array<number>> = []

		for (const phase of ['before', 'after']) {
			if (phase === 'after') {
				const formatted = fixture.run(['fmt', 'main.rx', '--write'])
				assert.equal(formatted.status, 0, formatted.stderr)
				assert.notEqual(readFileSync(path, 'utf8'), source)
			}
			const application = join(fixture.root, process.platform === 'win32' ? `${phase}.exe` : phase)
			const built = fixture.run(['build', 'main.rx', '--out', application, '--solver', solver, '--no-cache'])
			assert.equal(built.status, 0, built.stderr)
			const values: Array<number> = []

			for (const input of [0, 1, 127, 255]) {
				const result = fixture.run([String(input)], application)
				assert.equal(result.status, 0, result.stderr)
				const value: unknown = JSON.parse(result.stdout)
				assert.equal(value, input)
				values.push(value as number)
			}
			outputs.push(values)
		}
		assert.deepEqual(outputs[0], outputs[1])
	} finally {
		fixture.cleanup()
	}
})
