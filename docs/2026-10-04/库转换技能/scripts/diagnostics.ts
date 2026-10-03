import type Migration from './migration'
import { resolve } from 'node:path'
import { canonical } from './values'

export default function diagnostics(migration: Migration, text: string) {
	const result: Array<{ unit: string | null; path?: string; line?: number; column?: number; message: string }> = []
	const cwd = canonical(resolve(migration.base, migration.expand(migration.build.cwd)))

	for (const line of text.split(/\r?\n/)) {
		const match = /^(.+?):(\d+):(\d+):\s*(?:error:|[a-z_]+:)\s*(.+)$/.exec(line)

		if (!match) continue

		const path = canonical(resolve(cwd, match[1]!))
		const unit = migration.order.find(name => migration.units.get(name)!.targets.includes(path)) ?? null

		result.push({ unit, path, line: Number(match[2]), column: Number(match[3]), message: match[4]! })
	}

	return result.sort((left, right) => {
		const rank = (name: string | null) => (name === null ? migration.order.length : migration.order.indexOf(name))

		return (
			rank(left.unit) - rank(right.unit) ||
			left.path!.localeCompare(right.path!) ||
			left.line! - right.line! ||
			left.column! - right.column!
		)
	})
}
