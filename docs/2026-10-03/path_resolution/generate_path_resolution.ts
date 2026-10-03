import { posix, win32 } from 'node:path'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type RelativeCase = {
	id: string
	input: { cwd: string; from: string; to: string }
	expected: { value: string } | { error: string }
}
type ResolveCase = {
	id: string
	input: { cwd: string; paths: Array<string> }
	expected: { value: string } | { error: string }
}

for (const [platform, path] of Object.entries({ posix, win32 })) {
	const windows = platform === 'win32'
	const cwd = windows ? 'C:\\work\\base' : '/work/base'
	const values = windows
		? ['', '.', '..', 'a', 'A', 'a\\b', 'a\\c', 'D:\\other', '\\\\server\\share\\a', '\\\\server\\share\\b']
		: ['', '.', '..', 'a', 'A', 'a/b', 'a/c', '/absolute']
	const relative_rows: Array<RelativeCase> = []

	for (const [left, from] of values.entries()) {
		for (const [right, to] of values.entries()) {
			relative_rows.push({
				id: `standard/path/${platform}/relative/${left}/${right}`,
				input: { cwd, from, to },
				expected: { value: path.relative(path.resolve(cwd, from), path.resolve(cwd, to)) }
			})
		}
	}

	if (windows) {
		const pairs = [
			['AΣ\u0345', 'aς\u0345'],
			['AΣ\u0345B', 'aσ\u0345b'],
			['\u0345Σ', '\u0345σ'],
			['A\u0345Σ', 'a\u0345ς'],
			['Σ', 'ς'],
			['ß', 'ss'],
			['Ä', 'ä'],
			['İ', 'i\u0307'],
			['ΟΣ', 'ος'],
			['ΟΣ', 'οσ'],
			['𐐀', '𐐨'],
			['A\u0301Σ', 'a\u0301ς']
		]

		for (let code = 0; code <= 0x10ffff; code += 1) {
			if (code >= 0xd800 && code <= 0xdfff) continue

			const value = String.fromCodePoint(code)
			const lower = value.toLowerCase()

			if (value !== lower) pairs.push([value, lower])
		}

		for (const [index, [a, b]] of pairs.entries()) {
			const from = `C:\\${a}`
			const to = `C:\\${b}`

			relative_rows.push({
				id: `standard/path/win32/relative/unicode/${index}`,
				input: { cwd, from, to },
				expected: { value: path.relative(from, to) }
			})
		}
	}

	for (const invalid of ['', 'relative']) {
		relative_rows.push({
			id: `standard/path/${platform}/relative/invalid_cwd/${invalid || 'empty'}`,
			input: { cwd: invalid, from: 'a', to: 'b' },
			expected: { error: 'InvalidWorkingDirectory' }
		})
	}

	const lists = windows
		? [
				[],
				['..'],
				['C:child'],
				['\\rooted'],
				['D:\\target'],
				['C:\\a', 'D:\\b', '..'],
				['\\\\server\\share\\a', '..'],
				['//server/share/a'],
				['C:..\\leaf'],
				['C:\\a', '\\b']
			]
		: [
				[],
				['..'],
				['a', '..', 'b'],
				['/a', 'b'],
				['/', '..'],
				['/a//b/', '../c'],
				['a', '/override'],
				['', ''],
				['../..'],
				['文件', '🌱']
			]
	const resolve_rows: Array<ResolveCase> = lists.map((paths, index) => ({
		id: `standard/path/${platform}/resolve/${index}`,
		input: { cwd, paths },
		expected: { value: path.resolve(cwd, ...paths) }
	}))

	for (const invalid of ['', 'relative'])
		resolve_rows.push({
			id: `standard/path/${platform}/resolve/invalid_cwd/${invalid || 'empty'}`,
			input: { cwd: invalid, paths: ['a'] },
			expected: { error: 'InvalidWorkingDirectory' }
		})

	if (windows) {
		resolve_rows.push({
			id: 'standard/path/win32/resolve/missing_drive',
			input: { cwd, paths: ['D:child'] },
			expected: { error: 'MissingDriveDirectory' }
		})
		relative_rows.push({
			id: 'standard/path/win32/relative/missing_drive',
			input: { cwd, from: 'a', to: 'D:child' },
			expected: { error: 'MissingDriveDirectory' }
		})
	}

	for (const [operation, input_type, rows] of [
		['resolve', '{ cwd: string; paths: string[]; }', resolve_rows],
		['relative', '{ cwd: string; from: string; to: string; }', relative_rows]
	] as const) {
		const base = `tests/standard/path/${platform}/${operation}`

		writeCatalog(base + '.jsonl', rows)
		writeOutput(
			base + '.zx',
			`import path from "std:path/${platform}";\n\nexport type Input = ${input_type};\n\nexport type Output = string;\n\nexport default function (in: Input): Output {\n  return path.${operation}(in);\n}\n`
		)
	}
}
