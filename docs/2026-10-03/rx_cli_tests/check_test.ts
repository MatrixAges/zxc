import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'

type Case = {
	name: string
	files: Record<string, string>
	paths: Array<string>
	status: number
	diagnostic?: RegExp
}

const executable = resolve(process.argv[2])
const leaf = '<Module><Return value="$in"/></Module>'
const cases: Array<Case> = [
	{ name: 'single file', files: { 'leaf.rx': leaf }, paths: ['leaf.rx'], status: 0 },
	{
		name: 'relative import and spaces in paths',
		files: {
			'project space/start.rx': '<Module><Import from="../shared/leaf"/></Module>',
			'shared/leaf.rx': leaf
		},
		paths: ['project space/start.rx', 'shared/leaf.rx'],
		status: 0
	},
	{ name: 'no inputs', files: {}, paths: [], status: 1, diagnostic: /requires the complete set/ },
	{ name: 'missing file', files: {}, paths: ['absent.rx'], status: 1, diagnostic: /^absent\.rx: FileNotFound\n$/ },
	{
		name: 'missing second file',
		files: { 'leaf.rx': leaf },
		paths: ['leaf.rx', 'absent.rx'],
		status: 1,
		diagnostic: /^absent\.rx: FileNotFound\n$/
	},
	{
		name: 'syntax error in second input',
		files: { 'leaf.rx': leaf, 'broken.rx': '<Module>\n' },
		paths: ['leaf.rx', 'broken.rx'],
		status: 1,
		diagnostic: /^broken\.rx:2:1: syntax:/
	},
	{
		name: 'wrong root',
		files: { 'wrong.rx': '<Gateway/>' },
		paths: ['wrong.rx'],
		status: 1,
		diagnostic: /^wrong\.rx:1:1: /
	},
	{
		name: 'missing dependency',
		files: { 'a.rx': '<Module><Import from="absent"/></Module>' },
		paths: ['a.rx'],
		status: 1,
		diagnostic: /^a\.rx:1:23: /
	},
	{
		name: 'unused import cycle',
		files: { 'a.rx': '<Module><Import from="b"/></Module>', 'b.rx': '<Module>\n  <Import from="a"/>\n</Module>' },
		paths: ['a.rx', 'b.rx'],
		status: 1,
		diagnostic: /^b\.rx:2:17: /
	},
	{
		name: 'duplicate normalized input',
		files: { 'leaf.rx': leaf },
		paths: ['leaf.rx', './leaf.rx'],
		status: 1,
		diagnostic: /^\.\/leaf\.rx:1:1: /
	},
	{
		name: 'file size bound',
		files: { 'large.rx': ' '.repeat(16 * 1024 * 1024 + 1) },
		paths: ['large.rx'],
		status: 1,
		diagnostic: /^large\.rx: StreamTooLong\n$/
	}
]

for (const scenario of cases) {
	const directory = mkdtempSync(join(tmpdir(), 'zxc-rx-cli-'))

	try {
		for (const [path, source] of Object.entries(scenario.files)) {
			const destination = join(directory, path)

			mkdirSync(dirname(destination), { recursive: true })
			writeFileSync(destination, source)
		}

		const result = spawnSync(executable, ['check-rx', ...scenario.paths], {
			cwd: directory,
			encoding: 'utf8',
			timeout: 30_000
		})

		assert.ifError(result.error)
		assert.equal(result.signal, null, scenario.name)
		assert.equal(result.status, scenario.status, `${scenario.name}: ${result.stderr}`)
		assert.equal(result.stdout, '', scenario.name)

		if (scenario.diagnostic) assert.match(result.stderr, scenario.diagnostic, scenario.name)
		else assert.equal(result.stderr, '', scenario.name)

		for (const [path, source] of Object.entries(scenario.files)) {
			assert.equal(readFileSync(join(directory, path), 'utf8'), source, scenario.name)
		}
	} finally {
		rmSync(directory, { recursive: true, force: true })
	}
}

console.log(`RX CLI: ${cases.length} scenarios passed`)
