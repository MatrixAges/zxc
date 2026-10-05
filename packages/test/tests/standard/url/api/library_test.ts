import type { Json } from '../../../../src/shared/json.ts'
import assert from 'node:assert/strict'
import { isUtf8 } from 'node:buffer'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, readdirSync, realpathSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { readRows } from '../../../../src/shared/json.ts'

type Case = { id: string; input: Json; expected: { value?: Json; error?: string } }

const [compiler_path, source_path, optimize] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const source = realpathSync(source_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-url-library-')))
const extension = process.platform === 'win32' ? '.exe' : ''
let total = 0

function run(args: { command: string; argv: Array<string>; expected_error?: string }): string {
	const { command, argv, expected_error } = args
	const result = spawnSync(command, argv, { cwd: root, encoding: 'utf8', timeout: 180_000 })

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)

	if (expected_error) {
		assert.notEqual(result.status, 0, expected_error)
		assert.ok(result.stderr.includes(expected_error), result.stderr)
	} else assert.equal(result.status, 0, result.stderr)

	return result.stdout
}

try {
	writeFileSync(
		join(root, 'pkg.yaml'),
		'name: url-api-consumer\nversion: 0.0.0\nentry: main.zx\ndependencies:\n  library: workspace:*\nworkspace:\n  packages: [library]\n'
	)
	writeFileSync(
		join(root, 'main.zx'),
		'import library from "library"\nimport type { Input, Output } from "library"\n\nexport default function (in: Input): Output {\n  return library(in)\n}\n'
	)

	for (const directory of readdirSync(source, { withFileTypes: true }).filter(entry => entry.isDirectory())) {
		const path = join(source, directory.name, 'cases')
		const output = join(root, `consume-${directory.name}${extension}`)

		rmSync(join(root, 'library'), { recursive: true, force: true })
		run({
			command: compiler,
			argv: ['build', `${path}.zx`, '--mode', 'lib', '--out', join(root, 'library')]
		})

		const manifest = readFileSync(join(root, 'library', 'pkg.yaml'), 'utf8')

		assert.ok(manifest.includes('zxc_standard'), manifest)
		run({ command: compiler, argv: ['build', join(root, 'main.zx'), '--out', output, '--optimize', optimize] })

		const rows = readRows<Case>(`${path}.jsonl`)
		const output_is_bytes = /export type Output = u8\[\]/.test(readFileSync(`${path}.zx`, 'utf8'))

		for (const row of rows) {
			const result = run({
				command: output,
				argv: [JSON.stringify(row.input)],
				expected_error: row.expected.error
			})

			if (!row.expected.error) {
				let expected = row.expected.value

				if (output_is_bytes) {
					assert.ok(Array.isArray(expected))

					const bytes = Buffer.from(expected as Array<number>)

					if (isUtf8(bytes)) expected = bytes.toString()
				}

				assert.deepEqual(JSON.parse(result), expected, row.id)
			}
		}

		total += rows.length
		console.log(`${directory.name}: ${rows.length} published library cases passed`)
	}

	assert.equal(total, 6193)
	console.log(`${total} URL cases passed through published native dependencies and ZX consumers (${optimize})`)
} finally {
	rmSync(root, { recursive: true, force: true })
}
