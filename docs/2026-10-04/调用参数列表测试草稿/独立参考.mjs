import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script, runInNewContext } from 'node:vm'

const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(path, 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
const harness = ['sta.js', 'assert.js'].map(name => read(resolve(upstream, 'harness', name))).join('\n')
let runs = 0
let negative = 0

for (const sample of rows('packages/test/src/data/call_arguments.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))
  const source = bytes.toString()
  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of source.includes('flags: [noStrict]') ? [''] : ['', '"use strict";\n']) {
    if (source.includes('negative:')) {
      assert.throws(() => new Script(prefix + source), SyntaxError)
      negative++
    } else {
      runInNewContext(prefix + harness + '\n' + source, {}, { timeout: 1000 })
      runs++
    }
  }
}

const base = 'packages/test/tests/language/expressions/call_arguments'
for (const row of rows(base + '/syntax.jsonl')) {
  const expression = row.source.match(/return (.*)\n}/)[1]
  if (row.diagnostic) {
    assert.throws(() => new Script(expression), SyntaxError)
    assert.equal(row.source.slice(...row.span), ',')
  } else new Script(expression)
}

const expressions = [...read(base + '/cases.zx').matchAll(/case (\d+):\n      return ([\s\S]*?)\n(?=    case|    default)/g)].map(match => match[2])
const helper = read(base + '/increment.zx').match(/return (.*)\n}/)[1].replace(/\bin\b/g, 'value')
const increment = new Function('value', `return ${helper}`)

for (const row of rows(base + '/cases.jsonl')) {
  assert.equal(new Function('input', 'increment', `return ${expressions[row.input.kind].replace(/\bin\b/g, 'input')}`)(row.input, increment), row.expected.value)
}
assert.equal(runs, 16)
assert.equal(negative, 2)
console.log('PASS: 10 original SHA256; 16 full executions and 2 parse negatives respecting noStrict; 8 syntax controls and 8 actual ZX/helper runtime references')
