import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const reviews = readRows('packages/test/upstream/reviews/language/statements/switch_environment.jsonl')
const cases = readRows('packages/test/tests/language/statements/switch_environment/cases.jsonl')
const indexed = new Map()

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

for (const [index, row] of reviews.entries()) {
  const source = readFileSync(join(root, row.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')
  let calls = 0
  const harness = { sameValue(actual, expected) { calls += 1; assert.ok(Object.is(actual, expected)) } }

  assert.equal(hash, row.sha256)
  assert.equal(hash, indexed.get(row.path))

  if (index < 2) {
    assert.throws(() => runInNewContext(source, {}, { timeout: 1000 }), error => error.name === 'ReferenceError')
    const test_case = cases[index]
    const token = index === 0 ? 'x' : 'f'

    assert.equal(test_case.source.slice(...test_case.span), token)
    assert.deepEqual(row.diagnostics[0].span, test_case.span)
    assert.equal(row.diagnostics[0].case, test_case.id)
    assert.equal(row.status, 'adapted')
    assert.match(source, /phase: runtime\s+type: ReferenceError/)
  } else {
    runInNewContext(source, { assert: harness }, { timeout: 1000 })
    assert.equal(calls, [0, 0, 3, 2, 3, 4][index])
    assert.equal(row.status, 'excluded')
    assert.deepEqual(row.cases, [])
  }

  console.log(`${row.path}: SHA PASS; ${index < 2 ? 'ReferenceError PASS' : `${calls} original assertions PASS`}`)
}

console.log('6 complete sources: 2 runtime negatives + 12 original assertions PASS')
