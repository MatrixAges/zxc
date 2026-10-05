import type { Case } from './inspect_cases.ts'
import { stringify } from 'yaml'

const base = 'name: sample\nversion: 1.0.0\n'
const cases: Array<Case> = []

function reject(args: { name: string; source: string; message: string }): void {
	const { name, source, message } = args
	const marked = base + source
	const offset = marked.indexOf('§')

	if (offset < 0) throw new Error('missing diagnostic position')

	const before = marked.slice(0, offset)

	cases.push({
		name: `native ${name}`,
		source: marked.replace('§', ''),
		diagnostic: { message, line: before.split('\n').length, column: offset - before.lastIndexOf('\n') }
	})
}

for (const field of [
	'native_interfaces',
	'native_modules',
	'externals',
	'libraries',
	'include_paths',
	'library_paths'
]) {
	reject({ name: `${field} must be sequence`, source: `${field}: §{}\n`, message: 'expected a sequence' })
}

for (const [name, source, message] of [
	[
		'interface missing specifier',
		'native_interfaces: [§{path: a.d.zx, module: a}]',
		'native interface requires specifier, path and module'
	],
	[
		'interface missing path',
		'native_interfaces: [§{specifier: "zig:a", module: a}]',
		'native interface requires specifier, path and module'
	],
	[
		'interface missing module',
		'native_interfaces: [§{specifier: "zig:a", path: a.d.zx}]',
		'native interface requires specifier, path and module'
	],
	['interface unknown field', 'native_interfaces: [{§mystery: x}]', 'unknown native interface field'],
	['interface duplicate key', 'native_interfaces: [{module: a, §module: b}]', 'duplicate YAML mapping key'],
	['namespace scalar', 'native_interfaces: [{namespace: §nested}]', 'expected a sequence'],
	[
		'namespace empty item',
		'native_interfaces: [{namespace: [§""]}]',
		'empty strings and NUL are not allowed in this field'
	],
	['module missing name', 'native_modules: [§{path: a.zig}]', 'native module requires name'],
	['module missing source', 'native_modules: [§{name: a}]', 'native module requires exactly one of path or header'],
	[
		'module ambiguous source',
		'native_modules: [§{name: a, path: a.zig, header: a.h}]',
		'native module requires exactly one of path or header'
	],
	['module unknown field', 'native_modules: [{§mystery: x}]', 'unknown native module field'],
	['module dependencies mapping', 'native_modules: [{dependencies: §{}}]', 'expected a sequence'],
	['module bundled files scalar', 'native_modules: [{bundle_files: §a.zig}]', 'expected a sequence'],
	[
		'external incomplete',
		'externals: [§{specifier: "zig:a", signature: text, implementation: {module: a}}]',
		'external interface requires specifier, signature and implementation module/member'
	],
	['external unknown field', 'externals: [{§mystery: x}]', 'unknown external interface field'],
	['external implementation scalar', 'externals: [{implementation: §bad}]', 'expected a YAML mapping'],
	[
		'implementation unknown field',
		'externals: [{implementation: {§mystery: x}}]',
		'unknown external implementation field'
	],
	['library nonstring item', 'libraries: [§{}]', 'expected a string scalar'],
	['library empty item', 'libraries: [§""]', 'empty strings and NUL are not allowed in this field']
])
	reject({ name, source: source + '\n', message })

cases.push({
	name: 'native header bundled files',
	source: base + 'native_modules: [{name: a, header: a.h, bundle_files: [x]}]\n',
	expected: {
		native_modules: [
			{
				name: 'a',
				path: null,
				header: 'a.h',
				dependencies: [],
				bundle_files: ['x'],
				include_paths: null,
				abi_aliases: null
			}
		]
	}
})

for (const field of ['allocator_argument', 'io_argument', 'process_argument', 'expand_tuple', 'fallible']) {
	for (const [value, message] of [
		['"true"', 'expected an unquoted boolean'],
		['yes', 'expected true or false']
	]) {
		reject({
			name: `${field} rejects ${value}`,
			source: `externals: [{implementation: {${field}: §${value}}}]\n`,
			message
		})
	}
}

const configurations: Array<Record<string, unknown>> = [
	{ native_interfaces: [{ specifier: 'zig:a', path: 'types/a.d.zx', module: 'a', namespace: [] }] },
	{ native_interfaces: [{ specifier: 'zig:a', path: 'types/a.d.zx', module: 'a', namespace: ['nested', 'api'] }] },
	{
		native_modules: [
			{
				name: 'a',
				path: 'src/a.zig',
				header: null,
				dependencies: ['b'],
				bundle_files: ['src/helper.zig'],
				include_paths: null,
				abi_aliases: null
			}
		]
	},
	{
		native_modules: [
			{
				name: 'c',
				path: null,
				header: 'native/c.h',
				dependencies: [],
				bundle_files: [],
				include_paths: null,
				abi_aliases: null
			}
		]
	},
	{ libraries: ['c', 'ssl'], include_paths: ['native/include', 'path with spaces'], library_paths: ['native/lib'] }
]

for (const [index, expected] of configurations.entries()) {
	const serialized = structuredClone(expected)

	for (const value of Object.values(serialized)) {
		if (!Array.isArray(value)) continue

		for (const item of value as Array<unknown>) {
			if (typeof item !== 'object' || item === null) continue

			const record = item as Record<string, unknown>

			for (const key of Object.keys(record)) if (record[key] === null) delete record[key]
		}
	}

	cases.push({ name: `native roundtrip ${index}`, source: base + stringify(serialized), expected })
}

export default cases
