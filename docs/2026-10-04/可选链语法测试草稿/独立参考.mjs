import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script, runInNewContext } from 'node:vm'

const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = path => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(upstream, 'harness', name), 'utf8')).join('\n')
let positives = 0
let negatives = 0

for (const sample of rows('packages/test/src/data/optional_chain_boundary.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))
  const source = bytes.toString()

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    if (source.includes('negative:')) {
      assert.throws(() => new Script(prefix + source), SyntaxError)
      negatives++
    } else {
      runInNewContext(prefix + harness + '\n' + source, {}, { timeout: 1000 })
      positives++
    }
  }
}

for (const row of rows('packages/test/tests/language/expressions/optional_chain_boundary/cases.jsonl')) {
  const expression = row.source.match(/return ([\s\S]*?)\n}/)[1].replace(/\bin\b/g, 'input')
  const is_invalid = /\/(assignment|prefix|postfix|template)\//.test(row.id + '/')

  if (is_invalid) assert.throws(() => new Script(expression), SyntaxError)
  else new Script(expression)

  if (row.span) assert.equal(Buffer.from(row.source).subarray(...row.span).toString(), '.')
}

assert.equal(positives, 4)
assert.equal(negatives, 22)
console.log('PASS: 13 SHA256; 4 complete original runtime executions; 22 original parse negatives; JS syntax cross-check and exact dot ranges for 19 ZX controls')
