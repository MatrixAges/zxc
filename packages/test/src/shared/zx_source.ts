import { execFileSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'

export default function zxSource(source: string, verbatim = false): string {
    if (verbatim) return source

    const temporary_dir = mkdtempSync(join(tmpdir(), 'zxc-source-'))
    const input_path = join(temporary_dir, 'source.zx')
    const tool_path = process.env.ZXC ?? resolve(import.meta.dirname, '../../../../zig-out/bin/zxc')

    try {
        writeFileSync(input_path, source)
        execFileSync(tool_path, ['fmt', input_path, '--write'])

        return readFileSync(input_path, 'utf8')
    } finally {
        rmSync(temporary_dir, { recursive: true, force: true })
    }
}
