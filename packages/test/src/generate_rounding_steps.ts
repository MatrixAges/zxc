import assert from 'node:assert/strict'
import { resolve } from 'node:path'
import roundingSteps from './models/rounding_steps.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = {
    id: string
    assertion: 'equals_zero' | 'differs_two'
    input: string
    path?: string
    sha256?: string
}

const samples = readRows<Sample>(resolve(package_dir, 'src/data/rounding_steps.jsonl'))
const prefix = 'language/types/number/rounding'
const comparisons = { equals_zero: '== 0.0', differs_two: '!= 2.0' }

function bits(value: number): bigint {
    const buffer = Buffer.alloc(8)

    buffer.writeDoubleBE(value)

    return buffer.readBigUInt64BE()
}

function expected(sample: Sample): boolean {
    const trace = roundingSteps(BigInt(sample.input))
    const x = Number(sample.input)
    const quotient = 1 / 65536.0
    const y = 1.0 - quotient
    const z = x + y
    const d = z - x
    const actual = { x, quotient, y, z, d }

    for (const name of Object.keys(trace) as Array<keyof typeof trace>) {
        assert.equal(bits(actual[name]), trace[name], `${sample.id}/${name}`)
    }

    const value = sample.assertion === 'equals_zero' ? (trace.d & 0x7fffffffffffffffn) === 0n : trace.d !== bits(2.0)

    assert.equal(value, sample.assertion === 'equals_zero' ? d === 0 : d !== 2)

    return value
}

writeOutput(
    `tests/${prefix}/difference.zx`,
    `export type Input = f64

export type Output = f64

export default function (in: Input): Output {
  const x = in
  const y = 1.0 - 1.0 / 65536.0
  const z = x + y
  const d = z - x

  return d
}
`
)

for (const [assertion, comparison] of Object.entries(comparisons)) {
    writeOutput(
        `tests/${prefix}/${assertion}.zx`,
        `import difference from "./difference"

export type Input = f64

export type Output = bool

export default function (in: Input): Output {
  return difference(in) ${comparison}
}
`
    )
    writeCatalog(
        `tests/${prefix}/${assertion}.jsonl`,
        samples
            .filter(sample => sample.assertion === assertion)
            .map(sample => ({ id: sample.id, input: Number(sample.input), expected: { value: expected(sample) } }))
    )
}
