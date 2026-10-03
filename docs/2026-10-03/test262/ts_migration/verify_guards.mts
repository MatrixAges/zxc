import { spawnSync } from 'node:child_process'
import { cpSync, globSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { isDeepStrictEqual } from 'node:util'
import { parseJson, stringify } from '../../../../packages/test/src/shared/json.ts'
import { metadata } from '../../../../packages/test/src/inventory_upstream.ts'

const package_dir = resolve('packages/test')
const temporary = mkdtempSync(join(tmpdir(), 'zxc-ts-migration-'))

function rejected(script: string, diagnostic: string): void {
	const result = spawnSync(process.execPath, [join(temporary, 'src', script)], { encoding: 'utf8' })

	if (result.status === 0 || result.stdout !== '' || !result.stderr.includes(diagnostic))
		throw new Error(`guard did not reject as expected: ${script}\n${result.stderr}`)
}

try {
	for (const name of ['src', 'tests', 'upstream', 'suites.json', 'package.json'])
		cpSync(join(package_dir, name), join(temporary, name), { recursive: true })

	const facts_path = join(temporary, 'upstream/metadata/language.jsonl')
	const facts = readFileSync(facts_path, 'utf8')
	writeFileSync(facts_path, facts.slice(facts.indexOf('\n') + 1))
	rejected('audit_matrix.ts', 'complete upstream index')
	rejected('query_upstream.ts', 'complete upstream index')
	writeFileSync(facts_path, facts)

	const review_path = join(temporary, 'upstream/reviews/language/expressions/float_relational.jsonl')
	const reviews = readFileSync(review_path, 'utf8')
		.trimEnd()
		.split('\n')
		.map(line => parseJson<{ assertions: Array<{ expected: boolean }> }>(line))
	reviews[0].assertions[0].expected = !reviews[0].assertions[0].expected
	writeFileSync(review_path, reviews.map(row => JSON.stringify(row)).join('\n') + '\n')
	rejected('audit_matrix.ts', 'review assertion does not match')

	const frontend = globSync('tests/language/lexical/numeric/invalid.jsonl', { cwd: package_dir })[0]
	const line = readFileSync(join(package_dir, frontend), 'utf8').split('\n')[0]
	const duplicate_path = join(temporary, 'duplicate.jsonl')
	writeFileSync(duplicate_path, line + '\n' + line + '\n')
	const duplicate = spawnSync(
		process.execPath,
		[join(temporary, 'src/emit_frontend_tests.ts'), duplicate_path, join(temporary, 'cases.zig')],
		{ encoding: 'utf8' }
	)
	if (duplicate.status === 0 || !duplicate.stderr.includes('duplicate case ID'))
		throw new Error('duplicate emission guard failed')

	const large = { minimum: -(2n ** 63n), maximum: 2n ** 64n - 1n, nearby: 2n ** 64n - 2n }
	if (!isDeepStrictEqual(parseJson(stringify(large)), large)) throw new Error('integer JSON precision lost')

	for (const [source, status] of [
		['/*---\ndescription: first\ndescription: second\n---*/', 'error'],
		['/*---\nfeatures: string\n---*/', 'error'],
		['/*---\nnegative: null\n---*/', 'error'],
		['/*---\rdescription: CR\rnegative:\r  phase: parse\r  type: SyntaxError\r---*/', 'parsed'],
		['const absent = true;', 'missing']
	]) {
		if (metadata(Buffer.from(source)).metadata_status !== status)
			throw new Error(`metadata guard failed: ${status}`)
	}

	console.log(
		'PASS: metadata completeness, query withholding, review expectation binding, duplicate emission, exact integer JSON, YAML validation and CR newlines'
	)
} finally {
	rmSync(temporary, { recursive: true, force: true })
}
