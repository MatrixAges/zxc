import { createHash } from 'node:crypto'
import { closeSync, existsSync, lstatSync, openSync, readdirSync, readSync } from 'node:fs'
import { join, relative } from 'node:path'

export default function digestPath(path: string): string | null {
	if (!existsSync(path)) return null

	const hash = createHash('sha256')
	const directory = lstatSync(path).isDirectory()

	function visit(current: string) {
		const metadata = lstatSync(current)

		if (metadata.isSymbolicLink()) throw new Error(`Evidence input cannot be a symlink: ${current}`)
		if (metadata.isDirectory()) {
			for (const name of readdirSync(current).sort()) visit(join(current, name))

			return
		}
		if (!metadata.isFile()) throw new Error(`Unsupported evidence input: ${current}`)

		hash.update(
			JSON.stringify([directory ? relative(path, current) : '', metadata.size, metadata.mode & 0o7777]) + '\0'
		)

		const file = openSync(current, 'r')
		const buffer = Buffer.alloc(1024 * 1024)

		try {
			while (true) {
				const length = readSync(file, buffer)

				if (!length) break

				hash.update(buffer.subarray(0, length))
			}
		} finally {
			closeSync(file)
		}
	}

	visit(path)

	return hash.digest('hex')
}
