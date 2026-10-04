import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { globSync, readFileSync } from 'node:fs'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const samples = readRows('packages/test/src/data/template_order.jsonl')
const indexed = new Map(globSync('packages/test/upstream/index/**/*.jsonl').flatMap(path => readRows(path).map(row => [row.path, row.sha256])))
class Test262Error extends Error {}

function readRows(path) {
  return readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
}

for (const [index, sample] of samples.entries()) {
  const source = readFileSync(`${root}/${sample.path}`, 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')

  assert.equal(hash, sample.sha256)
  assert.equal(hash, indexed.get(sample.path))
  assert.doesNotMatch(source, /flags:|includes:|negative:/)

  for (const strict of [false, true]) {
    let calls = 0
    const harness = {
      sameValue(actual, expected) { calls += 1; assert.equal(actual, expected) },
      throws(constructor, execute) {
        calls += 1
        assert.throws(execute, error => error.constructor === constructor)
      },
    }

    runInNewContext(`${strict ? '"use strict";\n' : ''}${source}`, { assert: harness, Test262Error }, { timeout: 1000 })
    assert.equal(calls, index === 0 ? 5 : 1)
  }
}

let checked = 0

for (const name of ['order', 'first', 'middle', 'later']) {
  const path = `packages/test/tests/runtime/evaluation_order/template/${name}`
  const source = readFileSync(`${path}.zx`, 'utf8')
  const body = source.slice(source.indexOf('  return'), source.lastIndexOf('}')).replaceAll('in.fail_', 'input.fail_')
  const execute = new Function('input', 'readLeft', 'readRight', body)

  for (const row of readRows(`${path}.jsonl`)) {
    let trace = ''
    let actual
    function readLeft(fail) { trace += 'L'; if (fail) throw new Error('LeftFailure'); return 2 }
    function readRight(fail) { trace += 'R'; if (fail) throw new Error('RightFailure'); return 3 }

    try {
      const value = execute(row.input, readLeft, readRight)
      actual = { trace, value }
    } catch (error) {
      actual = { trace, error: error.message }
    }

    assert.deepEqual(actual, row.expected)
    checked += 1
  }
}

assert.equal(checked, 16)
console.log('4 original SHA / 16 strict-sloppy assertions; 16 actual ZX template bodies with call traces and failures PASS')
