import add from './add.ts'
import subtract from './subtract.ts'
import multiply from './multiply.ts'
import { decode, divide } from './ieee.ts'

export type Operation = 'add' | 'subtract' | 'multiply' | 'divide'
export type Input = { items: Array<string>; seed: string }
export type Expected = { value: string } | { error: 'IndexOutOfBounds' }
export type Spec = { width: 32 | 64; operation: Operation; seeded: boolean }
export type Row = { id: string; input: Input; expected: Expected }

const operations = { add, subtract, multiply, divide }

export default function expectation(args: { spec: Spec; input: Input }): Expected {
    const { spec, input } = args

    if (!spec.seeded && input.items.length === 0) return { error: 'IndexOutOfBounds' }

    let value: bigint | 'nan' = BigInt('0x' + (spec.seeded ? input.seed : input.items[0]))

    for (let index = spec.seeded ? 0 : 1; index < input.items.length; index++) {
        if (value !== 'nan')
            value = operations[spec.operation]({
                left_bits: value,
                right_bits: BigInt('0x' + input.items[index]),
                width: spec.width
            })
    }

    if (value === 'nan' || decode(value, spec.width) === 'nan') return { value: 'nan' }

    return { value: value.toString(16).padStart(spec.width / 4, '0') }
}
