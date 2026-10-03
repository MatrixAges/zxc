import type { JsonValue } from './json/parse'
import { existsSync, realpathSync } from 'node:fs'
import { basename, dirname, resolve } from 'node:path'
import parseJson from './json/parse'
import JsonNumber from './json/number'

export function record(value: unknown): Record<string, unknown> {
	if (!value || typeof value !== 'object' || Array.isArray(value)) throw new Error('Expected an object')

	return value as Record<string, unknown>
}

export function fields(value: unknown, names: Array<string>) {
	const result = record(value)

	if (Object.keys(result).sort().join('\0') !== [...names].sort().join('\0')) {
		throw new Error(`Expected fields: ${names.join(', ')}`)
	}

	return result
}

export function text(value: unknown): string {
	if (typeof value !== 'string' || !value || value.includes('\0')) throw new Error('Expected a nonempty string')

	return value
}

export function strings(value: unknown): Array<string> {
	if (!Array.isArray(value)) throw new Error('Expected a string array')

	const result = value.map(text)

	if (new Set(result).size !== result.length) throw new Error('Duplicate strings')

	return result
}

export function readJson(source: string): unknown {
	function validate(value: JsonValue) {
		if (value instanceof JsonNumber) {
			const number = Number(value.raw)

			if (
				!Number.isFinite(number) ||
				new JsonNumber(Object.is(number, -0) ? '-0' : String(number)).identity !== value.identity
			)
				throw new Error('Configuration number loses precision')
		} else if (value !== null && typeof value === 'object') {
			for (const item of Object.values(value)) validate(item)
		}
	}

	validate(parseJson(source))

	return JSON.parse(source)
}

export function canonical(path: string): string {
	const absolute = resolve(path)

	if (existsSync(absolute)) return realpathSync(absolute)

	const parent = dirname(absolute)

	if (parent === absolute) throw new Error(`Missing path: ${absolute}`)

	return resolve(canonical(parent), basename(absolute))
}
