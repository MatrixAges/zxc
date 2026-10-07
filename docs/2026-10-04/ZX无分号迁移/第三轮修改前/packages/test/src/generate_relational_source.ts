import { writeCatalog, writeOutput } from './shared/catalog.ts'

const pairs = [
    ['1.1', '1'],
    ['1', '1.1'],
    ['-1.1', '-1'],
    ['-1', '-1.1'],
    ['0', '0.1'],
    ['-0.1', '0'],
    ['maximum / 2', 'maximum'],
    ['minimum', 'minimum * 2']
]
const values = [false, true, true, false, true, true, true, true]
const operators = [
    ['less', '<'],
    ['greater', '>'],
    ['less_equal', '<='],
    ['greater_equal', '>=']
]
const branches: Array<string> = []
const rows: Array<{ id: string; input: number; expected: { value: boolean } }> = []

for (const [name, operator] of operators) {
    for (const [index, pair] of pairs.entries()) {
        const [left, right] = name.startsWith('greater') ? [...pair].reverse() : pair
        const input = rows.length

        rows.push({
            id: `language/expressions/comparison/source/${name}/${index + 1}`,
            input,
            expected: { value: values[index] }
        })
        branches.push(`    case ${input}: return (${left}) ${operator} (${right});`)
    }
}

writeCatalog('tests/language/expressions/comparison/source.jsonl', rows)
writeOutput(
    'tests/language/expressions/comparison/source.zx',
    `export type Input = u64

export type Output = bool

export default function (in: Input): Output {
  const maximum: f64 = 1.7976931348623157e308
  const minimum: f64 = 5e-324

  switch (in) {
${branches.join('\n')}
    default: return false
  }
}
`
)
