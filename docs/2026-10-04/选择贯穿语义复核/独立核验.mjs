import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const source_root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const review_path = 'packages/test/upstream/reviews/language/statements/switch_fallthrough.jsonl'
const rows = readFileSync(review_path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
const indexed = new Map()

function readIndex(path) {
  for (const item of readdirSync(path, { withFileTypes: true })) {
    const file = join(path, item.name)

    if (item.isDirectory()) readIndex(file)
    else for (const line of readFileSync(file, 'utf8').trim().split('\n')) {
      const row = JSON.parse(line)
      indexed.set(row.path, row.sha256)
    }
  }
}

readIndex('packages/test/upstream/index')

for (const [index, row] of rows.entries()) {
  const source = readFileSync(join(source_root, row.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')
  const checks = source.match(/if\(!\(SwitchTest\(/g)?.length ?? 0

  assert.equal(hash, row.sha256)
  assert.equal(hash, indexed.get(row.path))
  assert.equal(checks, [10, 11, 12, 9][index])
  assert.equal(row.status, 'excluded')
  assert.deepEqual(row.cases, [])
  runInNewContext(source, { Test262Error: Error }, { timeout: 1000 })
  console.log(`${row.path}: SHA + ${checks} original assertions PASS`)
}

assert.equal(readFileSync(review_path, 'utf8'), readFileSync('docs/2026-10-04/选择贯穿语义复核/审阅草稿.jsonl', 'utf8'))
console.log('4 complete sources, 42 original assertions; zero new ZX cases')
