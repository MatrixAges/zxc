export default function rewriteSource(source: Buffer, preserve_offsets = true): Buffer {
	const result = Buffer.from(source)
	const removed = new Set<number>()
	let offset = 0

	function quoted(quote: number): void {
		offset++

		while (offset < source.length) {
			const byte = source[offset++]

			if (byte === 92) offset++
			else if (byte === quote) return
		}
	}

	function followsBoundary(start: number): boolean {
		let index = start

		while (index < source.length) {
			const byte = source[index]

			if (byte === 10 || byte === 13 || byte === 125) return true
			if (byte === 32 || byte === 9) {
				index++
				continue
			}

			if (byte !== 47) return false
			if (source[index + 1] === 47) return true
			if (source[index + 1] !== 42) return false

			index += 2

			while (index < source.length) {
				if (source[index] === 10 || source[index] === 13) return true
				if (source[index] === 42 && source[index + 1] === 47) break
				index++
			}

			index += 2
		}

		return false
	}

	function template(): void {
		offset++

		while (offset < source.length) {
			const byte = source[offset++]

			if (byte === 92) offset++
			else if (byte === 96) return
			else if (byte === 36 && source[offset] === 123) {
				offset++
				code(true)
			}
		}
	}

	function code(nested: boolean): void {
		let braces = 0

		while (offset < source.length) {
			const byte = source[offset]

			if (byte === 34 || byte === 39) {
				quoted(byte)
				continue
			}

			if (byte === 96) {
				template()
				continue
			}

			if (byte === 47 && source[offset + 1] === 47) {
				while (offset < source.length && source[offset] !== 10 && source[offset] !== 13) offset++
				continue
			}

			if (byte === 47 && source[offset + 1] === 42) {
				offset += 2

				while (offset < source.length && !(source[offset] === 42 && source[offset + 1] === 47)) offset++
				offset += 2
				continue
			}

			if (byte === 59) {
				result[offset] = followsBoundary(offset + 1) ? 32 : 10

				if (!preserve_offsets && result[offset] === 32) removed.add(offset)
			}
			if (byte === 123) braces++
			if (byte === 125) {
				if (nested && braces === 0) {
					offset++
					return
				}

				braces--
			}

			offset++
		}
	}

	code(false)

	return preserve_offsets ? result : result.filter((_, index) => !removed.has(index))
}
