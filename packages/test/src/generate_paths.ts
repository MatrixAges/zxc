import { posix, win32 } from 'node:path'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const paths = [
	'',
	'.',
	'..',
	'./',
	'../',
	'/',
	'//',
	'///',
	'/a',
	'/a/',
	'/a//b/../c/',
	'a/b',
	'a//b',
	'a/../../b',
	'.hidden',
	'..hidden',
	'a.',
	'a..',
	'a.tar.gz',
	'/a/.hidden',
	'/a/..',
	'/a/../',
	'文件/🌱.txt',
	'C:',
	'C:foo',
	'C:/',
	'C:/a/b.txt',
	'C:\\a\\b.txt',
	'C:\\a\\..\\b\\',
	'\\',
	'\\a',
	'\\\\server\\share',
	'\\\\server\\share\\',
	'\\\\server\\share\\file.txt',
	'//server/share/a/../b',
	'///server/share',
	'\\\\?\\C:\\a\\b',
	'a\\b/c',
	'a/b\\c',
	'C:..\\a'
]
const parts_type = '{ root: string; dir: string; base: string; ext: string; name: string; }'

for (const [platform, path] of Object.entries({ posix, win32 })) {
	const inputs = paths.map(value => ({
		path: value,
		parts: ['', value, '..', 'leaf.ext'],
		format: path.parse(value)
	}))

	for (const format of [
		{ root: '/', dir: '', base: '', ext: 'txt', name: 'file' },
		{ root: 'C:\\', dir: '', base: 'chosen', ext: '.ignored', name: 'ignored' },
		{ root: '/', dir: '/override', base: 'base', ext: '.x', name: 'name' },
		{ root: '', dir: '', base: '', ext: '', name: '' }
	])
		inputs.push({ path: '', parts: [], format })

	const rows = inputs.map((input, index) => ({
		id: `standard/path/${platform}/${index}`,
		input,
		expected: {
			value: {
				absolute: path.isAbsolute(input.path),
				base: path.basename(input.path),
				dir: path.dirname(input.path),
				ext: path.extname(input.path),
				parsed: path.parse(input.path),
				formatted: path.format(input.format),
				normalized: path.normalize(input.path),
				joined: path.join(...input.parts)
			}
		}
	}))
	const source = `import path from "std:path/${platform}";\n\nexport type Parts = ${parts_type};\n\nexport type Input = { path: string; parts: string[]; format: Parts; };\n\nexport type Output = { absolute: bool; base: string; dir: string; ext: string; parsed: Parts; formatted: string; normalized: string; joined: string; };\n\nexport default function (in: Input): Output {\n  return { absolute: path.isAbsolute(in.path), base: path.basename(in.path), dir: path.dirname(in.path), ext: path.extname(in.path), parsed: path.parse(in.path), formatted: path.format(in.format), normalized: path.normalize(in.path), joined: path.join(in.parts) };\n}\n`
	const base = `tests/standard/path/${platform}/values`

	writeCatalog(base + '.jsonl', rows)
	writeOutput(base + '.zx', source)
}
