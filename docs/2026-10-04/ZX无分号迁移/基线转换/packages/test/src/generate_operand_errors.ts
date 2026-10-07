import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Operand = { text: string; length: number } | { text: string; error: string }

const hex: Array<Operand> = [
    { text: '', length: 0 },
    { text: '00', length: 1 },
    { text: '616263', length: 3 },
    { text: '0', error: 'InvalidHex' },
    { text: 'gg', error: 'InvalidCharacter' }
]
const base64: Array<Operand> = [
    { text: '', length: 0 },
    { text: 'YQ==', length: 1 },
    { text: 'YWJj', length: 3 },
    { text: 'A', error: 'InvalidPadding' },
    { text: '!!!!', error: 'InvalidCharacter' }
]

for (const reversed of [false, true]) {
    const name = reversed ? 'base64_hex' : 'hex_base64'
    const left_method = reversed ? 'decodeBase64' : 'decodeHex'
    const right_method = reversed ? 'decodeHex' : 'decodeBase64'
    const rows = []

    for (const [left_index, left] of (reversed ? base64 : hex).entries()) {
        for (const [right_index, right] of (reversed ? hex : base64).entries()) {
            const expected =
                'error' in left
                    ? { error: left.error }
                    : 'error' in right
                      ? { error: right.error }
                      : { value: left.length * right.length }

            rows.push({
                id: `language/expressions/multiplication/errors/${name}/${left_index}/${right_index}`,
                input: { left: left.text, right: right.text },
                expected
            })
        }
    }

    const base = `tests/language/expressions/multiplication/errors/${name}`
    const source = `import encoding from "std:encoding"

export type Input = { left: string
 right: string }

export type Output = u64

export default function (in: Input): Output {
  return encoding.${left_method}(in.left).length * encoding.${right_method}(in.right).length
}
`

    writeCatalog(base + '.jsonl', rows)
    writeOutput(base + '.zx', source)
}
