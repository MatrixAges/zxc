import { boundaries, hex } from '../generate_division.ts'

export type Row = {
    id: string
    input: { choose: boolean; safe: string; items: Array<string> }
    expected: { value: string } | { error: string }
}

export default function cases(width: 32 | 64): Array<Row> {
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
    const rows: Array<Row> = []
    const append = (args: { name: string; safe: string; items: Array<string> }): void => {
        const { name, safe, items } = args

        for (const choose of [false, true]) {
            const selected = choose ? safe : items[0]
            const expected =
                selected === undefined
                    ? { error: 'IndexOutOfBounds' }
                    : { value: selected === hex(values.nan, width) ? 'nan' : selected }

            rows.push({
                id: `rx/runtime/floating/f${width}/${name}/${choose ? 'safe' : 'first'}`,
                input: { choose, safe, items },
                expected
            })
        }
    }

    for (const safe of names) {
        append({ name: 'empty/' + safe, safe: hex(values[safe], width), items: [] })

        for (const first of names)
            append({
                name: `single/${safe}/${first}`,
                safe: hex(values[safe], width),
                items: [hex(values[first], width)]
            })

        for (const length of [17, 257])
            append({
                name: `growth/${length}/${safe}`,
                safe: hex(values[safe], width),
                items: Array.from({ length }, (_, index) =>
                    hex(values[names[(names.indexOf(safe) + index + 1) % names.length]], width)
                )
            })
    }

    return rows
}
