import type { Json } from './shared/json.ts'
import { readFileSync } from 'node:fs'
import { relative, resolve } from 'node:path'
import { isDeepStrictEqual } from 'node:util'
import { package_dir } from './shared/catalog.ts'
import { jsonFiles } from './shared/files.ts'
import { parseJson, readRows } from './shared/json.ts'
import { readIndex, readLock, readMetadata } from './shared/upstream.ts'

type Suites = {
	frontend: Array<string>
	runtime: Array<{ path: string }>
	safety: Array<string>
	module_graphs: Array<string>
	stores: Array<string>
	evaluation_order: Array<string>
}
type Case = {
	id: string
	expected?: Record<string, Json>
	phase?: string
	diagnostic?: string | null
	span?: Array<number>
}
type Review = {
	path: string
	sha256: string
	status: string
	reason: string
	contract: string
	cases: Array<string>
	assertions?: Array<{ case: string; field: string; expected: Json }>
	diagnostics?: Array<{ case: string; phase: string; code: string; span?: Array<number> }>
}

const lock = readLock()
const upstream = readIndex()
const indexed_groups: Record<string, number> = {}

for (const path of upstream.keys()) {
	const group = path.split('/')[1]
	indexed_groups[group] = (indexed_groups[group] ?? 0) + 1
}

if (!isDeepStrictEqual(indexed_groups, lock.test_files))
	throw new Error('upstream index counts do not match the locked snapshot')

const metadata_rows = readMetadata(upstream)
const suites = parseJson<Suites>(readFileSync(resolve(package_dir, 'suites.json'), 'utf8'))
const registrations = {
	frontend: suites.frontend,
	runtime: suites.runtime.map(suite => suite.path),
	safety: suites.safety,
	module_graphs: suites.module_graphs,
	stores: suites.stores,
	evaluation_order: suites.evaluation_order
}
const registered = Object.values(registrations).flatMap(paths => paths.map(path => `tests/${path}.jsonl`))
const actual_files = jsonFiles('tests')
const actual = new Set(actual_files.map(path => relative(package_dir, path)))

if (new Set(registered).size !== registered.length || !isDeepStrictEqual(new Set(registered), actual))
	throw new Error('suite registrations are duplicated, missing, or refer to absent catalogs')

const cases = new Map<string, Case>()
const runner_counts: Record<string, number> = {}
const runners = new Map<string, string>(
	Object.entries(registrations).flatMap(([name, paths]) => paths.map(path => [`tests/${path}.jsonl`, name] as const))
)

for (const path of actual_files) {
	for (const row of readRows<Case>(path)) {
		if (cases.has(row.id)) throw new Error(`duplicate case ID: ${row.id}`)
		cases.set(row.id, row)

		const runner = runners.get(relative(package_dir, path))!
		runner_counts[runner] = (runner_counts[runner] ?? 0) + 1
	}
}

const reviewed = new Set<string>()
const states: Record<string, number> = {}
const linked = new Set<string>()

for (const path of jsonFiles('upstream/reviews')) {
	for (const row of readRows<Review>(path)) {
		const key = row.path

		if (reviewed.has(key) || upstream.get(key) !== row.sha256)
			throw new Error(`duplicate, missing or stale upstream review: ${key}`)
		if (!['equivalent', 'adapted', 'excluded'].includes(row.status))
			throw new Error(`invalid review status: ${key}`)
		if (!row.reason || !row.contract) throw new Error(`review lacks justification: ${key}`)
		if (row.status !== 'excluded' && !row.cases.length) throw new Error(`review lacks executable cases: ${key}`)
		if (row.cases.some(id => !cases.has(id))) throw new Error(`review refers to absent cases: ${key}`)

		for (const assertion of row.assertions ?? []) {
			if (!row.cases.includes(assertion.case)) throw new Error(`assertion is not linked by its review: ${key}`)
			const expected = cases.get(assertion.case)!.expected

			if (
				expected === null ||
				typeof expected !== 'object' ||
				!(assertion.field in expected) ||
				!isDeepStrictEqual(expected[assertion.field], assertion.expected)
			)
				throw new Error(`review assertion does not match its case expectation: ${key}`)
		}

		for (const diagnostic of row.diagnostics ?? []) {
			if (!row.cases.includes(diagnostic.case)) throw new Error(`diagnostic is not linked by its review: ${key}`)
			const test_case = cases.get(diagnostic.case)!

			if (test_case.phase !== diagnostic.phase || test_case.diagnostic !== diagnostic.code)
				throw new Error(`review diagnostic does not match its case expectation: ${key}`)
			if ('span' in diagnostic && !isDeepStrictEqual(test_case.span, diagnostic.span))
				throw new Error(`review diagnostic span does not match its case expectation: ${key}`)
		}

		reviewed.add(key)
		states[row.status] = (states[row.status] ?? 0) + 1
		for (const id of row.cases) linked.add(id)
	}
}

console.log(
	JSON.stringify(
		{
			upstream_files: upstream.size,
			metadata_files: metadata_rows.length,
			reviewed: states,
			unreviewed: upstream.size - reviewed.size,
			catalog_cases: cases.size,
			catalog_by_runner: runner_counts,
			linked_cases: linked.size,
			execution_status: 'not measured by this audit; see zig build test results'
		},
		null,
		2
	)
)
