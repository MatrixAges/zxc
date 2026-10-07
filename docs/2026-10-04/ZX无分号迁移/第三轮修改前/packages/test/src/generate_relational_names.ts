import { writeCatalog, writeOutput } from './shared/catalog.ts'

const operations: Array<[string, string, number, number, (left: number, right: number) => boolean]> = [
    ['less', '<', 1, 2, (left, right) => left < right],
    ['greater', '>', 2, 1, (left, right) => left > right],
    ['less_equal', '<=', 1, 1, (left, right) => left <= right],
    ['greater_equal', '>=', 1, 1, (left, right) => left >= right]
]
const frontend: Array<{ id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }> =
    []

for (const [name, operator, original_left, original_right, compare] of operations) {
    const shapes = [
        ['literal', `${original_left} ${operator} ${original_right}`],
        ['left', `left ${operator} ${original_right}`],
        ['right', `${original_left} ${operator} right`],
        ['both', `left ${operator} right`],
        ['fields', `object_left.prop ${operator} object_right.prop`]
    ]
    const rows = []

    for (const [shape, [label]] of shapes.entries()) {
        const pairs =
            shape === 0
                ? [[original_left, original_right]]
                : [
                      [original_left, original_right],
                      [3, -2],
                      [0, 0]
                  ]

        for (const [index, [left, right]] of pairs.entries()) {
            const value = compare(
                shape === 0 || shape === 2 ? original_left : left,
                shape === 0 || shape === 1 ? original_right : right
            )

            rows.push({
                id: `language/expressions/comparison/names/${name}/${label}/${index}`,
                input: { shape, left, right },
                expected: { value }
            })
        }
    }

    const branches = shapes.map(([, expression], index) => `    case ${index}: return ${expression};`).join('\n')
    const base = `tests/language/expressions/comparison/names/${name}`

    writeCatalog(base + '.jsonl', rows)
    writeOutput(
        base + '.zx',
        `export type Input = { shape: u64
 left: f64
 right: f64 }

export type Output = bool

export default function (in: Input): Output {
  const left = in.left
  const right = in.right
  const object_left = { prop: in.left }
  const object_right = { prop: in.right }

  switch (in.shape) {
${branches}
    default: return false
  }
}
`
    )

    for (const side of ['left', 'right', 'both']) {
        for (const declared of side === 'both' ? [false] : [false, true]) {
            const identifier = side === 'right' ? 'y' : 'x'
            const expression =
                side === 'left' ? `x ${operator} 1` : side === 'right' ? `1 ${operator} y` : `x ${operator} y`
            const declaration = declared
                ? `  const ${identifier} = in

`
                : ''
            const source = `export type Input = f64

export type Output = bool

export default function (in: Input): Output {
${declaration}  return ${expression}
}
`
            const start = source.indexOf(identifier, source.indexOf('return'))

            frontend.push({
                id: `language/types/relational_names/${name}/${side}/${declared ? 'declared' : 'unbound'}`,
                source,
                phase: 'analyze',
                diagnostic: declared ? null : 'name',
                ...(!declared ? { span: [start, start + 1] } : {})
            })
        }
    }
}

writeCatalog('tests/language/types/relational_names/cases.jsonl', frontend)
