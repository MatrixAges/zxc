import { fields, text } from './values'

export type Command = { argv: Array<string>; cwd: string; timeout_seconds: number }

export default function command(value: unknown): Command {
	const data = fields(value, ['argv', 'cwd', 'timeout_seconds'])

	if (
		!Array.isArray(data.argv) ||
		!data.argv.length ||
		data.argv.some(item => typeof item !== 'string' || item.includes('\0'))
	) {
		throw new Error('argv requires a nonempty array of strings')
	}

	const argv = data.argv as Array<string>
	const cwd = text(data.cwd)
	const timeout_seconds = data.timeout_seconds

	text(argv[0])

	if (argv[0]!.includes('{input}') || cwd.includes('{input}'))
		throw new Error('{input} is allowed only in command arguments')
	if (
		typeof timeout_seconds !== 'number' ||
		!Number.isInteger(timeout_seconds) ||
		timeout_seconds <= 0 ||
		timeout_seconds > 86400
	) {
		throw new Error('timeout_seconds must be an integer from 1 to 86400')
	}

	return { argv, cwd, timeout_seconds }
}
