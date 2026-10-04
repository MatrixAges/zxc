import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { test } from 'node:test'

type Case = {
	name: string
	paths: Array<string>
	links?: Record<string, string>
	diagnostic?: RegExp
}

const executable = resolve(process.argv[2])
const state = '<Store name="counter_state" version="1"><Object name="counter"><Field name="value" type="u64" value="3"/></Object></Store>'
const cases: Array<Case> = [
	{ name: 'normalized references share one file', paths: ['state', './state.store.rx'] },
	{ name: 'identical contents in separate files', paths: ['state', 'other'] },
	{ name: 'single internal symbolic link', paths: ['alias'], links: { 'alias.store.rx': 'project/state.store.rx' } },
	{
		name: 'physical file then symbolic alias', paths: ['state', 'alias'],
		links: { 'alias.store.rx': 'project/state.store.rx' },
		diagnostic: /^alias\.store\.rx: physical module file is already registered as state\.store\.rx\n$/
	},
	{
		name: 'symbolic alias then physical file', paths: ['alias', 'state'],
		links: { 'alias.store.rx': 'project/state.store.rx' },
		diagnostic: /^state\.store\.rx: physical module file is already registered as alias\.store\.rx\n$/
	},
	{
		name: 'file symbolic link outside root', paths: ['escape'],
		links: { 'escape.store.rx': 'outside/state.store.rx' },
		diagnostic: /^escape\.store\.rx: physical module file escapes the project root\n$/
	},
	{
		name: 'directory symbolic link outside root', paths: ['linked/state'],
		links: { linked: 'outside' },
		diagnostic: /^linked\/state\.store\.rx: physical module file escapes the project root\n$/
	},
	{
		name: 'dangling symbolic link', paths: ['missing'],
		links: { 'missing.store.rx': 'absent.store.rx' },
		diagnostic: /^missing\.store\.rx: FileNotFound\n$/
	}
]

for (const mode of ['check', 'generate']) {
	for (const scenario of cases) {
		test(`RX Store ${mode}: ${scenario.name}`, () => {
			const temporary = mkdtempSync(join(tmpdir(), 'zxc store paths '))
			const directory = join(temporary, 'project')
			const output = join(directory, 'result.zig')
			const source = '<Module>' + scenario.paths.map((path, index) => `<Store from="${path}" as="s${index}"/>`).join('') + '<Return value="1"/></Module>'
			const files = {
				'project/main.rx': source,
				'project/state.store.rx': state,
				'project/other.store.rx': state,
				'outside/state.store.rx': state
			}

			try {
				for (const [name, content] of Object.entries(files)) {
					const destination = join(temporary, name)

					mkdirSync(dirname(destination), { recursive: true })
					writeFileSync(destination, content)
				}

				for (const [name, target] of Object.entries(scenario.links ?? {})) {
					symlinkSync(join(temporary, target), join(directory, name), target === 'outside' ? 'dir' : 'file')
				}

				const args = mode === 'check' ? ['check-rx', '--entry', 'main.rx'] : ['main.rx', '--out', output]
				const result = spawnSync(executable, args, { cwd: directory, encoding: 'utf8', timeout: 30_000 })

				assert.ifError(result.error)
				assert.equal(result.signal, null, result.stderr)
				assert.equal(result.status, scenario.diagnostic ? 1 : 0, result.stderr)

				if (scenario.diagnostic) assert.match(result.stderr, scenario.diagnostic)
				else assert.equal(result.stderr, '')

				assert.equal(existsSync(output), mode === 'generate' && !scenario.diagnostic)
				if (scenario.diagnostic || mode === 'check') assert.equal(existsSync(output + '.abi.zig'), false)
				else assert.ok(readFileSync(output, 'utf8').length > 0)

				for (const [name, content] of Object.entries(files)) assert.equal(readFileSync(join(temporary, name), 'utf8'), content)
			} finally {
				rmSync(temporary, { recursive: true, force: true })
			}
		})
	}
}
