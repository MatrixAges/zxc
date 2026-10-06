import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { jsonLines } from './json.ts'

export const package_dir = resolve(import.meta.dirname, '../..')
export const check_mode = process.argv.includes('--check')

export function writeOutput(path: string, content: string | Buffer): void {
    const output = resolve(package_dir, path)

    if (check_mode) {
        if (!readFileSync(output).equals(Buffer.from(content))) throw new Error(`outdated catalog: ${output}`)
    } else {
        mkdirSync(dirname(output), { recursive: true })
        writeFileSync(output, content)
    }
}

export function writeCatalog(path: string, rows: Array<unknown>): void {
    writeOutput(path, jsonLines(rows))
    console.log(`${path}: ${rows.length} named cases`)
}

export function range(length: number): Array<number> {
    return Array.from({ length }, (_, index) => index)
}

export function product<T>(values: ReadonlyArray<T>, length: number): Array<Array<T>> {
    let rows: Array<Array<T>> = [[]]

    for (let index = 0; index < length; index++) rows = rows.flatMap(row => values.map(value => [...row, value]))

    return rows
}
