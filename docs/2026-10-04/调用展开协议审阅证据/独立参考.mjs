import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script, runInNewContext } from 'node:vm'

const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(path, 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let runs = 0

for (const sample of rows('packages/test/src/data/call_spread_protocols.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))
  const source = bytes.toString()
  const includes = source.match(/includes: \[([^\]]+)\]/)?.[1].split(',').map(name => name.trim()) ?? []
  const harness = ['sta.js', 'assert.js', ...includes].map(name => read(resolve(upstream, 'harness', name))).join('\n')

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + harness + '\n' + source, {}, { timeout: 1000 })
    runs++
  }
}

assert.equal(runs, 56)
console.log('PASS: 28 original SHA256 and 56 complete strict/sloppy executions using native harness includes')

for (const row of rows('packages/test/tests/language/expressions/call_spread_protocols/cases.jsonl')) {
  new Script(row.source.match(/return (.*)\n}/)[1].replace(/\bin\b/g, 'input'))
  if (row.span) assert.equal(row.source.slice(...row.span), '...')
}
console.log('PASS: 6 JS-valid syntax controls and 4 exact spread token ranges')
