import type createFixture from './fixture.ts'
import assert from 'node:assert/strict'
import { fileURLToPath } from 'node:url'
import createHost from '../../../targets/wasm/host.ts'

export default function checkScalar(args: {
	fixture: ReturnType<typeof createFixture>
	path: string
	target: string | null
	policy: 'json' | 'discard'
}) {
	const { fixture, path, target, policy } = args

	if (target === 'wasm32-freestanding') {
		const host = createHost(path)

		try {
			for (const value of [0, 41, 513]) {
				const result = host.invoke(JSON.stringify(value))

				assert.equal(result.status, 0)
				assert.equal(result.result, policy === 'json' ? JSON.stringify(value + 1) : '')
			}
		} finally {
			host.api.zxc_deinit()
		}

		return
	}

	for (const value of [0, 41, 513]) {
		const wasi_host = fileURLToPath(new URL('../../../targets/wasm/wasi_host.ts', import.meta.url))

		const result =
			target === 'wasm32-wasi'
				? fixture.run({
						command: process.execPath,
						argv: ['--disable-warning=ExperimentalWarning', wasi_host, path, JSON.stringify(value)]
					})
				: fixture.run({ command: path, argv: [JSON.stringify(value)] })

		assert.equal(result.stdout, policy === 'json' ? JSON.stringify(value + 1) + '\n' : '')
	}
}
