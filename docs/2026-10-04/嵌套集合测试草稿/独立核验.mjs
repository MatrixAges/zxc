import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'

function boundArray(items) {
  const values = items.map(item => Array.isArray(item) ? boundArray(item) : item)

  return new Proxy(values, { get(target, key, receiver) {
    if (typeof key === 'string' && /^(0|[1-9][0-9]*)$/.test(key) && Number(key) >= target.length) throw new RangeError('IndexOutOfBounds')

    return Reflect.get(target, key, receiver)
  } })
}

let checked = 0
let errors = 0

for (const name of ['nested_map', 'nested_initial', 'restored_row']) {
  const path = `packages/test/tests/built_ins/list/nested/${name}`
  const source = readFileSync(`${path}.zx`, 'utf8')
  const body = source.slice(source.indexOf('  return'), source.lastIndexOf('}')).replace(/\bin\b/g, 'input')
  const execute = new Function('input', body)
  const rows = readFileSync(`${path}.jsonl`, 'utf8').trim().split('\n').map(line => JSON.parse(line))

  assert.equal(rows.length, 7)

  for (const row of rows) {
    const input = boundArray(row.input)

    if ('error' in row.expected) {
      assert.equal(row.expected.error, 'IndexOutOfBounds')
      assert.throws(() => execute(input), { name: 'RangeError', message: 'IndexOutOfBounds' })
      errors += 1
    } else assert.deepEqual(execute(input), row.expected.value)

    checked += 1
  }
}

assert.equal(checked, 21)
assert.equal(errors, 6)
console.log('21 actual ZX expression bodies checked with explicit bounded indexing: 15 values + 6 errors PASS')
console.log('Bounded array proxy models ZX indexing; this is not a claim of ordinary JS array bounds semantics')
