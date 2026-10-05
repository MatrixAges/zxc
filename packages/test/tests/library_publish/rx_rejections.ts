import type { TestContext } from 'node:test'
import type createFixture from './fixture.ts'
import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const cases = [
	{
		name: 'nonvoid target requires input',
		call: '<Call module="bundle/advance" out="ctx.result" />',
		diagnostic: /input|Input|argument|void/
	},
	{
		name: 'public type module is not executable',
		call: '<Call module="bundle/types" out="ctx.result" />',
		diagnostic: /requires an executable public module/
	},
	{
		name: 'private source path is not a public export',
		call: '<Call module="bundle/snapshot.rx" out="ctx.result" />',
		diagnostic: /module: ZX package is not declared in the project dependencies/
	},
	{
		name: 'undeclared package is rejected',
		call: '<Call module="absent/read" out="ctx.result" />',
		diagnostic: /dependency|declared|package/
	},
	{
		name: 'module and fn are mutually exclusive',
		call: '<Call module="bundle/read" fn="read" in={$in} out="ctx.result" />',
		diagnostic: /exactly one of fn, service or module/
	},
	{
		name: 'module and service are mutually exclusive',
		call: '<Call module="bundle/read" service="read" in={$in} out="ctx.result" />',
		diagnostic: /exactly one of fn, service or module/
	},
	{
		name: 'module cannot grant a setter',
		call: '<Call module="bundle/advance" in={$in} setter={[store.fake.counter]} out="ctx.result" />',
		diagnostic: /Store authorization belongs inside the published RX module/
	},
	{
		name: 'input must match compiled public signature',
		call: '<Call module="bundle/advance" in={true} out="ctx.result" />',
		diagnostic: /type_mismatch|constraint/
	}
]

export default async function reject(args: {
	fixture: ReturnType<typeof createFixture>
	consumer: string
	context: TestContext
	application: string
}): Promise<void> {
	const { fixture, consumer, context, application } = args
	const original = readFileSync(join(consumer, 'main.rx'))
	const previous = readFileSync(application)

	try {
		for (const entry of cases) {
			await context.test(entry.name, () => {
				writeFileSync(
					join(consumer, 'main.rx'),
					`<Module>\n  ${entry.call}\n  <Return value={ctx.result} />\n</Module>\n`
				)
				const result = fixture.run({
					cwd: consumer,
					argv: ['build', 'main.rx', '--out', application, '--no-cache']
				})
				assert.equal(result.status, 1, result.stderr)
				assert.match(result.stderr, entry.diagnostic)
				assert.deepEqual(readFileSync(application), previous)
			})
		}
	} finally {
		writeFileSync(join(consumer, 'main.rx'), original)
	}
}
