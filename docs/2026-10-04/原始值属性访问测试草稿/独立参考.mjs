import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(resolve(root, path), 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let runs = 0

for (const sample of rows('packages/test/src/data/property_primitives.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + bytes.toString(), { Test262Error: class extends Error {} })
    runs++
  }
}

const base = 'packages/test/tests/language/expressions/property_primitives/string_length'
const expression = read(base + '.zx').match(/return (.*)\n}/)[1]
const row = rows(base + '.jsonl')[0]

assert.equal(expression, '"abc123".length')
assert.equal(runInNewContext(expression), row.expected.value)
assert.equal(runs, 10)
console.log('PASS: 5 original hashes; 10 complete original strict/sloppy runs; unchanged ASCII length expression and expected 6')
