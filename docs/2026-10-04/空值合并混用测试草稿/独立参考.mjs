import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(resolve(root, path), 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let negatives = 0
let positives = 0

for (const sample of rows('packages/test/src/data/coalesce_mixing.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)
  assert.equal(bytes.toString().split('$DONOTEVALUATE();')[1].trim().replace(/;$/, ''), sample.expression)

  for (const prefix of ['', '"use strict";\n']) assert.throws(() => new Script(prefix + bytes.toString()), SyntaxError)
}

for (const row of rows('packages/test/tests/language/expressions/coalesce_mixing/cases.jsonl')) {
  const expression = row.source.match(/return (.*)\n}/)[1]

  if (row.diagnostic) {
    assert.throws(() => new Script(expression), SyntaxError)
    assert.ok(['??', '&&', '||'].includes(row.source.slice(...row.span)))
    negatives++
  } else {
    new Script(expression)
    positives++
  }
}

const prefix = 'test/language/expressions/coalesce/'
const expected = readdirSync(resolve(upstream, prefix)).filter(name => name.endsWith('.js')).map(name => prefix + name).sort()
const dir = 'packages/test/upstream/reviews'
const reviews = readdirSync(resolve(root, dir), { recursive: true }).filter(name => name.endsWith('.jsonl')).flatMap(name => rows(dir + '/' + name)).filter(row => row.path.startsWith(prefix))

assert.deepEqual(reviews.map(row => row.path).sort(), expected)

for (const row of reviews) assert.equal(createHash('sha256').update(readFileSync(resolve(upstream, row.path))).digest('hex'), row.sha256)

assert.equal(negatives, 8)
assert.equal(positives, 8)
assert.equal(expected.length, 24)
console.log(JSON.stringify({ original_hashes: 4, original_parse_rejections: 8, negatives, positives, coalesce_files: expected.length, statuses: Object.fromEntries(['adapted', 'equivalent', 'excluded'].map(status => [status, reviews.filter(row => row.status === status).length])) }, null, 2))
