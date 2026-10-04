import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const evidence = JSON.parse(readFileSync(new URL('./原文证据.json', import.meta.url), 'utf8'))
let scenarios = 0
let explicit_assertions = 0

function execute(source) {
  vm.runInNewContext(source, {
    Test262Error: Error,
    assert: {
      sameValue(actual, expected) {
        assert.ok(Object.is(actual, expected))
        explicit_assertions++
      },
      throws(expected, callback) {
        let caught
        try { callback() } catch (error) { caught = error }
        assert.ok(caught)
        assert.equal(caught.constructor, expected)
        explicit_assertions++
      }
    }
  }, { timeout: 1000 })
}

for (const item of evidence) {
  const raw = readFileSync(resolve(base, item.path))
  const source = raw.toString('utf8')
  assert.equal(createHash('sha256').update(raw).digest('hex'), item.sha256)
  const count = (source.match(/\/\/\s*CHECK\s*#\d+/g) ?? []).length || (source.match(/assert\.(?:throws|sameValue)\(/g) ?? []).length
  assert.equal(count, item.scenarios)
  execute(source)
  scenarios += count
}

assert.equal(scenarios, 58)
assert.equal(explicit_assertions, 5)
const path = 'test/language/expressions/unary-plus/S9.3_A5_T2.js'
const original = readFileSync(resolve(base, path), 'utf8')
const targets = ['isNaN(+(new Number(Number.NaN)) !== true)', 'isNaN(+(new Number(void 0)) !== true)']
for (const target of targets) {
  assert.ok(original.includes(target))
  execute(original.replace(target, 'isNaN(0 !== true)'))
}
assert.equal(vm.runInNewContext('isNaN(0 !== true)'), false)
assert.equal(vm.runInNewContext('Object.is(+(-0), -0) && Object.is(+(null), +0) && Object.is(+(false), +0)'), true)
console.log('14 upstream files / 58 scenarios reference execution passed; 2 weak NaN conditions also pass after incorrect-zero mutation')
