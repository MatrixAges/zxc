import type { Case } from './inspect_cases.ts'
import { stringify } from 'yaml'

const base = 'name: sample\nversion: 1.0.0\n'
const cases: Array<Case> = []

function reject(args: { name: string; fields: string; message: string }): void {
	const { name, fields, message } = args
	const marked = `${base}native_modules:\n  - name: bridge\n    path: native/bridge.zig\n    ${fields}\n`
	const offset = marked.indexOf('§')

	if (offset < 0) throw new Error('missing diagnostic position')

	const before = marked.slice(0, offset)

	cases.push({ name: `native scope ${name}`, source: marked.replace('§', ''), diagnostic: { message, line: before.split('\n').length, column: offset - before.lastIndexOf('\n') } })
}

for (const field of ['include_paths', 'abi_aliases']) {
	for (const value of ['{}', 'null', 'text', '!!int 3']) {
		reject({ name: `${field} rejects nonsequence ${value}`, fields: `${field}: §${value}`, message: 'expected a sequence' })
	}

	reject({ name: `${field} duplicate field`, fields: `${field}: []\n    §${field}: []`, message: 'duplicate YAML mapping key' })
}

for (const [value, message] of [
	['{}', 'expected a string scalar'],
	['[]', 'expected a string scalar'],
	['!!int 3', 'expected a string scalar'],
	['""', 'empty strings and NUL are not allowed in this field'],
	['"bad\\0path"', 'empty strings and NUL are not allowed in this field'],
]) reject({ name: `include path item ${value}`, fields: `include_paths: [§${value}]`, message })

for (const value of ['text', 'null', '[]']) {
	reject({ name: `alias item ${value}`, fields: `abi_aliases: [§${value}]`, message: 'expected a YAML mapping' })
}

for (const fields of ['', 'name: "zig:bridge"', 'specifier: "zig:private"']) {
	reject({ name: `alias missing required field ${fields || 'both'}`, fields: `abi_aliases: [§{${fields}}]`, message: 'native ABI alias requires name and specifier' })
}

for (const field of ['name', 'specifier']) {
	for (const [value, message] of [
		['{}', 'expected a string scalar'],
		['!!int 3', 'expected a string scalar'],
		['""', 'empty strings and NUL are not allowed in this field'],
		['"bad\\0alias"', 'empty strings and NUL are not allowed in this field'],
	]) reject({ name: `alias ${field} rejects ${value}`, fields: `abi_aliases: [{${field}: §${value}}]`, message })

	reject({ name: `alias duplicate ${field}`, fields: `abi_aliases: [{${field}: a, §${field}: b}]`, message: 'duplicate YAML mapping key' })
}

reject({ name: 'alias unknown field', fields: 'abi_aliases: [{§mystery: value}]', message: 'unknown native ABI alias field' })

const path_options = [null, [], ['native/include', 'path with spaces', '目录/include']]
const alias_options = [null, [], [{ name: 'zig:bridge', specifier: 'zig:private_left' }, { name: 'c:header', specifier: 'c:private_right' }]]

for (const source_kind of ['path', 'header']) {
	for (const [path_index, include_paths] of path_options.entries()) {
		for (const [alias_index, abi_aliases] of alias_options.entries()) {
			const source = { name: 'bridge', [source_kind]: source_kind === 'path' ? 'native/bridge.zig' : 'native/bridge.h', ...(include_paths === null ? {} : { include_paths }), ...(abi_aliases === null ? {} : { abi_aliases }) }
			const expected = { name: 'bridge', path: source_kind === 'path' ? 'native/bridge.zig' : null, header: source_kind === 'header' ? 'native/bridge.h' : null, dependencies: [], bundle_files: [], include_paths, abi_aliases }

			cases.push({ name: `native scope ${source_kind} paths ${path_index} aliases ${alias_index}`, source: base + stringify({ native_modules: [source] }), expected: { native_modules: [expected] } })
		}
	}
}

export default cases
