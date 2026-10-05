import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { dirname } from 'node:path'

export default function typecheck(path: string): number {
	const require = createRequire(import.meta.url)
	const compiler = require.resolve('typescript/bin/tsc')
	const type_root = dirname(dirname(require.resolve('@types/node/package.json')))
	const result = spawnSync(
		process.execPath,
		[
			compiler,
			'--ignoreConfig',
			'--noEmit',
			'--strict',
			'--exactOptionalPropertyTypes',
			'--target',
			'ES2024',
			'--module',
			'NodeNext',
			'--typeRoots',
			type_root,
			'--types',
			'node',
			path
		],
		{ encoding: 'utf8', timeout: 60_000 }
	)

	assert.ifError(result.error)
	assert.equal(result.signal, null)
	assert.equal(result.status, 0, result.stdout + result.stderr)

	return (readFileSync(path, 'utf8').match(/@ts-expect-error/g) ?? []).length + 1
}
