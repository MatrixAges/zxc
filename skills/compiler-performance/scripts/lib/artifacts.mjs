import { createHash } from 'node:crypto'
import { createReadStream } from 'node:fs'
import { lstat, readdir, realpath } from 'node:fs/promises'
import path from 'node:path'

export async function hashFile(file) {
    const hash = createHash('sha256')

    for await (const chunk of createReadStream(file)) {
        hash.update(chunk)
    }

    return hash.digest('hex')
}

export async function listFiles(root) {
    const directory = await realpath(root)
    const files = []

    async function walk(relative) {
        const entries = await readdir(path.join(directory, relative), { withFileTypes: true })

        for (const entry of entries) {
            const name = relative ? `${relative}/${entry.name}` : entry.name

            if (entry.isSymbolicLink()) {
                throw new Error(`Refusing symlink in artifact tree: ${name}`)
            }

            if (entry.isDirectory()) {
                await walk(name)
            } else if (entry.isFile()) {
                files.push(name)
            } else {
                throw new Error(`Not a regular artifact: ${name}`)
            }
        }
    }

    await walk('')

    return { directory, files: files.sort() }
}

export async function describeFile(file) {
    const resolved = await realpath(file)
    const stat = await lstat(resolved)

    if (!stat.isFile()) {
        throw new Error(`Expected a regular file: ${file}`)
    }

    return { path: resolved, bytes: stat.size, sha256: await hashFile(resolved) }
}
