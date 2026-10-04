import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'

const path = 'packages/test/tests/language/expressions/template_delimiters/cases'
const source = readFileSync(`${path}.zx`, 'utf8')
const body = source.slice(source.indexOf('  switch'), source.lastIndexOf('}')).replaceAll('in.kind', 'input.kind').replaceAll('in.value', 'input.value')
const execute = new Function('input', body)
const rows = readFileSync(`${path}.jsonl`, 'utf8').trim().split('\n').map(line => JSON.parse(line))

assert.equal(rows.length, 10)
assert.ok(source.includes('/* } ` ${ */'))
assert.ok(source.includes('// } ` ${\n'))

for (const row of rows) assert.equal(execute(row.input), row.expected.value)
console.log('10 actual ZX expression paths independently executed with quoted/commented delimiter contents preserved: PASS')
