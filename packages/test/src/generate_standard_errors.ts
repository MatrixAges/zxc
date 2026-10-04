import { writeCatalog, writeOutput } from './shared/catalog.ts'

const source = `import encoding from "std:encoding"

export type Input = { kind: u8
 text: string
 bytes: u8[] }

export type Output = u8[]

export default function (in: Input): Output {
  switch (in.kind) {
    case 0: return encoding.decodeBase64(in.text)
    case 1: return encoding.decodeHex(in.text)
    default: return encoding.encodeUtf8(encoding.decodeUtf8(in.bytes))
  }
}
`

type Case = {
	id: string
	input: { kind: number; text: string; bytes: Array<number> }
	expected: { error: string } | { value: Array<number> }
}

const rows: Array<Case> = []
const groups: Array<{ kind: number; error: string; values: Array<string> }> = [
	{ kind: 0, error: 'InvalidPadding', values: ['A', 'AA', 'AAA', 'AA=A', 'AA/=', 'A/==', 'A===', '===='] },
	{ kind: 0, error: 'InvalidCharacter', values: ['A..A', 'Zm9vYmFyZm9vYmFyA..A', '!!!!'] },
	{ kind: 1, error: 'InvalidHex', values: ['0', 'abc', 'abcde'] },
	{ kind: 1, error: 'InvalidCharacter', values: ['gg', '00zz', ' 0', '0x'] }
]

for (const group of groups) {
	for (const [index, text] of group.values.entries()) {
		rows.push({
			id: `standard/decoding/${group.kind}/${group.error}/${index}`,
			input: { kind: group.kind, text, bytes: [] },
			expected: { error: group.error }
		})
	}
}

const invalid_utf8 = [
	[0x80],
	[0xc0, 0xaf],
	[0xc2],
	[0xe0, 0x80, 0x80],
	[0xed, 0xa0, 0x80],
	[0xf4, 0x90, 0x80, 0x80],
	[0xf5, 0x80, 0x80, 0x80],
	[0xff]
]

for (const [index, bytes] of invalid_utf8.entries()) {
	rows.push({
		id: `standard/decoding/utf8/invalid/${index}`,
		input: { kind: 2, text: '', bytes },
		expected: { error: 'InvalidUtf8' }
	})
}

for (const [text, value] of [
	['', ''],
	['YQ==', 'a'],
	['YWI=', 'ab'],
	['YWJj', 'abc']
]) {
	rows.push({
		id: `standard/decoding/base64/valid/${text.length}/${value.length}`,
		input: { kind: 0, text, bytes: [] },
		expected: { value: [...Buffer.from(value)] }
	})
}

for (const text of ['', 'aA', '00Ff', '616263']) {
	rows.push({
		id: `standard/decoding/hex/valid/${text}`,
		input: { kind: 1, text, bytes: [] },
		expected: { value: [...Buffer.from(text, 'hex')] }
	})
}

for (const [index, text] of ['', '\0', '中文🌱', '\u{10ffff}'].entries()) {
	const bytes = [...Buffer.from(text)]

	rows.push({
		id: `standard/decoding/utf8/valid/${index}`,
		input: { kind: 2, text: '', bytes },
		expected: { value: bytes }
	})
}

const base = 'tests/standard/decoding/errors'

writeCatalog(base + '.jsonl', rows)
writeOutput(base + '.zx', source)
