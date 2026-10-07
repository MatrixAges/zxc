import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'

assert.ok(process.argv.includes('--check'))

const root = process.cwd()
const draft = join(import.meta.dirname, '草稿/packages/test/src/generate_match_scalars.ts')
const source = readFileSync(draft, 'utf8').replace(
    './shared/catalog.ts',
    pathToFileURL(join(root, 'packages/test/src/shared/catalog.ts')).href
)
const temporary = '/tmp/zxc-match-scalars-generator-probe.ts'

writeFileSync(temporary, source)
await import(pathToFileURL(temporary).href)
console.log('PASS: draft generator exactly matches every existing output; no catalog or source was rewritten')
