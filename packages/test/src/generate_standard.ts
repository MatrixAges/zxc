import { createHash } from 'node:crypto'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const source = `import encoding from "std:encoding"
import crypto from "std:crypto"

export type Input = { bytes: u8[]
 text: string }

export type Output = {
  base64: string
  hex: string
  base64_bytes: u8[]
  hex_bytes: u8[]
  utf8: u8[]
  text: string
  sha256: u8[]
  sha512: u8[]
}

export default function (in: Input): Output {
  const base64 = encoding.encodeBase64(in.bytes)
  const hex = encoding.encodeHex(in.bytes)
  const utf8 = encoding.encodeUtf8(in.text)

  return {
    base64: base64,
    hex: hex,
    base64_bytes: encoding.decodeBase64(base64),
    hex_bytes: encoding.decodeHex(hex),
    utf8: utf8,
    text: encoding.decodeUtf8(utf8),
    sha256: crypto.sha256(in.bytes),
    sha512: crypto.sha512(in.bytes)
  }
}
`

const lengths = [0, 1, 2, 3, 4, 55, 56, 63, 64, 65, 111, 112, 127, 128, 129, 255, 256, 257, 1024]
const texts = ['', 'ascii', '\0\n\r\t', '中文🌱', 'é e\u0301', '\u{10ffff}']
const rows = []
const identities = new Set<string>()

for (const length of lengths) {
	for (const pattern of ['zero', 'ones', 'ramp']) {
		const bytes = Array.from({ length }, (_, index) =>
			pattern === 'zero' ? 0 : pattern === 'ones' ? 255 : index % 256
		)
		const buffer = Buffer.from(bytes)

		for (const text of texts) {
			const input = { bytes, text }
			const identity = createHash('sha256').update(JSON.stringify(input)).digest('hex').slice(0, 16)

			if (identities.has(identity)) continue

			identities.add(identity)

			rows.push({
				id: `standard/encoding_crypto/${identity}`,
				input,
				expected: {
					value: {
						base64: buffer.toString('base64'),
						hex: buffer.toString('hex'),
						base64_bytes: bytes,
						hex_bytes: bytes,
						utf8: [...Buffer.from(text)],
						text,
						sha256: [...createHash('sha256').update(buffer).digest()],
						sha512: [...createHash('sha512').update(buffer).digest()]
					}
				}
			})
		}
	}
}

const base = 'tests/standard/encoding_crypto/values'

writeCatalog(base + '.jsonl', rows)
writeOutput(base + '.zx', source)
