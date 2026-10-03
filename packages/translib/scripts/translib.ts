import { existsSync, readFileSync, statSync } from 'node:fs'
import { resolve } from 'node:path'
import { fingerprint, reviewed, valid } from './evidence'
import Migration from './migration'
import parity from './parity'
import { locked } from './processes'
import stage from './stages'
import { write } from './storage'
import { fields, readJson, strings, text } from './values'

function status(migration: Migration) {
	const units = migration.order.map(id => {
		const written = migration.units.get(id)!.targets.every(path => existsSync(path) && statSync(path).isFile())

		return { id, written, reviewed: written && reviewed(migration, id), fingerprint: fingerprint(migration, id) }
	})
	const checks = Object.fromEntries(['build', 'smoke', 'parity'].map(kind => [kind, valid(migration, kind)]))

	return { complete: units.every(unit => unit.reviewed) && Object.values(checks).every(Boolean), units, checks }
}

function review(args: { migration: Migration; unit: string; reviewer: string; report: string }) {
	const { migration, unit, reviewer, report } = args

	if (!migration.units.has(unit) || !reviewer.trim())
		throw new Error('review requires a known unit and nonempty reviewer ID')

	const result = fields(readJson(readFileSync(report, 'utf8')), ['fingerprint', 'findings'])
	const current = fingerprint(migration, unit)

	if (result.fingerprint !== current) throw new Error('Review is stale; review the current unit')

	const findings = strings(result.findings)

	if (findings.some(item => !item.trim())) throw new Error('Findings must describe unresolved issues')

	write(resolve(migration.evidence, 'reviews', migration.key(unit), migration.key(reviewer) + '.json'), {
		fingerprint: current,
		findings,
		reviewer,
		unit
	})
}

try {
	const [manifest, command, ...args] = process.argv.slice(2)

	if (
		!manifest ||
		!command ||
		!['status', 'check', 'review', 'build', 'smoke', 'parity'].includes(command) ||
		args.length !== (command === 'review' ? 3 : 0)
	) {
		throw new Error(
			'bun translib.ts <manifest.json> status|check|build|smoke|parity|review <unit> <reviewer> <report.json>'
		)
	}

	const migration = new Migration(manifest)

	if (command === 'status' || command === 'check') {
		const result = status(migration)

		console.log(JSON.stringify(result, null, 2))
		process.exitCode = command === 'status' || result.complete ? 0 : 1
	} else {
		const ok = await locked(migration.evidence, async () => {
			if (command === 'review') {
				review({ migration, unit: text(args[0]), reviewer: text(args[1]), report: text(args[2]) })

				return true
			}

			return command === 'parity' ? await parity(migration) : await stage(migration, command as 'build' | 'smoke')
		})

		console.log(JSON.stringify({ stage: command, ok, evidence: migration.evidence }))
		process.exitCode = ok ? 0 : 1
	}
} catch (error) {
	console.error(`translib: ${error instanceof Error ? error.message : String(error)}`)
	process.exitCode = 1
}
