#!/usr/bin/env node
import { readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'
import { parseArgs } from 'node:util'
import { listFiles } from './lib/artifacts.mjs'

const patterns = {
    functions: /\bfn\s+[A-Za-z_][A-Za-z_0-9]*\s*\(/g,
    memcpy: /@memcpy\s*\(/g,
    dupe: /\.dupe\s*\(/g,
    renew: /\bzxRenew\s*\(/g,
    reserve: /\bzxReserve\s*\(/g,
    defer: /\bdefer\b/g,
    errdefer: /\berrdefer\b/g,
    try: /\btry\b/g
}

async function main() {
    const { values, positionals } = parseArgs({
        allowPositionals: true,
        options: { help: { type: 'boolean' }, out: { type: 'string' }, top: { type: 'string', default: '20' } }
    })

    if (values.help)
        return console.log(
            'Usage: inspect_generated.mjs GENERATED_DIR [--top 20] [--out NEW_REPORT.json]\nRanks Zig files by bytes and textual copy/cleanup sites. These are static search signals, not runtime costs or semantic proof.'
        )

    const top = Number(values.top)
    if (positionals.length !== 1 || !Number.isInteger(top) || top < 1)
        throw new Error('Expected a directory and positive --top; see --help.')

    const { directory, files } = await listFiles(positionals[0])
    const rows = []

    for (const name of files.filter(file => file.endsWith('.zig'))) {
        const buffer = await readFile(path.join(directory, name))
        const source = buffer.toString('utf8')
        const counts = Object.fromEntries(
            Object.entries(patterns).map(([key, pattern]) => [key, [...source.matchAll(pattern)].length])
        )

        rows.push({
            path: name,
            bytes: buffer.length,
            lines: source ? source.split('\n').length - Number(source.endsWith('\n')) : 0,
            ...counts
        })
    }

    if (!rows.length) throw new Error('No Zig files found; no meaningful inventory produced.')

    const fields = ['bytes', 'lines', ...Object.keys(patterns)]
    const totals = Object.fromEntries(fields.map(key => [key, rows.reduce((sum, row) => sum + row[key], 0)]))
    const rank = score => [...rows].sort((a, b) => score(b) - score(a) || a.path.localeCompare(b.path)).slice(0, top)
    const report = {
        directory,
        files: rows.length,
        totals,
        largest: rank(row => row.bytes),
        copy_sites: rank(row => row.memcpy + row.dupe + row.renew),
        cleanup_sites: rank(row => row.defer + row.errdefer),
        limitations: [
            'Lexical counts include comments and strings; inspect actual code and IR before attributing cost.',
            'Static counts do not measure copy bytes, execution frequency, RSS, or semantic duplication.',
            'defer/try counts are candidates for IR expansion inspection, not an expansion estimate.'
        ]
    }

    const serialized = `${JSON.stringify(report, null, 2)}\n`
    if (values.out) await writeFile(path.resolve(values.out), serialized, { flag: 'wx' })
    console.log(serialized.trimEnd())
}

main().catch(error => {
    console.error(error.message)
    process.exitCode = 2
})
