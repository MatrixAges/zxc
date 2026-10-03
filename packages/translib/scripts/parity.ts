import type Migration from './migration'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { artifactHashes, fingerprint, valid } from './evidence'
import JsonNumber from './json/number'
import parseJson from './json/parse'
import serialize from './json/serialize'
import { run } from './processes'
import { write } from './storage'

export default async function execute(migration: Migration) {
	if (!valid(migration, 'build') || !valid(migration, 'smoke'))
		throw new Error('parity requires current build and smoke evidence')

	const config = migration.parity

	if (JSON.stringify(config.oracle) === JSON.stringify(config.candidate))
		throw new Error('oracle and candidate must be distinct')

	const before = fingerprint(migration)
	const artifacts = artifactHashes(migration)
	const result_path = resolve(migration.evidence, 'parity.json')

	write(result_path, { fingerprint: before, ok: false, reason: 'execution started' })

	const rows = []
	const seen = new Set<string>()

	try {
		for (const line of readFileSync(config.cases, 'utf8').split(/\r?\n/)) {
			if (!line.trim()) continue

			const item = parseJson(line)

			if (
				!item ||
				typeof item !== 'object' ||
				Array.isArray(item) ||
				item instanceof JsonNumber ||
				typeof item.id !== 'string' ||
				!item.id ||
				seen.has(item.id) ||
				!Object.hasOwn(item, 'input')
			) {
				throw new Error('Each case requires a unique nonempty id and input')
			}

			seen.add(item.id)

			const expected_exit =
				item.exit_code === undefined
					? 0
					: Array.from({ length: 256 }, (_, index) => index).find(
							index =>
								item.exit_code instanceof JsonNumber &&
								new JsonNumber(String(index)).identity === item.exit_code.identity
						)

			if (expected_exit === undefined) throw new Error('exit_code must be an integer from 0 to 255')

			const input = serialize(item.input!)
			const oracle = await run({ migration, command: config.oracle, input })
			const candidate = await run({ migration, command: config.candidate, input })

			for (const [name, result] of [
				['oracle', oracle],
				['candidate', candidate]
			] as const) {
				writeFileSync(resolve(migration.evidence, `parity-${rows.length}-${name}.stdout`), result.stdout)
				writeFileSync(resolve(migration.evidence, `parity-${rows.length}-${name}.stderr`), result.stderr)
			}

			let ok =
				!oracle.timed_out &&
				!candidate.timed_out &&
				oracle.exit_code === expected_exit &&
				candidate.exit_code === expected_exit &&
				oracle.stderr.equals(candidate.stderr)
			let reason: string | null = null

			try {
				if (config.mode === 'json' && expected_exit === 0) {
					const decoder = new TextDecoder('utf-8', { fatal: true })
					const left = serialize(parseJson(decoder.decode(oracle.stdout)), true)
					const right = serialize(parseJson(decoder.decode(candidate.stdout)), true)

					ok = ok && left === right

					if (Object.hasOwn(item, 'expected'))
						ok = ok && left === serialize(item.expected!, true) && right === serialize(item.expected!, true)
				} else {
					ok = ok && oracle.stdout.equals(candidate.stdout)

					if (Object.hasOwn(item, 'expected')) {
						if (typeof item.expected !== 'string')
							throw new Error('Byte comparison expected value must be a UTF-8 string')

						ok = ok && oracle.stdout.equals(Buffer.from(item.expected))
					}
				}
			} catch (error) {
				ok = false
				reason = error instanceof Error ? error.message : String(error)
			}

			rows.push({
				id: item.id,
				ok,
				oracle_exit: oracle.exit_code,
				candidate_exit: candidate.exit_code,
				oracle_timeout: oracle.timed_out,
				candidate_timeout: candidate.timed_out,
				reason
			})
		}

		const unchanged =
			before === fingerprint(migration) && JSON.stringify(artifacts) === JSON.stringify(artifactHashes(migration))
		const ok = rows.length > 0 && rows.every(row => row.ok) && unchanged

		write(result_path, {
			fingerprint: before,
			ok,
			inputs_unchanged: unchanged,
			artifacts,
			count: rows.length,
			cases: rows
		})

		return ok
	} catch (error) {
		write(result_path, {
			fingerprint: before,
			ok: false,
			artifacts,
			cases: rows,
			reason: error instanceof Error ? error.message : String(error)
		})
		return false
	}
}
