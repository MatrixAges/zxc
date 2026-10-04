import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const base = 'docs/2026-10-04/选择完成值审阅'
const review_path = 'packages/test/upstream/reviews/language/statements/switch_completion.jsonl'
const reviews = readRows(review_path)
const facts = JSON.parse(readFileSync(`${base}/逐项证据.json`, 'utf8'))
const indexed = new Map()
const results = []

function readRows(path) {
  return readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
}

function readIndex(path) {
  for (const item of readdirSync(path, { withFileTypes: true })) {
    const file = join(path, item.name)

    if (item.isDirectory()) readIndex(file)
    else for (const row of readRows(file)) indexed.set(row.path, row.sha256)
  }
}

function encode(value) {
  return value === undefined ? { type: 'undefined' } : { type: typeof value, value }
}

readIndex('packages/test/upstream/index')
assert.equal(reviews.length, 21)
assert.equal(facts.length, 21)

for (const [index, row] of reviews.entries()) {
  const source = readFileSync(join(root, row.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')
  const checks = []
  const harness = { sameValue(actual, expected, message) {
    assert.ok(Object.is(actual, expected), `${row.path}: ${message ?? ''}`)
    checks.push({ actual: encode(actual), expected: encode(expected), message })
  } }

  assert.equal(hash, row.sha256)
  assert.equal(hash, indexed.get(row.path))
  assert.equal(facts[index].path, row.path)
  assert.equal(row.status, 'excluded')
  assert.deepEqual(row.cases, [])
  runInNewContext(source, { assert: harness }, { timeout: 1000 })
  assert.equal(checks.length, facts[index].assertions)
  results.push({ path: row.path, checks })
  console.log(`${row.path}: SHA and ${checks.length} original assertions PASS`)
}

assert.equal(results.reduce((total, row) => total + row.checks.length, 0), 92)
assert.equal(readFileSync(review_path, 'utf8'), readFileSync(`${base}/审阅草稿.jsonl`, 'utf8'))
writeFileSync(`${base}/实际完成值.json`, `${JSON.stringify(results, null, 2)}\n`)
console.log('21 complete sources; 92 original assertions PASS; zero new ZX cases')
