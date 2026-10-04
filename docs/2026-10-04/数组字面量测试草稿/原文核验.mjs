import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const root = resolve('packages/test')
const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const readRows = path => readFileSync(path, 'utf8').trim().split('\n').map(JSON.parse)
const samples = readRows(resolve(root, 'src/data/array_literal.jsonl'))
let checks = 0
let matched = 0
let bounds = 0

for (const sample of samples) {
  const raw = readFileSync(resolve(base, sample.path))
  const source = raw.toString('utf8')
  assert.equal(createHash('sha256').update(raw).digest('hex'), sample.sha256)
  assert.equal(source.match(/^var array = (.*);$/m)[1], sample.literal)
  assert.equal((source.match(/\/\/CHECK#/g) ?? []).length, sample.checks)
  vm.runInNewContext(source, { Test262Error: Error }, { timeout: 1000 })
  checks += sample.checks
  const folder = { 'A1.1': 'empty', 'A1.3': 'dense', A2: 'nested' }[sample.group]
  if (!folder) continue
  for (const row of readRows(resolve(root, `tests/language/expressions/array_literal/${folder}/cases.jsonl`))) {
    if (row.id.includes('/extension/')) {
      const array = JSON.parse(sample.literal)
      const index = row.input
      assert.ok(typeof index === 'number' ? index - 1 >= array.length : index.row >= array.length || index.column >= array[index.row].length)
      assert.equal(row.expected.error, 'IndexOutOfBounds')
      bounds++
      continue
    }
    const check = Number(row.id.split('_').at(-1))
    const marker = new RegExp(`//CHECK#${check}\\s`)
    const start = source.search(marker)
    assert.ok(start >= 0)
    const section = source.slice(start)
    const condition = section.match(/if \(([^\n]+) !== (\d+)\)/)
    assert.ok(condition)
    const actual = vm.runInNewContext(source.slice(0, start) + '\n' + condition[1], { Test262Error: Error }, { timeout: 1000 })
    assert.equal(actual, Number(condition[2]))
    assert.equal(row.expected.value, actual)
    matched++
  }
}
assert.equal(checks, 75)
assert.equal(matched, 17)
assert.equal(bounds, 4)
console.log('8 hashes / 75 original checks; 17 numeric expectations and 4 ZX bounds extensions verified')
