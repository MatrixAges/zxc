import { escape, unescape } from 'node:querystring'

type Case = { name: string; input: string; value: string }

export default function percentCases(): { escape: Array<Case>; unescape: Array<Case> } {
	const encode_rows: Array<Case> = []
	const decode_rows: Array<Case> = []

	for (const point of [
		...Array.from({ length: 128 }, (_, index) => index),
		0x80,
		0x7ff,
		0x800,
		0xd7ff,
		0xe000,
		0xffff,
		0x10000,
		0x10ffff
	]) {
		const input = String.fromCodePoint(point)

		encode_rows.push({ name: `codepoint_${point.toString(16)}`, input, value: escape(input) })
	}

	for (let byte = 0; byte < 256; byte++) {
		const input = '%' + byte.toString(16).padStart(2, '0')

		decode_rows.push({ name: `single_byte_${byte.toString(16)}`, input, value: unescape(input) })
	}

	const texts = {
		empty: '',
		combining: 'e\u0301',
		unicode: '中文🌱',
		literal_plus: '+',
		mixed: 'a +%&=\0z',
		safe_punctuation: "-_.!~*'()"
	}

	for (const [name, input] of Object.entries(texts)) {
		encode_rows.push({ name, input, value: escape(input) })
		decode_rows.push({ name, input, value: unescape(input) })
	}

	const sequences = [
		'%',
		'%0',
		'%gg',
		'%0g',
		'%g0',
		'%%41',
		'%41%',
		'%2520',
		'%2b+',
		'%C2%A2',
		'%E2%82%AC',
		'%F0%9F%8C%B1',
		'%c2%a2',
		'%C2',
		'%E2%82',
		'%F0%9F%8C',
		'%C0%AF',
		'%E0%80%80',
		'%ED%A0%80',
		'%F0%80%80%80',
		'%F4%90%80%80',
		'%F5%80%80%80',
		'%E2%41%AC',
		'%E2%82%41',
		'%F0%9F%41%80',
		'%EF%BB%BF',
		'%EF%BF%BD'
	]

	for (const input of sequences)
		decode_rows.push({ name: `sequence_${Buffer.from(input).toString('hex')}`, input, value: unescape(input) })

	decode_rows.push(
		{ name: 'literal_unicode_invalid_byte', input: '中%FF文', value: '中�文' },
		{ name: 'literal_non_bmp_truncated_sequence', input: '🌱%E2%82', value: '🌱�' },
		{ name: 'malformed_percent_preserves_unicode', input: '%G1中', value: '%G1中' }
	)

	return { escape: encode_rows, unescape: decode_rows }
}
