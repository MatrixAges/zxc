import type { Expected, Input, Spec } from '../models/reduce_floating.ts'

function readNumber(bits: string, width: 32 | 64): number {
    const buffer = Buffer.alloc(8)

    if (width === 32) {
        buffer.writeUInt32LE(Number(BigInt('0x' + bits)))

        return buffer.readFloatLE()
    }

    buffer.writeBigUInt64LE(BigInt('0x' + bits))

    return buffer.readDoubleLE()
}

export default function nodeReference(args: { spec: Spec; input: Input }): Expected {
    const { spec, input } = args
    const values = input.items.map(bits => readNumber(bits, spec.width))
    const calculate = (previous: number, current: number): number => {
        const value =
            spec.operation === 'add'
                ? previous + current
                : spec.operation === 'subtract'
                  ? previous - current
                  : spec.operation === 'multiply'
                    ? previous * current
                    : previous / current

        return spec.width === 32 ? Math.fround(value) : value
    }

    if (!spec.seeded && values.length === 0) return { error: 'IndexOutOfBounds' }

    const value = spec.seeded ? values.reduce(calculate, readNumber(input.seed, spec.width)) : values.reduce(calculate)

    if (Number.isNaN(value)) return { value: 'nan' }

    const buffer = Buffer.alloc(8)

    if (spec.width === 32) buffer.writeFloatLE(value)
    else buffer.writeDoubleLE(value)

    const bits = spec.width === 32 ? BigInt(buffer.readUInt32LE()) : buffer.readBigUInt64LE()

    return { value: bits.toString(16).padStart(spec.width / 4, '0') }
}
