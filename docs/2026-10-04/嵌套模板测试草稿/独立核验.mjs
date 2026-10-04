import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const samples = readRows('packages/test/src/data/template_nested.jsonl')
const indexed = new Map()
let checked = 0

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

for (const sample of samples) {
  const source = readFileSync(join(root, sample.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')
  const path = `packages/test/tests/language/expressions/template_nested/${sample.name}`
  const zx = readFileSync(`${path}.zx`, 'utf8')

  assert.equal(hash, sample.sha256)
  assert.equal(hash, indexed.get(sample.path))
  assert.doesNotMatch(source, /flags:|includes:|negative:/)
  assert.ok(source.includes(`assert.sameValue(${sample.expression}, '${sample.expected}')`))
  assert.ok(zx.includes(`return ${sample.expression}\n`))

  for (const strict of [false, true]) {
    let calls = 0
    const harness = { sameValue(actual, expected) { calls += 1; assert.equal(actual, expected); assert.equal(expected, sample.expected) } }

    runInNewContext(`${strict ? '"use strict";\n' : ''}${source}`, { assert: harness }, { timeout: 1000 })
    assert.equal(calls, 1)
  }

  console.log(`${sample.path}: SHA + original expression preserved + 2 original executions PASS`)
}

for (const name of [...samples.map(sample => sample.name), 'dynamic']) {
  const path = `packages/test/tests/language/expressions/template_nested/${name}`
  const source = readFileSync(`${path}.zx`, 'utf8')
  const body = source.slice(source.indexOf('  return'), source.lastIndexOf('}')).replace(/\bin\./g, 'input.')
  const execute = new Function('input', body)

  for (const row of readRows(`${path}.jsonl`)) {
    assert.equal(execute(row.input), row.expected.value)
    checked += 1
  }
}

assert.equal(checked, 12)
console.log('4 whole upstream sources / 8 executions; 12 actual ZX expression bodies PASS')
