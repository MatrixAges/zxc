import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { runInNewContext } from 'node:vm'

const root = process.cwd()
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const read = path => readFileSync(resolve(root, path), 'utf8')
const rows = path => read(path).trim().split('\n').map(line => JSON.parse(line))
let runs = 0

for (const sample of rows('packages/test/src/data/property_remaining.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + bytes.toString(), { Test262Error: class extends Error {} })
    runs++
  }
}

const base = 'packages/test/tests/language/expressions/property_whitespace'
const expressions = [...read(base + '/cases.zx').matchAll(/case (\d+):\n      return ([\s\S]*?)\n(?=    case|    default)/g)].map(match => match[2])

for (const row of rows(base + '/cases.jsonl')) {
  assert.equal(new Function('input', `return ${expressions[row.input.kind].replace(/\bin\b/g, 'input')}`)(row.input), row.expected.value)
}

for (const row of rows(base + '/unicode.jsonl')) {
  const expression = row.source.match(/return ([\s\S]*?)\n}/)[1].replace(/\bin\b/g, 'input')

  assert.equal(new Function('input', `return ${expression}`)({ value: 9 }), 9)
  assert.ok(Buffer.from(row.source)[row.span[0]] >= 128)
}

const prefix = 'test/language/expressions/property-accessors/'
const expected = readdirSync(resolve(upstream, prefix)).filter(name => name.endsWith('.js')).map(name => prefix + name).sort()
const dir = 'packages/test/upstream/reviews'
const reviews = readdirSync(resolve(root, dir), { recursive: true }).filter(name => name.endsWith('.jsonl')).flatMap(name => rows(dir + '/' + name)).filter(row => row.path.startsWith(prefix))

assert.deepEqual(reviews.map(row => row.path).sort(), expected)

for (const row of reviews) assert.equal(createHash('sha256').update(readFileSync(resolve(upstream, row.path))).digest('hex'), row.sha256)

assert.equal(runs, 24)
assert.equal(expected.length, 21)
console.log(JSON.stringify({ original_runs: runs, runtime_references: 12, js_valid_unicode: 4, reviewed_directory: expected.length, adapted: reviews.filter(row => row.status === 'adapted').length, excluded: reviews.filter(row => row.status === 'excluded').length }, null, 2))
