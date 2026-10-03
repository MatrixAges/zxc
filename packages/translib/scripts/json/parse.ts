import JsonNumber from './number'

export type JsonValue = null | boolean | string | JsonNumber | Array<JsonValue> | { [key: string]: JsonValue }

export default function parseJson(text: string): JsonValue {
	let offset = 0

	function space() {
		while (/[\x20\t\r\n]/.test(text[offset] ?? '\0')) offset++
	}

	function string(): string {
		const token = /^"(?:[^"\\\u0000-\u001f]|\\(?:["\\/bfnrt]|u[\da-fA-F]{4}))*"/.exec(text.slice(offset))?.[0]

		if (!token) throw new Error(`Invalid JSON string at ${offset}`)

		offset += token.length

		return JSON.parse(token) as string
	}

	function value(): JsonValue {
		space()

		if (text[offset] === '"') return string()

		if (text[offset] === '[' || text[offset] === '{') {
			const array = text[offset++] === '['
			const end = array ? ']' : '}'
			const items: Array<JsonValue> = []
			const fields: Record<string, JsonValue> = Object.create(null)

			space()

			if (text[offset] !== end) {
				while (true) {
					space()

					if (array) items.push(value())
					else {
						const key = string()

						if (Object.hasOwn(fields, key)) throw new Error(`Duplicate JSON key: ${key}`)

						space()

						if (text[offset++] !== ':') throw new Error('Expected JSON colon')

						fields[key] = value()
					}

					space()

					if (text[offset] !== ',') break

					offset++
				}
			}

			if (text[offset++] !== end) throw new Error(`Expected JSON ${end}`)

			return array ? items : fields
		}

		const literal = /^(?:true|false|null)/.exec(text.slice(offset))?.[0]

		if (literal) {
			offset += literal.length

			return literal === 'null' ? null : literal === 'true'
		}

		const number = /^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/.exec(text.slice(offset))?.[0]

		if (!number) throw new Error(`Invalid JSON value at ${offset}`)

		offset += number.length

		return new JsonNumber(number)
	}

	const result = value()

	space()

	if (offset !== text.length) throw new Error(`Unexpected JSON content at ${offset}`)

	return result
}
