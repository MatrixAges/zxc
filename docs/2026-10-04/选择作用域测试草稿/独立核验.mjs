import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'

let count = 0
for (const name of ['separate_bindings', 'outer_binding']) {
  const path = `packages/test/tests/language/statements/switch/scope/${name}`
  const source = readFileSync(path + '.zx', 'utf8')
  const body = source.match(/export default function \(in: Input\): Output \{([\s\S]*)\}\s*$/)[1].replace(/\bin\b/g, 'input')
  const scoped = body.replace('case true:', 'case true: {').replace('case false:', '} case false: {').replace(/\n  }\s*$/, '\n    }\n  }\n')
  const execute = new Function('input', scoped)
  const rows = readFileSync(path + '.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
  for (const row of rows) { assert.equal(execute(row.input), row.expected.value); count++ }
}
const cases = readFileSync('packages/test/tests/language/statements/switch_scope/cases.jsonl', 'utf8').trim().split('\n').map(JSON.parse)
for (const row of cases.filter(row => row.span)) assert.equal(row.source.slice(...row.span), 'local')
assert.equal(count, 4)
assert.equal(cases.filter(row => row.diagnostic === 'name').length, 4)
console.log('4 runtime outputs verified using explicit per-case JS blocks; 4 diagnostic name spans verified; no claim of raw JS CaseBlock equivalence')
