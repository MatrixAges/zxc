import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
let checked = 0

for (const path of new Set(rows.map(row => row.path))) {
  const raw = readFileSync(resolve(base, path))
  const source = raw.toString('utf8')
  const samples = rows.filter(row => row.path === path)
  assert.equal(createHash('sha256').update(raw).digest('hex'), samples[0].sha256)
  const expressions = path.endsWith('_A1.js')
    ? [...source.matchAll(/eval\(("[^"\n]*")\)/g)].map(match => JSON.parse(match[1]))
    : path.endsWith('_T1.js')
      ? [...source.matchAll(/if \((\+.*?) !== 1\)/g)].map(match => match[1])
      : [source.match(/try \{\s*(\+x);/)[1]]
  assert.deepEqual(samples.map(row => row.expression), expressions)
  assert.equal((source.match(/\/\/CHECK#/g) ?? []).length, samples.length)
  vm.runInNewContext(source, { Test262Error: Error }, { timeout: 1000 })
  for (const sample of samples) {
    if (sample.expected === 'ReferenceError') continue
    assert.equal(vm.runInNewContext(sample.expression, { x: 1, object: { prop: 1 } }), sample.expected)
  }
  checked += samples.length
}

assert.equal(checked, 16)
console.log('3 upstream hashes and 16 original scenarios verified; JS reference only')
