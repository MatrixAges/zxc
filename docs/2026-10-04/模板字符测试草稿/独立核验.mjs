import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const groups = readRows('packages/test/src/data/template_characters.jsonl')
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

for (const [index, group] of groups.entries()) {
  const source = readFileSync(join(root, group.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')

  assert.equal(hash, group.sha256)
  assert.equal(hash, indexed.get(group.path))
  assert.doesNotMatch(source, /flags:|includes:|negative:/)

  for (const sample of group.samples) {
    assert.ok(source.includes(sample.expression))
    assert.equal(new Function(`return ${sample.expression}`)(), sample.expected)
  }

  for (const strict of [false, true]) {
    let calls = 0
    const harness = { sameValue(actual, expected) { calls += 1; assert.equal(actual, expected) } }

    runInNewContext(`${strict ? '"use strict";\n' : ''}${source}`, { assert: harness }, { timeout: 1000 })
    assert.equal(calls, [30, 6, 3, 1][index])
  }

  console.log(`${group.path}: SHA and complete strict/sloppy reference PASS`)
}

for (const name of ['literals', 'escaped_interpolation']) {
  const path = `packages/test/tests/language/expressions/template_characters/${name}`
  const source = readFileSync(`${path}.zx`, 'utf8')
  const start = source.indexOf(name === 'literals' ? '  switch' : '  return')
  const body = source.slice(start, source.lastIndexOf('}')).replace('switch (in)', 'switch (input)').replace('${in}', '${input}')
  const execute = new Function('input', body)

  for (const row of readRows(`${path}.jsonl`)) {
    assert.equal(execute(row.input), row.expected.value)
    checked += 1
  }
}

assert.equal(checked, 13)
console.log('4 complete sources / 80 original assertions; 10 retained literals + 13 actual ZX outputs PASS')
