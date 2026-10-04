export function tarEntry(args: { name: string, content?: Buffer | string, kind?: string, mode?: number, prefix?: string }): Buffer {
	const { name, content = '', kind = '0', mode = 0o644, prefix = '' } = args
	const header = Buffer.alloc(512)
	const data = Buffer.from(content)

	header.write(name, 0, 100)
	header.write(mode.toString(8).padStart(7, '0'), 100, 7)
	header.write('0000000', 108, 7)
	header.write('0000000', 116, 7)
	header.write(data.length.toString(8).padStart(11, '0'), 124, 11)
	header.write('00000000000', 136, 11)
	header.fill(32, 148, 156)
	header.write(kind, 156, 1)
	header.write('ustar\0', 257, 6)
	header.write('00', 263, 2)
	header.write(prefix, 345, 155)
	header.write([...header].reduce((sum, byte) => sum + byte, 0).toString(8).padStart(6, '0') + '\0 ', 148, 8)

	return Buffer.concat([header, data, Buffer.alloc((512 - data.length % 512) % 512)])
}

export function tarArchive(entries: Array<Buffer>): Buffer {
	return Buffer.concat([...entries, Buffer.alloc(1024)])
}
