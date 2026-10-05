import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { test } from 'node:test'

const executable = resolve(process.argv[2])
const optimize = process.argv[3]

function fixture(files: Record<string, string>) {
	const directory = mkdtempSync(join(tmpdir(), 'zxc iterate '))
	const application = join(directory, process.platform === 'win32' ? 'application.exe' : 'application')

	for (const [path, source] of Object.entries(files)) writeFileSync(join(directory, path), source)

	function run(command: string, argv: Array<string>) {
		const result = spawnSync(command, argv, { cwd: directory, encoding: 'utf8', timeout: 180_000 })

		assert.ifError(result.error)
		assert.equal(result.signal, null)

		return result
	}

	return {
		application,
		build(entry: string) {
			const result = run(executable, ['build', entry, '--out', application, '--optimize', optimize])

			assert.equal(result.status, 0, result.stderr)
		},
		execute(input: unknown) {
			return run(application, [JSON.stringify(input)])
		},
		cleanup() {
			try {
				for (const [path, source] of Object.entries(files))
					assert.equal(readFileSync(join(directory, path), 'utf8'), source)
			} finally {
				rmSync(directory, { recursive: true, force: true })
			}
		}
	}
}

for (const post of [false, true]) {
	test(`iterate CLI / ${post ? 'postcondition' : 'precondition'} evaluation order`, () => {
		const current = fixture({
			'source.zx':
				'import process from "std:process"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  process.writeStdoutText("I|")\n\n  return in\n}\n',
			'condition.zx':
				'import process from "std:process"\n\nexport type Input = u64\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n  process.writeStdoutText("C|")\n\n  return in < 3\n}\n',
			'main.zx': `import process from "std:process"

import condition from "./condition"
import source from "./source"

export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return iterate(source(in), {
    while: state => condition(state),
    ${post ? 'do' : 'next'}: state => {
      process.writeStdoutText("S|")

      state += 1
    }
  })
}
`
		})

		try {
			current.build('main.zx')

			for (const input of [0, 2, 3, 7]) {
				const rounds = post ? Math.max(3 - input, 1) : Math.max(3 - input, 0)
				const trace = post ? 'S|C|'.repeat(rounds) : 'C|S|'.repeat(rounds) + 'C|'
				const result = current.execute(input)

				assert.equal(result.status, 0, result.stderr)
				assert.equal(result.stderr, '')
				assert.equal(result.stdout, 'I|' + trace + String(input + rounds) + '\n')
			}
		} finally {
			current.cleanup()
		}
	})
}

test('iterate CLI / index failure precedes right hand side effects', () => {
	const current = fixture({
		'position.zx':
			'import process from "std:process"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  process.writeStdoutText("P|")\n\n  return in\n}\n',
		'value.zx':
			'import process from "std:process"\n\nexport type Input = i64\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  process.writeStdoutText("V|")\n\n  return in\n}\n',
		'main.zx': `import position from "./position"
import value from "./value"

export type Input = { values: i64[], count: u64 }

export type State = { values: i64[], count: u64, index: u64 }

export type Output = i64[]

export default function (in: Input): Output {
  const initial: State = { values: in.values, count: in.count, index: 0 }

  const result = iterate(initial, {
    while: state => state.index < state.count,
    next: state => {
      state.values[position(state.index)] = value(7)
      state.index += 1
    }
  })

  return result.values
}
`
	})

	try {
		current.build('main.zx')

		for (const values of [[], [1], [1, 2]]) {
			const result = current.execute({ values, count: values.length + 1 })

			assert.equal(result.status, 1, result.stderr)
			assert.match(result.stderr, /IndexOutOfBounds/)
			assert.equal(result.stdout, 'P|V|'.repeat(values.length) + 'P|')
		}
	} finally {
		current.cleanup()
	}
})

test('iterate RX / dynamic writes preserve initial values', () => {
	const current = fixture({
		'main.rx':
			'<Module>\n  <Return value={{ original: $in.values, result: iterate({ values: $in.values, count: $in.count, index: 0 }, { while: state => state.index < state.count, next: state => { state.values[state.index] += 1\n state.index += 1 } }) }}/>\n</Module>\n'
	})

	try {
		current.build('main.rx')

		for (const values of [[], [0], [1, 2, 3], [7, 7, 0]]) {
			const result = current.execute({ values, count: values.length })

			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
			assert.deepEqual(JSON.parse(result.stdout), {
				original: values,
				result: { values: values.map(value => value + 1), count: values.length, index: values.length }
			})
		}
	} finally {
		current.cleanup()
	}
})

test('iterate import shadows the built in without changing its calling convention', () => {
	const current = fixture({
		'helper.zx':
			'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in + 1\n}\n',
		'main.zx':
			'import iterate from "./helper"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return iterate(in)\n}\n'
	})

	try {
		current.build('main.zx')

		for (const input of [0, 7, 123]) {
			const result = current.execute(input)

			assert.equal(result.status, 0, result.stderr)
			assert.equal(result.stderr, '')
			assert.equal(result.stdout.trim(), String(input + 1))
		}
	} finally {
		current.cleanup()
	}
})
