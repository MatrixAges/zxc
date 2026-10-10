import { existsSync, readdirSync, unlinkSync } from 'node:fs'
import { resolve } from 'node:path'
import { check_mode, package_dir, writeCatalog } from './shared/catalog.ts'
import { rawJson, readRows } from './shared/json.ts'
import { groupName, subgroupName } from './decimal_literals/groups.ts'
import { caseSource, dispatchSource } from './decimal_literals/source.ts'
import sourceDependencies from './shared/source_dependencies.ts'
import sourceRanges from './shared/source_ranges.ts'
import writeZx from './shared/write_zx.ts'

type Sample = { name: string; path: string; sha256: string; checks: Array<{ token: string; expected: string }> }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/decimal_literals.jsonl'))
const base = 'language/lexical/numeric/decimal_original/cases'
const entries = samples.flatMap(sample =>
    sample.checks.map((check, index) => ({ ...check, id: base + '/' + sample.name + '/' + index }))
)
const groups = new Map<string, Array<number>>()

for (const [index, entry] of entries.entries()) {
    const name = groupName(entry.token)
    const indices = groups.get(name) ?? []

    indices.push(index)
    groups.set(name, indices)
}

const imports: Array<string> = []
const branches: Array<string> = []
const sources: Array<string> = []
const tokens = entries.map(entry => entry.token)

for (const name of Array.from(groups.keys()).sort()) {
    const indices = groups.get(name)!
    const symbol = name.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase())
    const path = 'tests/' + base + '/' + name + '.zx'
    const subgroups = new Map<string, Array<number>>()

    for (const index of indices) {
        const subgroup = subgroupName({ name, token: tokens[index] })

        if (subgroup === null) continue

        const values = subgroups.get(subgroup) ?? []

        values.push(index)
        subgroups.set(subgroup, values)
    }

    if (subgroups.size === 0) {
        writeZx(path, caseSource({ indices, tokens }))
    } else {
        const nested_imports: Array<string> = []
        const nested_branches: Array<string> = []

        for (const subgroup of [...subgroups.keys()].sort()) {
            const values = subgroups.get(subgroup)!
            const nested_symbol = subgroup.replace(/_([a-z0-9])/g, (_, letter: string) => letter.toUpperCase())
            const nested_path = 'tests/' + base + '/' + name + '/' + subgroup + '.zx'

            writeZx(nested_path, caseSource({ indices: values, tokens }))
            nested_imports.push('import ' + nested_symbol + ' from "./' + name + '/' + subgroup + '"')
            nested_branches.push(
                '    if (' +
                    sourceRanges({ indices: values, selector: 'in' }) +
                    ') {\n        return ' +
                    nested_symbol +
                    '(in)\n    }'
            )
            sources.push(nested_path)
        }

        writeZx(path, dispatchSource({ imports: nested_imports, branches: nested_branches }))
    }

    sources.push(path)
    imports.push('import ' + symbol + ' from "./cases/' + name + '"')
    branches.push(
        '    if (' + sourceRanges({ indices, selector: 'in' }) + ') {\n        return ' + symbol + '(in)\n    }'
    )
}

writeZx('tests/' + base + '.zx', dispatchSource({ imports, branches }))
await sourceDependencies({ path: base, sources })

const directory = resolve(package_dir, 'tests/' + base)

if (existsSync(directory)) {
    for (const name of readdirSync(directory)) {
        if (!name.endsWith('.zx') || groups.has(name.slice(0, -3))) continue
        if (check_mode) throw new Error('outdated decimal literal module: ' + name)

        unlinkSync(resolve(directory, name))
    }
}

writeCatalog(
    'tests/' + base + '.jsonl',
    entries.map((entry, index) => ({
        id: entry.id,
        input: index,
        expected: { value: rawJson(/[.eE]/.test(entry.expected) ? entry.expected : entry.expected + '.0') }
    }))
)
writeCatalog(
    'upstream/reviews/language/literals/decimal_original.jsonl',
    samples.map(sample => ({
        path: sample.path,
        sha256: sample.sha256,
        status: 'adapted',
        reason: 'Preserve each original decimal token and expected numeric value; execute through an explicit f64 output contract instead of JavaScript global Number evaluation.',
        contract: 'packages/core/IR契约.md',
        cases: sample.checks.map((_, index) => base + '/' + sample.name + '/' + index),
        assertions: sample.checks.map((check, index) => ({
            case: base + '/' + sample.name + '/' + index,
            field: 'value',
            expected: Number(check.expected)
        }))
    }))
)
