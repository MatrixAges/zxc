import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { createSerializer } from '@jlarky/gha-ts/render'
import { workflow } from '@jlarky/gha-ts/workflow-types'
import { YAML } from 'bun'
import { format, resolveConfig } from 'prettier'
import targets from './targets'

const checkout = 'actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803'
const setup_bun = 'oven-sh/setup-bun@0c5077e51419868618aeaa5fe8019c62421857d6'
const definition = workflow({
	name: 'Build zxc',
	on: { push: { branches: ['master'] }, pull_request: {}, workflow_dispatch: {} },
	permissions: { contents: 'read' },
	concurrency: { group: 'build-${{ github.ref }}', 'cancel-in-progress': true },
	jobs: {
		workflow: {
			'runs-on': 'ubuntu-24.04',
			steps: [
				{ uses: checkout },
				{ uses: setup_bun, with: { 'bun-version': '1.3.10' } },
				{ run: 'bun install --cwd .github --frozen-lockfile' },
				{ run: 'bun run --cwd .github check' }
			]
		},
		build: {
			needs: ['workflow'],
			'runs-on': '${{ matrix.runner }}',
			'timeout-minutes': 30,
			strategy: { 'fail-fast': false, matrix: { include: targets } },
			env: { ZXC_TARGET: '${{ matrix.target }}' },
			steps: [
				{ uses: checkout },
				{ uses: setup_bun, with: { 'bun-version': '1.3.10' } },
				{
					uses: 'mlugg/setup-zig@d1434d08867e3ee9daa34448df10607b98908d29',
					with: { version: '0.16.0', 'cache-key': '${{ matrix.target }}' }
				},
				{ name: 'Build, execute and package', run: 'bun .github/scripts/package.ts' },
				{
					uses: 'actions/upload-artifact@ea165f8d65b6e75b540449e92b4886f43607fa02',
					with: {
						name: 'zxc-${{ matrix.target }}',
						path: '.zxc/artifacts/*',
						'if-no-files-found': 'error',
						'include-hidden-files': true,
						'compression-level': 0
					}
				}
			]
		}
	}
})

const output_path = resolve(import.meta.dir, '../workflows/build.generated.yml')
const check = process.argv.includes('--check')
const serializer = createSerializer(definition, YAML.stringify)
const output = await format(serializer.stringifyWorkflow(), { ...(await resolveConfig(output_path)), parser: 'yaml' })

if (check) {
	if (output !== readFileSync(output_path, 'utf8')) {
		throw new Error('Workflow YAML is stale; run bun run --cwd .github build')
	}
} else {
	await Bun.write(output_path, output)
}
