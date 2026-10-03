import { spawnSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { parseJson, stringify } from '../../../../packages/test/src/shared/json.ts'

const temporary = mkdtempSync(join(tmpdir(), 'zxc-comment-range-'))

try {
	const row = parseJson<{ expected: { terminators: Array<number> } }>(
		readFileSync('packages/test/tests/language/lexical/comments/block/unicode.jsonl', 'utf8').split('\n')[0]
	)
	row.expected.terminators = []
	const catalog = join(temporary, 'wrong.jsonl')
	const source = join(temporary, 'cases.zig')
	writeFileSync(catalog, stringify(row) + '\n')
	const emit = spawnSync(process.execPath, ['packages/test/src/emit_frontend_tests.ts', catalog, source], {
		encoding: 'utf8'
	})
	if (emit.status !== 0) throw new Error(emit.stderr)

	const result = spawnSync(
		'zig',
		[
			'test',
			'--dep',
			'support',
			'-Mroot=' + source,
			'--dep',
			'compiler',
			'-Msupport=' + resolve('packages/test/tests/support/frontend.zig'),
			'--dep',
			'frontend',
			'--dep',
			'zx',
			'--dep',
			'genz',
			'--dep',
			'lint',
			'-Mcompiler=' + resolve('packages/compiler/src/root.zig'),
			'--dep',
			'zx',
			'-Mfrontend=' + resolve('packages/compiler/src/frontend.zig'),
			'-Mzx=' + resolve('packages/zx/src/root.zig'),
			'-Mgenz=' + resolve('packages/genz/src/root.zig'),
			'--dep',
			'zx',
			'-Mlint=' + resolve('packages/lint/src/root.zig')
		],
		{ encoding: 'utf8' }
	)
	writeFileSync('/tmp/zxc-test262-block-mutation.log', result.stdout + result.stderr)
	if (
		result.status === 0 ||
		!result.stderr.includes('Unicode comment line U+000A') ||
		!result.stderr.includes('TestUnexpectedResult') ||
		!result.stderr.includes('1 failed')
	)
		throw new Error('range verification did not reject wrong line policy: ' + result.stderr)

	console.log('PASS: empty terminator expectation failed at U+000A; repository catalog unchanged')
} finally {
	rmSync(temporary, { recursive: true, force: true })
}
