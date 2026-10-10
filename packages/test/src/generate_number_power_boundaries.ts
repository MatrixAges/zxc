import type { Sample } from './models/number_power_boundaries.ts'
import numberPowerBoundary from './models/number_power_boundaries.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const prefix = 'language/types/number/power_boundaries'
const sources = {
    power: `export type Input = f64

export type Output = f64

export default function (in: Input): Output {
    const initial = { exponent: in, index: 0.0, value: 1.0 }

    const result = loop(initial, {
        while: state => state.index < state.exponent,
        next: state => {
            state.value *= 2.0
            state.index += 1.0
        }
    })

    return result.value
}
`,
    product: 'in.left * power(in.right) * power(in.third)',
    maximum: 'in.left * (power(in.right) - 1.0) * power(in.third)',
    overflow: 'in.left * in.right'
}
const samples: Array<Sample & { name: string }> = [
    ...[0, 1, 2, 52, 53, 971, 1023, 1024].map(left => ({ kind: 'power' as const, name: `exponent_${left}`, left })),
    { kind: 'product', name: 'original_positive_finite', left: 1, right: 52, third: 971 },
    { kind: 'product', name: 'original_negative_finite', left: -1, right: 52, third: 971 },
    { kind: 'product', name: 'original_positive_overflow', left: 1, right: 53, third: 971 },
    { kind: 'product', name: 'original_negative_overflow', left: -1, right: 53, third: 971 },
    { kind: 'product', name: 'ordinary_scale', left: 3, right: 2, third: 1 },
    { kind: 'product', name: 'zero_sign', left: 0, right: 53, third: 971 },
    { kind: 'product', name: 'zero_exponents', left: 1, right: 0, third: 0 },
    { kind: 'maximum', name: 'original_maximum_finite', left: 1, right: 53, third: 971 },
    { kind: 'maximum', name: 'ordinary_positive', left: 1, right: 2, third: 1 },
    { kind: 'maximum', name: 'ordinary_negative', left: -1, right: 2, third: 1 },
    { kind: 'maximum', name: 'zero_significand', left: 1, right: 0, third: 0 },
    { kind: 'overflow', name: 'original_positive', left: 1e308, right: 2 },
    { kind: 'overflow', name: 'original_negative', left: -1e308, right: 3 },
    { kind: 'overflow', name: 'positive_finite', left: 1e308, right: 0.5 },
    { kind: 'overflow', name: 'negative_finite', left: -1e308, right: 0.5 },
    { kind: 'overflow', name: 'zero_multiplier', left: 1e308, right: 0 }
]

function bits(value: number): string {
    const buffer = Buffer.alloc(8)

    buffer.writeDoubleBE(value)

    return buffer.readBigUInt64BE().toString(16).padStart(16, '0')
}

for (const [kind, expression] of Object.entries(sources)) {
    const ternary = kind === 'product' || kind === 'maximum'
    const source =
        kind === 'power'
            ? expression
            : `${ternary ? 'import power from "./power"\n\n' : ''}export type Input = { left: f64, right: f64${ternary ? ', third: f64' : ''} }

export type Output = f64

export default function (in: Input): Output {
    return ${expression}
}
`

    writeOutput(`tests/${prefix}/${kind}.zx`, source)
    writeCatalog(
        `tests/${prefix}/${kind}.jsonl`,
        samples
            .filter(sample => sample.kind === kind)
            .map(sample => ({
                id: `${prefix}/${kind}/${sample.name}`,
                ...(sample.kind === 'power'
                    ? { input: bits(sample.left) }
                    : {
                          left: bits(sample.left),
                          right: bits(sample.right),
                          ...('third' in sample ? { third: bits(sample.third) } : {})
                      }),
                expected: numberPowerBoundary(sample)
            }))
    )
}
