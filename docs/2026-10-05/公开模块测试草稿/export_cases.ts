import type { Case } from './inspect_cases.ts'
import { stringify } from 'yaml'

const base = 'name: sample\nversion: 1.0.0\n'
const cases: Array<Case> = []

function reject(args: { name: string; fields: string; message: string }): void {
	const { name, fields, message } = args
	const marked = base + fields
	const offset = marked.indexOf('§')

	if (offset < 0) throw new Error('missing diagnostic position')

	const before = marked.slice(0, offset)

	cases.push({
		name: `exports ${name}`,
		source: marked.replace('§', ''),
		diagnostic: { message, line: before.split('\n').length, column: offset - before.lastIndexOf('\n') }
	})
}

for (const path of ['.', './increment', './nested/math', './A1_b-c/2']) {
	for (const source of ['main.zx', 'flow.rx', 'source folder/模块.zx']) {
		cases.push({
			name: `exports ${path} to ${source}`,
			source: base + stringify({ exports: { [path]: source } }),
			expected: { entry: null, exports: [{ path, source }] }
		})
	}
}

cases.push({
	name: 'exports preserves declaration order and shared implementation',
	source: base + 'exports:\n  ./z: main.zx\n  .: main.zx\n  ./a: other.rx\n',
	expected: {
		exports: [
			{ path: './z', source: 'main.zx' },
			{ path: '.', source: 'main.zx' },
			{ path: './a', source: 'other.rx' }
		]
	}
})

for (const value of ['[]', 'text', '!!int 3'])
	reject({ name: `mapping ${value}`, fields: `exports: §${value}\n`, message: 'expected a YAML mapping' })

reject({ name: 'empty mapping', fields: 'exports: §{}\n', message: 'exports must declare at least one public module' })
reject({
	name: 'duplicate export',
	fields: 'exports:\n  ./a: a.zx\n  §./a: b.zx\n',
	message: 'duplicate YAML mapping key'
})

for (const path of [
	'./',
	'module',
	'/absolute',
	'./a/',
	'./a//b',
	'./..',
	'./a/../b',
	'./a.b',
	'./*',
	'./a b',
	'./中文',
	'./a\\b'
]) {
	reject({
		name: `invalid public path ${path}`,
		fields: `exports:\n  §${JSON.stringify(path)}: main.zx\n`,
		message: 'export paths must be . or ./ followed by explicit module path segments'
	})
}

for (const source of ['/main.zx', '../main.zx', 'a/../main.zx', 'C:main.zx', 'a\\main.zx']) {
	reject({
		name: `escaping source ${source}`,
		fields: `exports:\n  .: §${JSON.stringify(source)}\n`,
		message: 'export implementation must stay inside the package'
	})
}

for (const value of ['[]', '{}', '!!int 3', '""', '"bad\\0path"']) {
	const message = value.startsWith('"')
		? 'empty strings and NUL are not allowed in this field'
		: 'expected a string scalar'

	reject({ name: `invalid implementation ${value}`, fields: `exports:\n  .: §${value}\n`, message })
}

cases.push({
	name: 'exports conflicts with legacy entry',
	source: base + 'entry: main.zx\nexports:\n  .: main.zx\n',
	diagnostic: { message: 'entry and exports cannot both define the package public interface', line: 1, column: 1 }
})

export default cases
