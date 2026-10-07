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
const parts_type = '{ root: string\n dir: string\n base: string\n ext: string\n name: string }'

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
    const source = `import path from "std:path/${platform}"

export type Parts = ${parts_type}

export type Input = { path: string
 parts: string[]
 format: Parts }

export type Output = { absolute: bool
 base: string
 dir: string
 ext: string
 parsed: Parts
 formatted: string
 normalized: string
 joined: string }

export default function (in: Input): Output {
  return { absolute: path.isAbsolute(in.path), base: path.basename(in.path), dir: path.dirname(in.path), ext: path.extname(in.path), parsed: path.parse(in.path), formatted: path.format(in.format), normalized: path.normalize(in.path), joined: path.join(in.parts) }
}
`
    const base = `tests/standard/path/${platform}/values`

    writeCatalog(base + '.jsonl', rows)
    writeOutput(base + '.zx', source)
}
