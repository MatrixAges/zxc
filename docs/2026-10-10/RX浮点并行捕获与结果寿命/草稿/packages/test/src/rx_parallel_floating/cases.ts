import { boundaries, hex } from '../generate_division.ts'

export type Pattern = { values: Array<string>; length: number }
export type Values = { left: Pattern; right: Pattern; marker: string }
export type Row = {
    id: string
    check: 'values' | 'threads' | 'allocations'
    input: Values
    expected: Values & { owned_capture: boolean }
}

export default function cases(width: 32 | 64, variant: 'direct' | 'captured'): Array<Row> {
    const values = boundaries(width)
    const names = [
        'positive_zero',
        'negative_zero',
        'positive_min_subnormal',
        'negative_min_subnormal',
        'positive_max_subnormal',
        'negative_max_subnormal',
        'positive_min_normal',
        'negative_min_normal',
        'positive_half',
        'negative_half',
        'positive_one',
        'negative_one',
        'positive_above_one',
        'positive_max_finite',
        'negative_max_finite',
        'positive_infinity',
        'negative_infinity',
        'nan'
    ]
    const bits = names.map(name => hex(values[name], width))
    const rows: Array<Row> = []
    const append = (args: { name: string; input: Values; check?: Row['check'] }): void => {
        const { name, input, check = 'values' } = args

        rows.push({
            id: `rx/runtime/parallel/floating/f${width}/${variant}/${name}`,
            check,
            input,
            expected: { ...input, owned_capture: variant === 'captured' }
        })
    }

    for (const [index, marker] of bits.entries()) {
        const left = [...bits.slice(index), ...bits.slice(0, index)]
        const right = [...left.slice(1), left[0]]

        for (const length of [0, 1, 2, 17, 257])
            append({
                name: `length/${length}/${names[index]}`,
                input: { left: { values: left, length }, right: { values: right, length }, marker }
            })

        for (const left_empty of [false, true])
            append({
                name: `asymmetric/${left_empty ? 'left_empty' : 'right_empty'}/${names[index]}`,
                input: {
                    left: { values: left, length: left_empty ? 0 : 17 },
                    right: { values: right, length: left_empty ? 17 : 0 },
                    marker
                }
            })
    }

    for (const [left_index, left] of bits.entries())
        for (const [right_index, right] of bits.entries())
            append({
                name: `single/${names[left_index]}/${names[right_index]}`,
                input: {
                    left: { values: [left], length: 1 },
                    right: { values: [right], length: 1 },
                    marker: hex(values.negative_zero, width)
                }
            })

    for (const check of ['threads', 'allocations'] as const)
        append({
            name: check,
            check,
            input: {
                left: {
                    values: [
                        hex(values.negative_zero, width),
                        hex(values.nan, width),
                        hex(values.positive_min_subnormal, width)
                    ],
                    length: check === 'threads' ? 8192 : 3
                },
                right: {
                    values: [
                        hex(values.positive_infinity, width),
                        hex(values.negative_min_normal, width),
                        hex(values.positive_max_finite, width)
                    ],
                    length: check === 'threads' ? 8192 : 3
                },
                marker: hex(values.negative_zero, width)
            }
        })

    return rows
}
