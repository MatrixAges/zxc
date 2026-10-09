import type { Input, Spec } from '../models/reduce_floating.ts'
import { boundaries, hex } from '../generate_division.ts'
import { encode, powerOfTwo } from '../models/ieee.ts'

export default function inputs(spec: Spec): Array<{ name: string; input: Input }> {
    const values = boundaries(spec.width)
    const names = [
        'positive_zero',
        'negative_zero',
        'positive_min_subnormal',
        'negative_min_subnormal',
        'positive_max_subnormal',
        'positive_min_normal',
        'negative_min_normal',
        'positive_half',
        'positive_one',
        'negative_one',
        'positive_above_one',
        'positive_max_finite',
        'negative_max_finite',
        'positive_infinity',
        'negative_infinity',
        'nan'
    ]

    for (const negative of [false, true])
        values[negative ? 'negative_integer_limit' : 'positive_integer_limit'] = encode({
            magnitude: powerOfTwo(spec.width === 32 ? 24 : 53),
            negative,
            width: spec.width
        }) as bigint

    names.push('positive_integer_limit', 'negative_integer_limit')

    const rows: Array<{ name: string; input: Input }> = []
    const toBits = (name: string): string => hex(values[name], spec.width)
    const append = (args: { name: string; items: Array<string>; seed?: string }): void => {
        const { name, items, seed = 'positive_zero' } = args

        rows.push({ name, input: { items: items.map(toBits), seed: toBits(seed) } })
    }

    if (spec.seeded) {
        for (const seed of names) {
            append({ name: 'empty/' + seed, items: [], seed })

            for (const item of names) append({ name: 'single/' + seed + '/' + item, items: [item], seed })
        }
    } else {
        append({ name: 'empty', items: [] })

        for (const first of names) {
            append({ name: 'single/' + first, items: [first] })

            for (const second of names) append({ name: 'pair/' + first + '/' + second, items: [first, second] })
        }
    }

    const sequences = {
        cancel_lost: ['positive_integer_limit', 'positive_one', 'negative_integer_limit'],
        cancel_retained: ['positive_integer_limit', 'negative_integer_limit', 'positive_one'],
        overflow_first: ['positive_max_finite', 'positive_max_finite', 'negative_max_finite'],
        cancel_before_large: ['positive_max_finite', 'negative_max_finite', 'positive_max_finite'],
        tiny_first: ['positive_one', 'positive_min_subnormal', 'negative_one'],
        tiny_last: ['positive_one', 'negative_one', 'positive_min_subnormal'],
        negative_zeros: ['negative_zero', 'negative_zero', 'negative_zero'],
        mixed_zeros: ['negative_zero', 'positive_zero', 'negative_zero'],
        infinity_cancellation: ['positive_infinity', 'negative_infinity', 'positive_one'],
        late_nan: ['positive_one', 'positive_half', 'nan']
    }

    for (const [name, items] of Object.entries(sequences)) {
        for (const seed of spec.seeded ? ['positive_zero', 'negative_zero', 'positive_one'] : ['positive_zero'])
            append({ name: 'sequence/' + name + '/' + seed, items, seed })
    }

    for (const length of [17, 257, 1024]) {
        for (const pattern of ['positive_one', 'positive_above_one', 'positive_min_subnormal']) {
            const items = Array.from({ length }, (_, index) => (index % 3 === 2 ? 'negative_one' : pattern))

            append({
                name: 'growth/' + length + '/' + pattern,
                items,
                seed: spec.seeded ? 'positive_one' : 'positive_zero'
            })
        }
    }

    return rows
}
