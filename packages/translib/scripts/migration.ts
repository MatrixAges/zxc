import type { Command } from './command'
import { createHash } from 'node:crypto'
import { readFileSync, statSync } from 'node:fs'
import { basename, dirname, extname, isAbsolute, relative, resolve } from 'node:path'
import command from './command'
import { canonical, fields, readJson, strings, text } from './values'

export type Unit = { sources: Array<string>; targets: Array<string>; depends_on: Array<string> }

export default class Migration {
	readonly path: string
	readonly base: string
	readonly source: string
	readonly target: string
	readonly rulebook: string
	readonly inputs: Array<string>
	readonly artifacts: Array<string>
	readonly evidence: string
	readonly environment: Record<string, string>
	readonly units = new Map<string, Unit>()
	readonly order: Array<string> = []
	readonly build: Command
	readonly smoke: Command
	readonly parity: { cases: string; mode: 'json' | 'bytes'; oracle: Command; candidate: Command }

	constructor(path: string) {
		this.path = canonical(path)
		this.base = dirname(this.path)

		const data = fields(readJson(readFileSync(this.path, 'utf8')), [
			'format_version',
			'environment',
			'source_root',
			'target_root',
			'rulebook',
			'inputs',
			'units',
			'artifacts',
			'build',
			'smoke',
			'parity'
		])

		if (data.format_version !== 1) throw new Error('Expected format_version: 1')

		this.environment = Object.fromEntries(
			strings(data.environment).flatMap(name =>
				process.env[name] === undefined ? [] : [[name, process.env[name]!]]
			)
		)

		this.source = canonical(resolve(this.base, text(data.source_root)))
		this.target = canonical(resolve(this.base, text(data.target_root)))
		this.rulebook = canonical(resolve(this.base, text(data.rulebook)))
		this.inputs = strings(data.inputs).map(item => canonical(resolve(this.base, item)))

		for (const path of this.inputs) {
			const metadata = statSync(path)

			if (!metadata.isFile() && !metadata.isDirectory()) throw new Error(`Invalid evidence input: ${path}`)
		}
		this.artifacts = strings(data.artifacts).map(item => canonical(resolve(this.base, item)))
		this.evidence = resolve(this.base, '.translib', basename(this.path, extname(this.path)))
		this.build = command(data.build)
		this.smoke = command(data.smoke)

		const parity = fields(data.parity, ['cases', 'mode', 'oracle', 'candidate'])

		if (parity.mode !== 'json' && parity.mode !== 'bytes') throw new Error('parity mode must be json or bytes')

		this.parity = {
			cases: canonical(resolve(this.base, text(parity.cases))),
			mode: parity.mode,
			oracle: command(parity.oracle),
			candidate: command(parity.candidate)
		}

		if (
			!statSync(this.source).isDirectory() ||
			!statSync(this.target).isDirectory() ||
			!statSync(this.rulebook).isFile()
		)
			throw new Error('Invalid source/target/rulebook paths')
		if (!Array.isArray(data.units) || !data.units.length || !this.artifacts.length)
			throw new Error('units and artifacts must not be empty')

		const owned = new Set<string>()

		for (const value of data.units) {
			const unit = fields(value, ['id', 'sources', 'targets', 'depends_on'])
			const id = text(unit.id)
			const sources = strings(unit.sources).map(item => within(this.source, item))
			const targets = strings(unit.targets).map(item => within(this.target, item))

			if (this.units.has(id) || !sources.length || !targets.length)
				throw new Error(`Invalid or duplicate unit: ${id}`)
			if (sources.some(path => !statSync(path).isFile())) throw new Error(`Missing source in ${id}`)

			for (const path of targets) {
				if (owned.has(path)) throw new Error(`Target has multiple owners: ${path}`)

				owned.add(path)
			}

			this.units.set(id, { sources, targets, depends_on: strings(unit.depends_on) })
		}

		if ([...this.units.values()].some(unit => unit.sources.some(path => owned.has(path))))
			throw new Error('Source and target files overlap')

		const visiting = new Set<string>()
		const visit = (id: string) => {
			const unit = this.units.get(id)

			if (!unit || visiting.has(id)) throw new Error(`Unknown or cyclic dependency: ${id}`)
			if (this.order.includes(id)) return

			visiting.add(id)
			for (const dependency of [...unit.depends_on].sort()) visit(dependency)
			visiting.delete(id)
			this.order.push(id)
		}

		for (const id of [...this.units.keys()].sort()) visit(id)
	}

	key(name: string) {
		return createHash('sha256').update(name).digest('hex')
	}

	expand(value: string, input?: string) {
		const result = value.replaceAll('{source}', this.source).replaceAll('{target}', this.target)

		return input === undefined ? result : result.replaceAll('{input}', input)
	}
}

function within(root: string, path: string) {
	const resolved = canonical(resolve(root, path))
	const relative_path = relative(root, resolved)

	if (
		isAbsolute(path) ||
		relative_path === '..' ||
		relative_path.startsWith('../') ||
		relative_path.startsWith('..\\') ||
		isAbsolute(relative_path)
	) {
		throw new Error(`Path must stay within its root: ${path}`)
	}

	return resolved
}
