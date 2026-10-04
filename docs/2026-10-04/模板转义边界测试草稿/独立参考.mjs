import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = path => readFileSync(resolve(root, path), 'utf8').trim().split('\n').map(line => JSON.parse(line))
const samples = rows('packages/test/src/data/template_escapes.jsonl')
const cases = rows('packages/test/tests/language/lexical/template_escapes/cases.jsonl')
let rejected = 0
let accepted = 0

for (const sample of samples) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)
  assert.equal(bytes.toString().split('$DONOTEVALUATE();')[1].trim().replace(/;$/, ''), sample.expression)

  for (const prefix of ['', '"use strict";\n']) {
    assert.throws(() => new Script(prefix + bytes.toString()), SyntaxError)
    rejected++
  }
}

for (const row of cases) {
  const expression = row.source.slice(row.source.indexOf('  return ') + 9, row.source.lastIndexOf('\n}'))

  if (row.id.includes('/upstream/')) {
    assert.throws(() => new Script(expression), SyntaxError)
    rejected++
  } else {
    new Script(expression)
    accepted++
  }

  if (row.span) {
    const bytes = Buffer.from(row.source)

    assert.equal(bytes[row.span[0]], 92)
    assert.ok([48, 56, 57, 113, 117, 120].includes(bytes[row.span[0] + 1]))
    assert.equal(row.span[1], row.span[0] + 2)
  }
}

assert.equal(cases.length, 50)
assert.equal(rejected, 64)
assert.equal(accepted, 18)
console.log('PASS: 16 original hashes and expressions; 32 original strict/sloppy SyntaxErrors; 32 wrapped invalid expressions; 18 valid JS controls; all diagnostic byte spans')
