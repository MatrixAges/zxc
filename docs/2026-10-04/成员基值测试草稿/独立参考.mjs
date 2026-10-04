import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const sample = JSON.parse(readFileSync('packages/test/src/data/member_base.jsonl', 'utf8'))
const bytes = readFileSync(resolve(upstream, sample.path))
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(upstream, 'harness', name), 'utf8')).join('\n')

assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

for (const prefix of ['', '"use strict";\n']) {
  runInNewContext(prefix + harness + '\n' + bytes.toString(), {}, { timeout: 1000 })
}

const rows = readFileSync('packages/test/tests/language/types/member_base/cases.jsonl', 'utf8').trim().split('\n').map(line => JSON.parse(line))

for (const row of rows) {
  if (!row.span) continue

  assert.ok(row.span[0] >= row.source.indexOf('  return'))
  assert.ok(row.span[1] <= Buffer.byteLength(row.source))
  assert.ok(row.span[1] > row.span[0])
}

assert.equal(rows.filter(row => row.diagnostic === null).length, 4)
assert.equal(rows.filter(row => row.diagnostic !== null).length, 10)
console.log('PASS: original SHA256; complete original strict/sloppy executions using Test262 harness; 10 diagnostic ranges and 4 positive controls inventoried')
