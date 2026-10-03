import type Migration from './migration'
import { appendFileSync, readFileSync, statSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { artifactHashes, fingerprint, valid } from './evidence'
import { run } from './processes'
import { write } from './storage'
import diagnostics from './diagnostics'

export default async function execute(migration: Migration, kind: 'build' | 'smoke') {
	if (kind === 'smoke' && !valid(migration, 'build')) throw new Error('smoke requires a current successful build')

	const result_path = resolve(migration.evidence, `${kind}.json`)
	const output = resolve(migration.evidence, `${kind}.stdout`)
	const errors = resolve(migration.evidence, `${kind}.stderr`)
	let before: string | null = null
	let completion: Omit<Awaited<ReturnType<typeof run>>, 'stdout' | 'stderr'> | null = null

	write(result_path, { ok: false, reason: 'execution started' })

	try {
		if ([...migration.units.values()].some(unit => unit.targets.some(path => !statSync(path).isFile())))
			throw new Error('Every target file is required')

		before = fingerprint(migration)

		const previous = kind === 'smoke' ? artifactHashes(migration) : null
		const { stdout, stderr, ...result } = await run({ migration, command: migration[kind] })

		writeFileSync(output, stdout)
		writeFileSync(errors, stderr)
		completion = result

		const unchanged = before === fingerprint(migration)
		const artifacts = artifactHashes(migration)
		const ok =
			result.exit_code === 0 &&
			!result.timed_out &&
			unchanged &&
			(previous === null || JSON.stringify(previous) === JSON.stringify(artifacts))

		if (kind === 'build') {
			const queue = diagnostics(migration, stdout.toString() + '\n' + stderr.toString())

			if (!ok)
				queue.push({
					unit: null,
					message: 'Build failed or inputs changed; inspect build.stdout and build.stderr'
				})

			write(resolve(migration.evidence, 'repair_queue.json'), { fingerprint: before, errors: queue })
		}

		write(result_path, { ...result, fingerprint: before, ok, inputs_unchanged: unchanged, artifacts })

		return ok
	} catch (error) {
		const reason = error instanceof Error ? error.message : String(error)

		if (completion) appendFileSync(errors, '\n' + reason + '\n')
		else {
			writeFileSync(output, '')
			writeFileSync(errors, reason + '\n')
		}

		write(result_path, { ...completion, fingerprint: before, ok: false, reason })

		if (kind === 'build')
			write(resolve(migration.evidence, 'repair_queue.json'), {
				fingerprint: before,
				errors: [
					...(completion
						? diagnostics(migration, readFileSync(output, 'utf8') + '\n' + readFileSync(errors, 'utf8'))
						: []),
					{ unit: null, message: reason }
				]
			})

		return false
	}
}
