import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script, runInNewContext } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(resolve(root, path), 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let runs = 0
let rejected = 0

for (const sample of rows('packages/test/src/data/property_lookup.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    if (sample.name === 'non-identifier-name') {
      assert.throws(() => new Script(prefix + bytes.toString()), SyntaxError)
      rejected++
    } else {
      runInNewContext(prefix + bytes.toString(), { Test262Error: class extends Error {} })
      runs++
    }
  }
}

const base = 'packages/test/tests/language/expressions/property_lookup'
const source = read(base + '/own_field.zx')
const body = source.slice(source.indexOf('Output {') + 8, source.lastIndexOf('}'))

assert.equal(new Function(body)(), rows(base + '/own_field.jsonl')[0].expected.value)

const [invalid, valid] = rows(base + '/syntax.jsonl')
assert.throws(() => new Script(invalid.source.match(/return (.*)\n}/)[1]), SyntaxError)
assert.equal(invalid.source.slice(...invalid.span), '""')
assert.equal(new Function('input', `return ${valid.source.match(/return (.*)\n}/)[1].replace('in.', 'input.')}`)({ shape: 'cube' }), 'cube')
assert.equal(runs, 6)
assert.equal(rejected, 2)
console.log('PASS: 4 hashes; 6 complete original executions; 2 original SyntaxErrors; actual ZX body and syntax controls')
