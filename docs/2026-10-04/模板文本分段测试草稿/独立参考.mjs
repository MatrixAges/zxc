import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(resolve(root, path), 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let count = 0

for (const sample of rows('packages/test/src/data/template_segments.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + bytes.toString(), {
      assert: { sameValue(actual, expected) { assert.ok(Object.is(actual, expected)); count++ } },
    })
  }
}

const source = read('packages/test/tests/language/expressions/template_segments/cases.zx')
const expressions = [...source.matchAll(/case (\d+):\n      return (.*)/g)].map(match => match[2])
const seen = new Set()

for (const row of rows('packages/test/tests/language/expressions/template_segments/cases.jsonl')) {
  const expression = expressions[row.input.kind]
  const identity = JSON.stringify([expression, row.input.left, row.input.right])

  assert.ok(!seen.has(identity), 'duplicate expression/input')
  seen.add(identity)
  assert.equal(new Function('input', `return ${expression.replaceAll('in.', 'input.')}`)(row.input), row.expected.value)
}

assert.equal(count, 60)
assert.equal(seen.size, 23)
console.log('PASS: 5 SHA hashes; 60 original strict/sloppy assertions; 23 unique actual ZX expression/input references')
