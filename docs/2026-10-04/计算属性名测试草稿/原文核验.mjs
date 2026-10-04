import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')
let same_values = 0
const errors = []

for (const row of evidence) {
  const raw = readFileSync(resolve(base, row.path))

  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
  const context = vm.createContext(Object.create(null))
  vm.runInContext(harness, context)
  vm.runInContext('var observedErrors = []; var sameValues = 0; var originalSameValue = assert.sameValue; var originalThrows = assert.throws; assert.sameValue = function(a,b,m) { sameValues++; return originalSameValue(a,b,m); }; assert.throws = function(c,f,m) { observedErrors.push(c.name); return originalThrows(c,f,m); };', context)
  vm.runInContext(raw.toString(), context, { timeout: 1000 })
  same_values += context.sameValues
  errors.push(...context.observedErrors)
}

const cases = readFileSync('packages/test/tests/language/types/object_computed/cases.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of cases) {
  const name = row.id.split('/')[3]
  const original = evidence.find(sample => sample.path.endsWith(`from-${name}.js`))
  assert.ok(original)
  const expression = row.source.match(/const object = (\{[\s\S]*?\});/)[1]
  const evaluate = text => vm.runInNewContext(`const x = 1; JSON.stringify(${text});`, Object.create(null))
  assert.equal(evaluate(expression), evaluate(original.expression))
  assert.equal(row.source.slice(...row.span), row.diagnostic === 'lexical' ? "'" : '[')
}

assert.equal(evidence.length, 14)
assert.equal(cases.length, 9)
assert.deepEqual(errors.sort(), ['ReferenceError', 'ReferenceError', 'Test262Error', 'Test262Error', 'TypeError', 'TypeError'])
console.log(`14 original hashes/bodies executed; ${same_values} sameValue checks; 6 accessor exceptions verified; 9 preserved/quote-adapted expressions and expected spans checked`)
