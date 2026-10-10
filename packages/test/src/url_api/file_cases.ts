import type { Case } from './write_suite.ts'
import type { Json } from '../shared/json.ts'
import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import toRecord from './record.ts'
import writeSuite from './write_suite.ts'

type Reference = {
    operation: string
    input: string
    windows: boolean
    cwd?: string
    expected?: Array<number>
    error?: string
}

function fileError(row: Reference, parsed: URL | null): string | undefined {
    if (!row.error) return undefined
    if (row.operation === 'from_path') return row.error === 'ERR_INVALID_URL' ? 'InvalidHost' : 'InvalidFilePath'
    if (parsed!.protocol !== 'file:') return 'InvalidFileUrl'
    if (!row.windows && parsed!.hostname !== '') return 'InvalidFileUrlHost'

    return 'InvalidFileUrlPath'
}

export default function writeFiles(): void {
    const data = JSON.parse(
        readFileSync(new URL('../../tests/standard/url/api/fixtures/file_reference.json', import.meta.url), 'utf8')
    ) as { cases: Array<Reference> }

    assert.equal(data.cases.length, 1449)

    for (const [source, operation] of [
        ['from_path', 'pathToFileURL'],
        ['to_path', 'fileURLToPath'],
        ['to_bytes', 'fileURLToBytes']
    ]) {
        const rows: Array<Case> = []

        for (const [index, row] of data.cases.entries()) {
            if (row.operation !== source) continue

            const parsed = source === 'from_path' ? null : new URL(row.input)
            const input: Json = parsed
                ? { url: toRecord(parsed), windows: row.windows }
                : { path: row.input, cwd: row.cwd!, windows: row.windows }
            const value = row.expected
                ? source === 'to_bytes'
                    ? row.expected
                    : Buffer.from(row.expected).toString('utf8')
                : undefined
            const error = fileError(row, parsed)

            rows.push({ name: `reference-${index}`, input, value, error })
        }

        const fields = source === 'from_path' ? 'path: in.path, cwd: in.cwd' : 'url: in.url'

        writeSuite({
            operation,
            input:
                source === 'from_path' ? '{ path: string, cwd: string, windows: bool }' : '{ url: Url, windows: bool }',
            output: source === 'to_bytes' ? 'u8[]' : 'string',
            body: `return url.${operation}({ ${fields}, platform: in.windows ? Platform.Windows : Platform.Posix })`,
            rows
        })
    }
}
