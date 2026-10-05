import type { Build } from './publication.ts'
import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { cpSync, mkdtempSync, readFileSync, realpathSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join } from 'node:path'
import checkPublication from './publication.ts'
import typecheck from './typecheck.ts'

const [compiler_path, fixture_path, consumer_path, optimize] = process.argv.slice(2)
const compiler = realpathSync(compiler_path)
const root = realpathSync(mkdtempSync(join(tmpdir(), 'zxc-napi-bindings-')))
const project = join(root, 'project')
let count = 0

const build: Build = args => {
	const { source, output, extra = [], failure } = args
	const result = spawnSync(
		compiler,
		['build', join(project, source), '--host', 'node', '--optimize', optimize, '--out', output, ...extra],
		{ cwd: project, encoding: 'utf8', timeout: 180_000 }
	)

	assert.ifError(result.error)
	assert.equal(result.signal, null, result.stderr)

	if (failure) {
		assert.notEqual(result.status, 0)
		assert.ok(result.stderr.includes(failure), result.stderr)
	} else assert.equal(result.status, 0, result.stderr)
}

function execute(args: { module: string; mode: string; body: string }): void {
	const { module, mode, body } = args
	const source =
		mode === 'module'
			? `import assert from 'node:assert/strict'; import { execute } from ${JSON.stringify(module)}; ${body}`
			: `const assert = require('node:assert/strict'); const { execute } = require(${JSON.stringify(module)}); ${body}`
	const result = spawnSync(process.execPath, [`--input-type=${mode}`, '-e', source], {
		cwd: root,
		encoding: 'utf8',
		timeout: 30_000
	})

	assert.ifError(result.error)
	assert.equal(result.status, 0, result.stderr)
}

try {
	cpSync(realpathSync(fixture_path), project, { recursive: true })
	cpSync(realpathSync(consumer_path), join(root, 'consumer.mts'))

	for (const name of ['no_input', 'no_output']) {
		cpSync(join(dirname(realpathSync(consumer_path)), `${name}.zx`), join(project, `${name}.zx`))
		build({ source: `${name}.zx`, output: join(root, `${name}.node`) })
	}

	build({ source: 'record.zx', output: join(root, 'addon.node') })
	build({ source: 'scalars/void.zx', output: join(root, 'void.node') })
	build({ source: 'state/main.rx', output: join(root, 'state.node') })
	count += typecheck(join(root, 'consumer.mts'))
	console.log(`${count} TypeScript declaration checks passed`)

	for (const mode of ['commonjs', 'module']) {
		execute({
			module: './addon.cjs',
			mode,
			body: "const result = execute({name:'typed',bytes:[1,2],count:3n,pair:[true,0.5],mode:'Read',values:[1n],nested:[{value:'x'}]}); assert.ok(Buffer.isBuffer(result.bytes)); assert.equal(result.count,3n); assert.equal(result.note,null);"
		})
		execute({ module: './void.cjs', mode, body: 'assert.equal(execute(),undefined);' })
		execute({ module: './no_input.cjs', mode, body: 'assert.equal(execute(),9n);' })
		execute({ module: './no_output.cjs', mode, body: 'assert.equal(execute(1n),undefined);' })
		execute({ module: './state.cjs', mode, body: 'assert.equal(execute(1n),4n); assert.equal(execute(2n),6n);' })
		count += 5
	}

	count += checkPublication({ build, project, root })

	for (const mode of ['commonjs', 'module']) {
		execute({ module: './addon.cjs', mode, body: 'assert.equal(execute(),undefined);' })
		count += 1
	}

	const unusual = 'quoted "中 name'

	build({ source: 'scalars/void.zx', output: join(root, `${unusual}.node`) })
	execute({ module: `./${unusual}.cjs`, mode: 'module', body: 'assert.equal(execute(),undefined);' })
	assert.ok(readFileSync(join(root, `${unusual}.d.cts`), 'utf8').includes('export function execute()'))
	count += 1
	console.log(`${count} NAPI module binding cases passed (${optimize})`)
} finally {
	rmSync(root, { recursive: true, force: true })
}
