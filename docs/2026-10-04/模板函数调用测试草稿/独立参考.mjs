import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(resolve(root, path), 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
const samples = rows('packages/test/src/data/template_calls.jsonl')
let assertions = 0

for (const sample of samples) {
  const original = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(original).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + original.toString(), {
      assert: { sameValue(actual, expected) { assert.ok(Object.is(actual, expected)); assertions++ } },
    })
  }

  for (const mode of ['original', 'dynamic']) {
    const base = `packages/test/tests/language/expressions/template_calls/${sample.name}/${mode}`
    const source = read(base + '.zx')
    const expression = source.match(/return (.*)\n}/)[1]
    const helper_name = mode === 'original' ? 'constant' : 'identity'
    const helper = read(`packages/test/tests/language/expressions/template_calls/helpers/${helper_name}.zx`)
    const returned = helper.match(/return (.*)\n}/)[1].replace(/\bin\b/g, 'value')
    const fn = new Function('value', `return ${returned}`)
    const execute = new Function('fn', 'value', `return ${expression.replace(/\bin\b/g, 'value')}`)

    assert.equal(expression, sample.expression)

    for (const row of rows(base + '.jsonl')) {
      assert.equal(execute(fn, row.input), row.expected.value)
      assertions++
    }
  }
}

console.log(`PASS: 3 source hashes; 6 original strict/sloppy assertions; 15 actual ZX-body references; ${assertions} total assertions`)
