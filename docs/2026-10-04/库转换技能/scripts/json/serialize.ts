import type { JsonValue } from './parse'
import JsonNumber from './number'

export default function serialize(value: JsonValue, normalized = false): string {
	if (value instanceof JsonNumber) return normalized ? value.identity : value.raw
	if (value === null || typeof value !== 'object') return JSON.stringify(value)
	if (Array.isArray(value)) return `[${value.map(item => serialize(item, normalized)).join(',')}]`

	return `{${Object.keys(value)
		.sort()
		.map(key => `${JSON.stringify(key)}:${serialize(value[key]!, normalized)}`)
		.join(',')}}`
}
