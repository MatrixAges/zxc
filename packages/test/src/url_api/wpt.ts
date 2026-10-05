import type { Fields } from './record.ts'
import type { Case } from './write_suite.ts'
import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import toRecord from './record.ts'
import writeSuite from './write_suite.ts'

type Row = { input: string; base: string | null } & (
	(Fields & { origin?: string; failure?: false }) | { failure: true }
)

export default function writeWpt(): void {
	const source = readFileSync(new URL('../../upstream/wpt/url/resources/urltestdata.json', import.meta.url))
	const lock = JSON.parse(readFileSync(new URL('../../upstream/wpt/lock.json', import.meta.url), 'utf8')) as {
		files: Record<string, string>
	}

	assert.equal(createHash('sha256').update(source).digest('hex'), lock.files['url/resources/urltestdata.json'])

	const data = JSON.parse(source.toString()) as Array<string | Row>
	const cases = data.flatMap((row, index) => (typeof row === 'string' ? [] : [{ row, name: `wpt-${index}` }]))

	assert.equal(cases.length, 896)

	for (const operation of ['canParse', 'tryParse']) {
		writeSuite({
			operation,
			input: 'Resolve',
			output: operation === 'canParse' ? 'bool' : 'Url?',
			rows: cases.map(({ row, name }) => ({
				name,
				input: { input: row.input, base: row.base },
				value: operation === 'canParse' ? !row.failure : row.failure ? null : toRecord(row)
			}))
		})
	}

	for (const operation of ['parse', 'resolve', 'stringify', 'pathname', 'origin']) {
		const rows: Array<Case> = []

		for (const { row, name } of cases) {
			if (row.failure || (operation === 'origin' && row.origin === undefined)) continue

			const record = toRecord(row)
			const input =
				operation === 'parse'
					? row.href
					: operation === 'resolve'
						? { input: row.input, base: row.base }
						: record
			const value =
				operation === 'stringify'
					? row.href
					: operation === 'pathname'
						? row.pathname
						: operation === 'origin'
							? row.origin!
							: record

			rows.push({ name, input, value })
		}

		if (operation === 'parse') rows.push({ name: 'relative-rejected', input: '../relative', error: 'InvalidUrl' })
		if (operation === 'resolve')
			rows.push({
				name: 'invalid-base-rejected',
				input: { input: 'https://example.org/', base: 'relative' },
				error: 'InvalidUrl'
			})

		writeSuite({
			operation,
			input: operation === 'parse' ? 'string' : operation === 'resolve' ? 'Resolve' : 'Url',
			output: operation === 'parse' || operation === 'resolve' ? 'Url' : 'string',
			rows
		})
	}
}
