import type { TestContext } from 'node:test'
import type createFixture from './fixture.ts'
import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const cases = [
	{
		name: 'nonvoid target requires input',
		call: '<Call module="bundle/advance" />',
		diagnostic: /input|Input|argument|void/
	},
	{
		name: 'public type module is not executable',
		call: '<Call module="bundle/types" />',
		diagnostic: /requires an executable public module/
	},
	{
		name: 'private source path is not a public export',
		call: '<Call module="bundle/snapshot.rx" />',
		diagnostic: /^bundle\/snapshot\.rx: FileNotFound\n$/
	},
	{
		name: 'undeclared package is rejected',
		call: '<Call module="absent/read" />',
		diagnostic: /^absent\/read\.rx: FileNotFound\n$/
	},
	{
		name: 'module and fn are mutually exclusive',
		call: '<Call module="bundle/read" fn="read" in={$in} />',
		diagnostic: /exactly one of fn or module/
	},
	{
		name: 'removed service attribute is rejected',
		call: '<Call module="bundle/read" service="read" in={$in} />',
		diagnostic: /unknown_attribute/
	},
	{
		name: 'module cannot grant a setter',
		call: '<Call module="bundle/advance" in={$in} setter={[store.fake.counter]} />',
		diagnostic: /Store authorization belongs inside the called RX module/
	},
	{
		name: 'input must match compiled public signature',
		call: '<Call module="bundle/advance" in={true} />',
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
					`<Module>\n  ${entry.call}\n  <Return value={true} />\n</Module>\n`
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
