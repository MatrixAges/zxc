import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(resolve(root, path), 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let count = 0

for (const sample of rows('packages/test/src/data/template_remaining.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + bytes.toString(), {
      assert: { sameValue(actual, expected) { assert.ok(Object.is(actual, expected)); count++ } },
    })
  }
}

for (const row of rows('packages/test/tests/language/lexical/template_continuations/cases.jsonl')) {
  const expression = row.source.slice(row.source.indexOf('  return ') + 9, row.source.lastIndexOf('\n}'))

  assert.equal(runInNewContext(expression), row.id.endsWith('/nested') ? '前AB后' : 'AB')
  assert.equal(Buffer.from(row.source)[row.span[0]], 92)
  assert.equal(row.span[1], row.span[0] + 2)
}

const prefix = 'test/language/expressions/template-literal/'
const expected = readdirSync(resolve(upstream, prefix)).filter(name => name.endsWith('.js')).map(name => prefix + name).sort()
const review_dir = 'packages/test/upstream/reviews'
const reviews = readdirSync(resolve(root, review_dir), { recursive: true }).filter(name => name.endsWith('.jsonl')).flatMap(name => rows(review_dir + '/' + name)).filter(row => row.path.startsWith(prefix))

assert.deepEqual(reviews.map(row => row.path).sort(), expected)

for (const review of reviews) {
  assert.equal(review.sha256, createHash('sha256').update(readFileSync(resolve(upstream, review.path))).digest('hex'))
}

const counts = Object.fromEntries(['adapted', 'equivalent', 'excluded'].map(status => [status, reviews.filter(row => row.status === status).length]))
assert.equal(count, 56)
assert.equal(expected.length, 57)
console.log(JSON.stringify({ original_assertions: count, js_continuations: 10, reviewed_directory: expected.length, counts, all_57_hashes_match: true }, null, 2))
