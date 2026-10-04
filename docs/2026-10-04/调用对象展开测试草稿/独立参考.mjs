import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(path, 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let runs = 0

for (const sample of rows('packages/test/src/data/call_object_spread.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))
  const source = bytes.toString()
  const includes = source.match(/includes: \[([^\]]+)\]/)?.[1].split(',').map(name => name.trim()) ?? []
  const harness = ['sta.js', 'assert.js', ...includes].map(name => read(resolve(upstream, 'harness', name))).join('\n')

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + harness + '\n' + source, {}, { timeout: 1000 })
    runs++
  }
}

for (const group of ['merge', 'override']) {
  const base = 'packages/test/tests/language/expressions/call_object_spread/' + group
  const body = path => read(path).split('): Output {')[1].trim().slice(0, -1).replace(/\bin\b/g, 'input')
  const observe = new Function('input', body(base + '/observe.zx'))
  const execute = new Function('input', 'observe', body(base + '/cases.zx'))

  for (const row of rows(base + '/cases.jsonl')) {
    assert.deepEqual(execute(row.input, observe), row.expected.value)
  }
}
assert.equal(runs, 26)
console.log('PASS: 13 original SHA256; 26 complete strict/sloppy executions with native includes; 6 actual ZX and imported helper deep-result references')
