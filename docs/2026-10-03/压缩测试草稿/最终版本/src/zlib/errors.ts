import { deflateSync, gzipSync } from 'node:zlib'

type Case = { name: string; data: Buffer; error: string }

export default function errorCases(format: string): Array<Case> {
	if (format === 'inflate_raw') return [
		{ name: 'invalid_block_type', data: Buffer.from([7]), error: 'InvalidBlockType' },
		{ name: 'stored_length_complement', data: Buffer.from([1, 1, 0, 0, 0, 65]), error: 'WrongStoredBlockNlen' },
		{ name: 'truncated_block_header', data: Buffer.from([1]), error: 'EndOfStream' },
	]

	const gzip = format === 'gunzip'
	const valid = gzip ? gzipSync('abc') : deflateSync('abc')
	const bad_header = Buffer.from(valid)
	const bad_checksum = Buffer.from(valid)
	const checksum_offset = valid.length - (gzip ? 8 : 4)

	bad_header[0] ^= 1
	bad_checksum[checksum_offset] ^= 1

	const rows: Array<Case> = [
		{ name: 'empty_input', data: Buffer.alloc(0), error: 'TruncatedInput' },
		{ name: 'truncated_header', data: valid.subarray(0, gzip ? 9 : 1), error: 'TruncatedInput' },
		{ name: 'invalid_header', data: bad_header, error: 'InvalidHeader' },
		{ name: 'invalid_checksum', data: bad_checksum, error: 'InvalidChecksum' },
		{ name: 'truncated_footer', data: valid.subarray(0, -1), error: 'EndOfStream' },
	]

	if (gzip) {
		const bad_length = Buffer.from(valid)
		const reserved_flags = Buffer.from(valid)
		const bad_header_crc = Buffer.concat([valid.subarray(0, 10), Buffer.from([0, 0]), valid.subarray(10)])

		bad_length[valid.length - 4] ^= 1
		reserved_flags[3] |= 0x20
		bad_header_crc[3] |= 2
		rows.push(
			{ name: 'invalid_length', data: bad_length, error: 'InvalidLength' },
			{ name: 'reserved_flags', data: reserved_flags, error: 'InvalidHeader' },
			{ name: 'invalid_header_crc', data: bad_header_crc, error: 'InvalidHeaderChecksum' },
			{ name: 'trailing_incomplete_member', data: Buffer.concat([valid, Buffer.from([0])]), error: 'TruncatedInput' },
		)
	} else {
		rows.push(
			{ name: 'dictionary_unsupported', data: deflateSync('abc', { dictionary: Buffer.from('abc') }), error: 'UnsupportedDictionary' },
			{ name: 'trailing_data', data: Buffer.concat([valid, Buffer.from([0])]), error: 'TrailingData' },
		)
	}

	return rows
}
