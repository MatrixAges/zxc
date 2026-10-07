import type { CipherGCM, DecipherGCM } from 'node:crypto'
import type { Json } from './shared/json.ts'
import assert from 'node:assert/strict'
import { createCipheriv, createDecipheriv } from 'node:crypto'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Input = {
    key: Array<number>
    nonce: Array<number>
    ciphertext: Array<number>
    tag: Array<number>
    aad: Array<number>
}
type Row = { id: string; input: Json; expected: { value: Json } | { error: string } }
const bytes = (length: number) => Buffer.from(Array.from({ length }, (_, index) => (index * 53 + 7) % 256))

for (const [name, algorithm, key_length] of [
    ['Aes128Gcm', 'aes-128-gcm', 16],
    ['Aes256Gcm', 'aes-256-gcm', 32],
    ['ChaCha20Poly1305', 'chacha20-poly1305', 32]
] as const) {
    const encrypt_rows: Array<Row> = []
    const decrypt_rows: Array<Row> = []
    const key = bytes(key_length)
    const nonce = bytes(12)
    let sample: Input | undefined

    for (const length of [0, 1, 15, 16, 17, 64, 65]) {
        for (const aad_length of [0, 1, 16]) {
            const data = bytes(length)
            const aad = bytes(aad_length)
            const cipher = createCipheriv(algorithm, key, nonce) as CipherGCM

            cipher.setAAD(aad)
            const ciphertext = Buffer.concat([cipher.update(data), cipher.final()])
            const tag = cipher.getAuthTag()
            const input: Input = {
                key: [...key],
                nonce: [...nonce],
                ciphertext: [...ciphertext],
                tag: [...tag],
                aad: [...aad]
            }
            const id = `${algorithm}/${length}/${aad_length}`

            sample = input
            encrypt_rows.push({
                id: `standard/crypto/encrypt/${id}`,
                input: { key: [...key], nonce: [...nonce], data: [...data], aad: [...aad] },
                expected: { value: { ciphertext: [...ciphertext], tag: [...tag] } }
            })
            decrypt_rows.push({ id: `standard/crypto/decrypt/${id}`, input, expected: { value: [...data] } })

            for (const field of ['key', 'nonce', 'ciphertext', 'tag', 'aad'] as const) {
                const changed = structuredClone(input)

                if (changed[field].length) changed[field][0] ^= 1
                else changed[field].push(1)

                assert.throws(() => {
                    const decipher = createDecipheriv(
                        algorithm,
                        Buffer.from(changed.key),
                        Buffer.from(changed.nonce)
                    ) as DecipherGCM

                    decipher.setAAD(Buffer.from(changed.aad))
                    decipher.setAuthTag(Buffer.from(changed.tag))
                    decipher.update(Buffer.from(changed.ciphertext))
                    decipher.final()
                })
                decrypt_rows.push({
                    id: `standard/crypto/decrypt/${id}/tampered_${field}`,
                    input: changed,
                    expected: { error: 'AuthenticationFailed' }
                })
            }
        }
    }

    assert.ok(sample)

    for (const [field, lengths, error] of [
        ['key', [0, key_length - 1, key_length + 1], 'InvalidKeyLength'],
        ['nonce', [0, 11, 13], 'InvalidNonceLength'],
        ['tag', [0, 15, 17], 'InvalidTagLength']
    ] as const) {
        for (const length of lengths) {
            const input = structuredClone(sample)

            input[field] = [...bytes(length)]
            decrypt_rows.push({
                id: `standard/crypto/decrypt/${algorithm}/${field}_length/${length}`,
                input,
                expected: { error }
            })

            if (field !== 'tag')
                encrypt_rows.push({
                    id: `standard/crypto/encrypt/${algorithm}/${field}_length/${length}`,
                    input: { key: input.key, nonce: input.nonce, data: [], aad: [] },
                    expected: { error }
                })
        }
    }

    for (const [operation, input, output, rows] of [
        [
            'encrypt',
            '{ key: u8[]\n nonce: u8[]\n data: u8[]\n aad: u8[] }',
            '{ ciphertext: u8[]\n tag: u8[] }',
            encrypt_rows
        ],
        ['decrypt', '{ key: u8[]\n nonce: u8[]\n ciphertext: u8[]\n tag: u8[]\n aad: u8[] }', 'u8[]', decrypt_rows]
    ] as const) {
        const base = `tests/standard/crypto/${algorithm}/${operation}`

        writeCatalog(base + '.jsonl', rows)
        writeOutput(
            base + '.zx',
            `import crypto from "std:crypto"

export type Input = ${input}

export type Output = ${output}

export default function (in: Input): Output {
  return crypto.${operation}${name}(in)
}
`
        )
    }
}
