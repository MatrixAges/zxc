import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
const counts = {}
for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))
  const source = raw.toString('utf8')
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(source.split('---*/')[1].trim(), row.body)
  const context = vm.createContext({})
  vm.runInContext(harness, context, { timeout: 1000 })
  vm.runInContext('var observed = []; var originalThrows = assert.throws; assert.throws = function(type, callback) { observed.push(type.name); return originalThrows(type, callback); };', context)
  vm.runInContext(source, context, { timeout: 1000 })
  assert.deepEqual(Array.from(context.observed), [row.expected])
  counts[row.expected] = (counts[row.expected] ?? 0) + 1
}
assert.deepEqual(counts, { Test262Error: 10, TypeError: 2, ReferenceError: 4 })
vm.runInNewContext(harness + `
var events = [];
var iterator = function*() { events.push('resume'); throw new Test262Error(); }();
events.push('created');
assert.throws(Test262Error, function() { [...iterator]; });
assert.sameValue(events.join(','), 'created,resume');
`, {}, { timeout: 1000 })
console.log('16 original hashes/bodies/exception constructors verified: 10 Test262Error, 2 TypeError, 4 ReferenceError; generator timing control passed')
