import { existsSync, readdirSync, unlinkSync } from 'node:fs'
import { resolve } from 'node:path'
import { check_mode, package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { rawJson, readRows } from './shared/json.ts'

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

for (const name of Array.from(groups.keys()).sort()) {
    const indices = groups.get(name)!
    const symbol = name.replace(/[\/_]([a-z0-9])/g, (_, letter: string) => letter.toUpperCase())
    const cases = indices
        .map(index => '        case ' + index + ':\n            return ' + entries[index].token)
        .join('\n')
    const source =
        'export type Input = u64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n    switch (in) {\n' +
        cases +
        '\n        default:\n            return 0\n    }\n}\n'

    writeSource('tests/' + base + '/' + name + '.zx', source)
    imports.push('import ' + symbol + ' from "./cases/' + name + '"')
    branches.push('    if (' + ranges(indices) + ') {\n        return ' + symbol + '(in)\n    }')
}

writeSource(
    'tests/' + base + '.zx',
    imports.join('\n') +
        '\n\nexport type Input = u64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n' +
        branches.join('\n\n') +
        '\n\n    return 0\n}\n'
)

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

function groupName(token: string): string {
    const exponent = token.match(/[eE]([+-]?)/)

    if (exponent) {
        const family = token.includes('.')
            ? 'fraction_exponent'
            : token.includes('e')
              ? 'integer_lower_exponent'
              : 'integer_upper_exponent'
        const sign = exponent[1] === '-' ? 'negative' : exponent[1] === '+' ? 'positive' : 'unsigned'

        return family + '/' + sign
    }

    if (token.includes('.')) return 'fraction'
    if (/^[+-]/.test(token)) return 'integer_signed'
    if (token.length === 1) return 'integer_digit'

    const prefix = token.startsWith('0') ? 'leading_zero' : 'decimal'

    return 'integer_multi_digit/' + prefix + '_' + token.length + '_digits'
}

function ranges(indices: Array<number>): string {
    const spans: Array<{ first: number; last: number }> = []

    for (const index of indices) {
        const previous = spans.at(-1)

        if (previous && previous.last + 1 === index) {
            previous.last = index
        } else {
            spans.push({ first: index, last: index })
        }
    }

    return spans
        .map(span =>
            span.first === span.last ? 'in == ' + span.first : '(in >= ' + span.first + ' && in <= ' + span.last + ')'
        )
        .join(' || ')
}

function writeSource(path: string, source: string): void {
    const lines = source.endsWith('\n') ? source.split('\n').length - 1 : source.split('\n').length

    if (lines > 120) throw new Error('ZX source exceeds 120 lines: ' + path)

    writeOutput(path, source)
}
