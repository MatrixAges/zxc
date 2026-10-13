#!/usr/bin/env node
import { realpath, writeFile } from 'node:fs/promises'
import path from 'node:path'
import { parseArgs } from 'node:util'
import { hashFile, listFiles } from './lib/artifacts.mjs'

async function main() {
    const { values, positionals } = parseArgs({
        allowPositionals: true,
        options: {
            help: { type: 'boolean' },
            out: { type: 'string' },
            exclude: { type: 'string', multiple: true, default: [] }
        }
    })

    if (values.help)
        return console.log(
            'Usage: compare_outputs.mjs LEFT RIGHT [--exclude EXACT_RELATIVE_FILE ...] [--out NEW_REPORT.json]\nExit 0: same; 1: different; 2: invalid input. Symlinks are rejected. No default exclusions.'
        )
    if (positionals.length !== 2) throw new Error('Expected LEFT and RIGHT directories; see --help.')

    for (const name of values.exclude) {
        if (!name || name.startsWith('/') || name.split('/').some(part => ['', '.', '..'].includes(part))) {
            throw new Error(`Expected an exact relative file path: ${name}`)
        }
    }

    const left = await listFiles(positionals[0])
    const right = await listFiles(positionals[1])

    if (left.directory === right.directory) throw new Error('The comparison needs two distinct artifact trees.')

    const excluded = new Set(values.exclude)
    const left_set = new Set(left.files.filter(name => !excluded.has(name)))
    const right_set = new Set(right.files.filter(name => !excluded.has(name)))

    if (!left_set.size && !right_set.size) throw new Error('Both artifact sets are empty after exclusions.')

    const missing_right = [...left_set].filter(name => !right_set.has(name))
    const missing_left = [...right_set].filter(name => !left_set.has(name))
    const changed = []
    let identical = 0

    for (const name of left_set) {
        if (!right_set.has(name)) continue

        const [left_hash, right_hash] = await Promise.all([
            hashFile(path.join(left.directory, name)),
            hashFile(path.join(right.directory, name))
        ])

        if (left_hash === right_hash) identical++
        else changed.push({ path: name, left_sha256: left_hash, right_sha256: right_hash })
    }

    const report = {
        left: left.directory,
        right: right.directory,
        excluded: [...excluded],
        unmatched_exclusions: [...excluded].filter(name => !left.files.includes(name) && !right.files.includes(name)),
        compared_files: left_set.size + missing_left.length,
        identical,
        missing_left,
        missing_right,
        changed,
        equal: missing_left.length === 0 && missing_right.length === 0 && changed.length === 0
    }

    const serialized = `${JSON.stringify(report, null, 2)}\n`

    if (values.out) {
        const output = path.resolve(values.out)
        const parent = await realpath(path.dirname(output))
        const canonical = path.join(parent, path.basename(output))

        if (
            [left.directory, right.directory].some(
                root => canonical === root || canonical.startsWith(`${root}${path.sep}`)
            )
        ) {
            throw new Error('Place the report outside both compared trees.')
        }

        await writeFile(canonical, serialized, { flag: 'wx' })
    }

    console.log(serialized.trimEnd())
    process.exitCode = report.equal ? 0 : 1
}

main().catch(error => {
    console.error(error.message)
    process.exitCode = 2
})
