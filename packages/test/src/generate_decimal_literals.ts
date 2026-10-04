import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { rawJson, readRows } from './shared/json.ts'

type Sample = { name: string; path: string; sha256: string; checks: Array<{ token: string; expected: string }> }

const samples = readRows<Sample>(resolve(package_dir, 'src/data/decimal_literals.jsonl'))
const base = 'language/lexical/numeric/decimal_original/cases'
const entries = samples.flatMap(sample => sample.checks.map((check, index) => ({ ...check, id: base + '/' + sample.name + '/' + index })))
const branches = entries.map((entry, index) => '    case ' + index + ':\n      return ' + entry.token).join('\n')
const source = 'export type Input = u64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n  switch (in) {\n' + branches + '\n    default:\n      return 0\n  }\n}\n'

writeOutput('tests/' + base + '.zx', source)
writeCatalog('tests/' + base + '.jsonl', entries.map((entry, index) => ({
	id: entry.id,
	input: index,
	expected: { value: rawJson(/[.eE]/.test(entry.expected) ? entry.expected : entry.expected + '.0') },
})))
writeCatalog('upstream/reviews/language/literals/decimal_original.jsonl', samples.map(sample => ({
	path: sample.path,
	sha256: sample.sha256,
	status: 'adapted',
	reason: 'Preserve each original decimal token and expected numeric value; execute through an explicit f64 output contract instead of JavaScript global Number evaluation.',
	contract: 'packages/core/IR契约.md',
	cases: sample.checks.map((_, index) => base + '/' + sample.name + '/' + index),
	assertions: sample.checks.map((check, index) => ({ case: base + '/' + sample.name + '/' + index, field: 'value', expected: Number(check.expected) })),
})))
