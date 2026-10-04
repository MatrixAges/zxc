import { gzipSync } from 'node:zlib'
import { writeOutput } from './shared/catalog.ts'
import { tarArchive, tarEntry } from './shared/tar.ts'

const long_name = 'nested/' + 'segment_'.repeat(18) + '.zx'
const valid = tarArchive([
	tarEntry({ name: './', kind: '5' }),
	tarEntry({ name: './src/', kind: '5' }),
	tarEntry({ name: 'main.zx', prefix: 'src', content: 'export const value = 7\n' }),
	tarEntry({ name: 'bin/run', content: '#!/bin/sh\nexit 0\n', mode: 0o755 }),
	tarEntry({ name: 'empty' }),
	tarEntry({ name: 'binary', content: Buffer.from(Array.from({ length: 513 }, (_, index) => index % 256)) }),
	tarEntry({ name: '././@LongLink', kind: 'L', content: long_name + '\0' }),
	tarEntry({ name: 'unused', content: 'long-name-content' }),
])
const regular = tarEntry({ name: 'file', content: 'ok' })
const fixtures: Record<string, Buffer> = {
	valid,
	empty: tarArchive([]),
	duplicate: tarArchive([regular, tarEntry({ name: './file', content: 'replaced' })]),
	directory_duplicate: tarArchive([tarEntry({ name: 'src/', kind: '5' }), tarEntry({ name: './src', kind: '5' })]),
	directory_data: tarArchive([tarEntry({ name: 'src', kind: '5', content: 'bad' })]),
	missing_end: regular,
	one_end_block: Buffer.concat([regular, Buffer.alloc(512)]),
	short_header: Buffer.alloc(511, 1),
	short_content: regular.subarray(0, 513),
	trailing_tar: Buffer.concat([tarArchive([regular]), Buffer.alloc(512, 1)]),
	long_unterminated: tarArchive([tarEntry({ name: 'long', kind: 'L', content: 'name' }), regular]),
	long_embedded_null: tarArchive([tarEntry({ name: 'long', kind: 'L', content: 'a\0b\0' }), regular]),
	long_orphan: tarArchive([tarEntry({ name: 'long', kind: 'L', content: 'name\0' })]),
	long_repeated: tarArchive([tarEntry({ name: 'long', kind: 'L', content: 'a\0' }), tarEntry({ name: 'long', kind: 'L', content: 'b\0' }), regular]),
}

for (const [name, path] of Object.entries({ parent: '../escape', absolute: '/dev/null/zxc_archive_escape', nested_parent: 'a/../escape', backslash: 'a\\b', drive: 'C:file', double_separator: 'a//b', interior_dot: 'a/./b', newline: 'a\nb', empty_path: '' })) {
	fixtures[name] = tarArchive([tarEntry({ name: path, content: 'bad' })])
}

for (const [name, kind] of Object.entries({ symlink: '2', hardlink: '1', fifo: '6', pax: 'x' })) {
	fixtures[name] = tarArchive([tarEntry({ name: 'link', kind })])
}

const invalid_size = Buffer.from(regular)
invalid_size[124] = 57
fixtures.invalid_size = tarArchive([invalid_size])

const invalid_header = Buffer.from(regular)
invalid_header[0] = 88
fixtures.invalid_header = tarArchive([invalid_header])

for (const [name, contents] of Object.entries(fixtures)) writeOutput(`tests/package_archive/fixtures/${name}.tgz`, gzipSync(contents))

const compressed = gzipSync(valid)
const invalid_crc = Buffer.from(compressed)
invalid_crc[invalid_crc.length - 8] ^= 1
const invalid_length = Buffer.from(compressed)
invalid_length[invalid_length.length - 4] ^= 1

writeOutput('tests/package_archive/fixtures/gzip_crc.tgz', invalid_crc)
writeOutput('tests/package_archive/fixtures/gzip_length.tgz', invalid_length)
writeOutput('tests/package_archive/fixtures/gzip_trailing.tgz', Buffer.concat([compressed, Buffer.from([1])]))
writeOutput('tests/package_archive/fixtures/gzip_concatenated.tgz', Buffer.concat([compressed, compressed]))
