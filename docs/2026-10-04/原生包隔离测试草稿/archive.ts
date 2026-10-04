import { createHash } from 'node:crypto'
import { readFileSync, readdirSync, writeFileSync } from 'node:fs'
import { dirname, basename, join } from 'node:path'
import { gzipSync } from 'node:zlib'
import { tarArchive, tarEntry } from '../../src/shared/tar.ts'

export default function writeArchive(path: string, files: Record<string, string | Buffer>) {
	const entries = Object.entries(files).map(([name, content]) => {
		const prefix = dirname(name) === '.' ? '' : dirname(name)
		if (Buffer.byteLength(prefix) > 155 || Buffer.byteLength(basename(name)) > 100) throw new Error('fixture path exceeds ustar fields')

		return tarEntry({ name: basename(name), prefix, content })
	})
	const bytes = gzipSync(tarArchive(entries))
	writeFileSync(path, bytes)

	return { archive: basename(path), sha256: createHash('sha256').update(bytes).digest('hex') }
}

export function readDirectory(directory: string): Record<string, Buffer> {
	const files: Record<string, Buffer> = {}

	function visit(relative: string): void {
		for (const entry of readdirSync(join(directory, relative), { withFileTypes: true })) {
			const path = relative ? `${relative}/${entry.name}` : entry.name
			if (entry.isDirectory()) visit(path)
			else if (entry.isFile()) files[path] = readFileSync(join(directory, path))
			else throw new Error(`unsupported fixture entry: ${path}`)
		}
	}

	visit('')
	return files
}
