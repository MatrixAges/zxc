import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const base = 'docs/2026-10-04/选择完成值审阅'
const rows = readRows('packages/test/upstream/reviews/language/statements/switch_tail_calls.jsonl')
const indexed = new Map()
const helper = readFileSync(join(root, 'harness/tcoHelper.js'), 'utf8')
const helper_hash = JSON.parse(readFileSync(`${base}/尾调用辅助哈希.json`, 'utf8'))['harness/tcoHelper.js']

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

readIndex('packages/test/upstream/index')
assert.equal(createHash('sha256').update(helper).digest('hex'), helper_hash)
assert.match(helper, /var \$MAX_ITERATIONS = 100000;/)

for (const row of rows) {
  const source = readFileSync(join(root, row.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')
  let calls = 0
  const harness = { sameValue(actual, expected) { calls += 1; assert.ok(Object.is(actual, expected)) } }

  assert.equal(hash, row.sha256)
  assert.equal(hash, indexed.get(row.path))
  assert.match(source, /flags: \[onlyStrict\]/)

  try {
    runInNewContext(`"use strict";\n${helper}\n${source}`, { assert: harness }, { timeout: 1000 })
    assert.equal(calls, 1)
    console.log(`${row.path}: SHA PASS; original depth reference PASS`)
  } catch (error) {
    if (error.name !== 'RangeError' || !/call stack/i.test(error.message)) throw error
    assert.equal(calls, 0)
    console.log(`${row.path}: SHA PASS; reference engine stack overflow at original depth; NOT PASS`)
  }
}

console.log('No recursion depth change; ZX exclusion is based on its no-recursion contract')
