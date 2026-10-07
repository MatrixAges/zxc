import { boundaries, hex } from './generate_division.ts'
import multiply from './models/multiply.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const first_names = [
    'positive_zero',
    'negative_zero',
    'positive_min_subnormal',
    'negative_min_subnormal',
    'positive_max_finite',
    'negative_max_finite',
    'positive_one',
    'positive_infinity',
    'nan'
]
const second_names = [
    'positive_one_point_one',
    'negative_one_point_one',
    'positive_half',
    'positive_infinity',
    'positive_zero'
]
const third_names = [
    'positive_point_nine',
    'negative_point_nine',
    'positive_two',
    'positive_min_subnormal',
    'positive_zero'
]
const expressions = {
    default: 'in.left * in.right * in.third',
    left: '(in.left * in.right) * in.third',
    right: 'in.left * (in.right * in.third)'
}

for (const width of [32, 64]) {
    const scalar = `f${width}`
    const values = boundaries(width)

    for (const [group, expression] of Object.entries(expressions)) {
        const rows = []

        for (const first_name of first_names) {
            for (const second_name of second_names) {
                for (const third_name of third_names) {
                    const left = values[first_name]
                    const right = values[second_name]
                    const third = values[third_name]
                    const inner = multiply({
                        left_bits: group === 'right' ? right : left,
                        right_bits: group === 'right' ? third : right,
                        width
                    })
                    const expected =
                        inner === 'nan'
                            ? 'nan'
                            : multiply({
                                  left_bits: group === 'right' ? left : inner,
                                  right_bits: group === 'right' ? inner : third,
                                  width
                              })

                    rows.push({
                        id: `language/expressions/multiplication/grouping/${scalar}/${group}/${first_name}/${second_name}/${third_name}`,
                        left: hex(left, width),
                        right: hex(right, width),
                        third: hex(third, width),
                        expected: hex(expected, width)
                    })
                }
            }
        }

        const base = `tests/language/expressions/multiplication/grouping/${scalar}/${group}`

        writeCatalog(base + '.jsonl', rows)
        writeOutput(
            base + '.zx',
            `export type Input = { left: ${scalar}
 right: ${scalar}
 third: ${scalar} }

export type Output = ${scalar}

export default function (in: Input): Output {
  return ${expression}
}
`
        )
    }
}
