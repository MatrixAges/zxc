import type { Json } from './json.ts'
import { quote } from '../zig_string.ts'

export default function literal(value: Json): string {
	if (value === null) return 'null'
	if (typeof value === 'boolean' || typeof value === 'bigint' || typeof value === 'number') return String(value)
	if (typeof value === 'string') return quote(value)
	if (Array.isArray(value)) return '&.{' + value.map(literal).join(', ') + '}'

	return (
		'&.{' +
		Object.entries(value)
			.map(([key, item]) => `.${key} = ${literal(item)}`)
			.join(', ') +
		'}'
	)
}
