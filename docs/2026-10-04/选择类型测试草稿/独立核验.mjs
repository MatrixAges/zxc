import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'

const state = { First: 0, Second: 1, Third: 2 }
let count = 0
for (const name of ['integer', 'string', 'boolean', 'enumeration']) {
  const path = `packages/test/tests/language/statements/switch/scalars/${name}`
  const source = readFileSync(path + '.zx', 'utf8')
  const body = source.match(/export default function \(in: Input\): Output \{([\s\S]*)\}\s*$/)[1].replace(/\bin\b/g, 'input')
  const execute = new Function('input', 'State', body)
  const rows = readFileSync(path + '.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
  for (const row of rows) { assert.equal(execute(row.input, state), row.expected.value); count++ }
}

const frontend = readFileSync('packages/test/tests/language/statements/switch_scalars/cases.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of frontend.filter(row => row.id.includes('/duplicate/'))) {
  const labels = [...row.source.matchAll(/case (.*): return/g)].map(match => match[1])
  assert.equal(labels.length, 2)
  const left = new Function('State', `return ${labels[0]};`)(state)
  const right = new Function('State', `return ${labels[1]};`)(state)
  assert.equal(left === right, true)
}
assert.equal(count, 16)
assert.equal(frontend.length, 11)
console.log('16 runtime outputs independently executed; 7 duplicate label value pairs equal; 4 exhaustiveness rows retained as ZX static rules')
