import { writeCatalog, writeOutput } from './shared/catalog.ts'

const shapes = [
    ['literal', '1 - 1'],
    ['left', 'left - 1'],
    ['right', '1 - right'],
    ['both', 'left - right'],
    ['fields', 'object_left.prop - object_right.prop']
]
const rows = []

for (const [shape, [label]] of shapes.entries()) {
    const pairs =
        shape === 0
            ? [[1, 1]]
            : [
                  [1, 1],
                  [3, -2],
                  [-3, 4],
                  [0, 0],
                  [0.5, 0.25]
              ]

    for (const [index, [left, right]] of pairs.entries()) {
        const value = (shape === 0 || shape === 2 ? 1 : left) - (shape === 0 || shape === 1 ? 1 : right)

        rows.push({
            id: `language/expressions/subtraction/names/${label}/${index}`,
            input: { shape, left, right },
            expected: { value }
        })
    }
}

const branches = shapes.map(([, expression], index) => `    case ${index}: return ${expression};`).join('\n')
const base = 'tests/language/expressions/subtraction/names'

writeCatalog(base + '.jsonl', rows)
writeOutput(
    base + '.zx',
    `export type Input = { shape: u64
 left: f64
 right: f64 }

export type Output = f64

export default function (in: Input): Output {
  const left = in.left
  const right = in.right
  const object_left = { prop: in.left }
  const object_right = { prop: in.right }

  switch (in.shape) {
${branches}
    default: return 0
  }
}
`
)

const frontend: Array<{ id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }> =
    []

for (const side of ['left', 'right', 'both']) {
    for (const declared of side === 'both' ? [false] : [false, true]) {
        const identifier = side === 'right' ? 'y' : 'x'
        const expression = side === 'left' ? 'x - 1' : side === 'right' ? '1 - y' : 'x - y'
        const declaration = declared
            ? `  const ${identifier} = in

`
            : ''
        const source = `export type Input = f64

export type Output = f64

export default function (in: Input): Output {
${declaration}  return ${expression}
}
`
        const start = source.indexOf(identifier, source.indexOf('return'))

        frontend.push({
            id: `language/types/subtraction_names/${side}/${declared ? 'declared' : 'unbound'}`,
            source,
            phase: 'analyze',
            diagnostic: declared ? null : 'name',
            ...(!declared ? { span: [start, start + 1] } : {})
        })
    }
}

writeCatalog('tests/language/types/subtraction_names/cases.jsonl', frontend)
