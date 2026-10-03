export function quoteBytes(data: Uint8Array): string {
	const escapes: Record<number, string> = { 10: '\\n', 13: '\\r', 9: '\\t', 34: '\\"', 92: '\\\\' }
	const parts = []

	for (const byte of data) {
		if (byte in escapes) parts.push(escapes[byte])
		else if (32 <= byte && byte < 127) parts.push(String.fromCharCode(byte))
		else parts.push(`\\x${byte.toString(16).padStart(2, '0')}`)
	}

	return '"' + parts.join('') + '"'
}

export function quote(text: string): string {
	return quoteBytes(Buffer.from(text))
}
