import type { Buffer } from 'node:buffer'
import type { Input, Output } from './addon.cjs'
import { execute } from './addon.cjs'
import { execute as noInput } from './void.cjs'
import { execute as produce } from './no_input.cjs'
import { execute as discard } from './no_output.cjs'

const input: Input = {
	name: 'typed',
	bytes: [0, 255] as const,
	count: 1n,
	pair: [true, 0.5] as const,
	mode: 'Read',
	values: [0n, 1n] as const,
	nested: [{ value: 'x' }] as const
}
const output: Output = execute(input)
const bytes: Buffer = output.bytes
const note: string | null = output.note
const empty: void = noInput()
const produced: bigint = produce()
const discarded: void = discard(1n)

output.values.push(2n)
output.pair[0] = false
output.nested.push({ value: 'y' })
execute({ ...input, bytes: new Uint8Array(2), note: undefined })
execute({ ...input, bytes: new Uint8ClampedArray(2), note: null })

// @ts-expect-error BigInt input is required.
execute({ ...input, count: 1 })
// @ts-expect-error Only declared enum members are accepted.
execute({ ...input, mode: 'Missing' })
// @ts-expect-error A required record field is missing.
execute({ bytes: [], count: 1n, pair: [true, 1], mode: 'Read', values: [], nested: [] })
// @ts-expect-error Tuple length must be exact.
execute({ ...input, pair: [true] })
// @ts-expect-error Tuple length must be exact.
execute({ ...input, pair: [true, 1, 2] })
// @ts-expect-error Tuple element types must match.
execute({ ...input, pair: [1, true] })
// @ts-expect-error Nested arrays preserve their element types.
execute({ ...input, values: [1] })
// @ts-expect-error Nested records preserve required fields.
execute({ ...input, nested: [{}] })
// @ts-expect-error Nullable string does not include number.
execute({ ...input, note: 1 })
// @ts-expect-error Byte input does not accept wide typed arrays.
execute({ ...input, bytes: new Uint16Array(2) })
// @ts-expect-error Input is required.
execute()
// @ts-expect-error Extra positional arguments are rejected.
execute(input, input)
// @ts-expect-error Void input takes no arguments.
noInput(undefined)
// @ts-expect-error Output nullable fields do not contain undefined.
const missing: undefined = output.note
// @ts-expect-error Output nullable fields cannot be deleted.
delete output.note
// @ts-expect-error Input arrays are readonly.
input.values.push(2n)
// @ts-expect-error Output bytes are Buffer, not an arbitrary number array.
const wrong: Output = { ...output, bytes: [1, 2] }

// @ts-expect-error Void input must not introduce an optional argument.
produce(undefined)
// @ts-expect-error A void output does not remove the required input.
discard()
// @ts-expect-error Input BigInt must not widen to Number.
discard(1)
// @ts-expect-error Void output must not widen to the input type.
const wrong_result: bigint = discard(1n)

export { bytes, note, empty, produced, discarded }
