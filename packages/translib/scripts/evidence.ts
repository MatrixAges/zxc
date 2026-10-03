import type Migration from './migration'
import { createHash } from 'node:crypto'
import { existsSync, readdirSync } from 'node:fs'
import { release } from 'node:os'
import { isAbsolute, relative, resolve } from 'node:path'
import digestPath from './digest'
import { describe } from './processes'
import { read } from './storage'

export function artifactHashes(migration: Migration) {
	const result = Object.fromEntries(migration.artifacts.map(path => [path, digestPath(path)]))

	if (Object.values(result).includes(null)) throw new Error('Declared build artifact is missing')

	return result
}

export function fingerprint(migration: Migration, unit?: string) {
	const names = new Set<string>()
	const include = (name: string) => {
		if (names.has(name)) return

		names.add(name)
		for (const dependency of migration.units.get(name)!.depends_on) include(dependency)
	}

	for (const name of unit ? [unit] : migration.order) include(name)

	const paths = new Set([
		migration.path,
		migration.rulebook,
		migration.parity.cases,
		...migration.inputs,
		import.meta.dir,
		process.execPath
	])

	for (const name of names) {
		const item = migration.units.get(name)!

		for (const path of [...item.sources, ...item.targets]) paths.add(path)
	}

	for (const command of [migration.build, migration.smoke, migration.parity.oracle, migration.parity.candidate]) {
		const path = describe({ migration, command }).argv[0]!
		const artifact = migration.artifacts.some(root => {
			const child = relative(root, path)

			return (
				child === '' ||
				(!isAbsolute(child) && child !== '..' && !child.startsWith('../') && !child.startsWith('..\\'))
			)
		})

		if (!artifact) paths.add(path)
	}

	const values = [...paths].sort().map(path => [path, digestPath(path)])

	values.push(['platform', `${process.platform}/${process.arch}/${release()}/${Bun.version}`])
	values.push([
		'environment',
		createHash('sha256')
			.update(
				JSON.stringify(
					Object.entries(migration.environment).sort(([left], [right]) => left.localeCompare(right))
				)
			)
			.digest('hex')
	])

	return createHash('sha256').update(JSON.stringify(values)).digest('hex')
}

export function reviewed(migration: Migration, name: string) {
	const current = fingerprint(migration, name)
	const directory = resolve(migration.evidence, 'reviews', migration.key(name))
	const reviewers = new Set<string>()

	if (!existsSync(directory)) return false

	for (const file of readdirSync(directory).filter(name => name.endsWith('.json'))) {
		const result = read(resolve(directory, file))

		if (
			result?.fingerprint === current &&
			Array.isArray(result.findings) &&
			!result.findings.length &&
			typeof result.reviewer === 'string'
		)
			reviewers.add(result.reviewer)
	}

	return reviewers.size >= 2
}

export function valid(migration: Migration, kind: string) {
	const result = read(resolve(migration.evidence, `${kind}.json`))

	if (!result || result.ok !== true || result.fingerprint !== fingerprint(migration)) return false

	try {
		return JSON.stringify(result.artifacts) === JSON.stringify(artifactHashes(migration))
	} catch {
		return false
	}
}
