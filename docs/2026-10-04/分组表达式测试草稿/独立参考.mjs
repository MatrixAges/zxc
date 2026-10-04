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
let values = 0

for (const sample of rows('packages/test/src/data/grouping_values.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))
  const text = bytes.toString()

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of text.includes('flags: [noStrict]') ? [''] : ['', '"use strict";\n']) {
    runInNewContext(prefix + text, { Test262Error: class extends Error {} })
    runs++
  }
}

const base = 'packages/test/tests/language/expressions/grouping_values'

for (const name of readdirSync(resolve(root, base), { recursive: true }).filter(name => name.endsWith('.zx'))) {
  const source = read(base + '/' + name)
  const branches = [...source.matchAll(/case (\d+):\n      return ([\s\S]*?)\n(?=    case|    default)/g)]

  for (const row of rows(base + '/' + name.replace(/\.zx$/, '.jsonl'))) {
    const expression = branches.length ? branches[row.input][2] : source.match(/return ([\s\S]*?)\n}/)[1].replace(/\bin\b/g, 'value')

    assert.equal(new Function('value', `return ${expression}`)(row.input), row.expected.value)
    values++
  }
}

for (const row of rows(base + '/unicode.jsonl')) {
  const expression = row.source.match(/return ([\s\S]*?)\n}/)[1]

  assert.equal(runInNewContext(expression), 1)
  assert.ok(Buffer.from(row.source)[row.span[0]] >= 128)
}

assert.equal(runs, 16)
assert.equal(values, 22)
console.log('PASS: 9 original hashes; 16 complete original runs respecting noStrict; 22 actual ZX expression references; 4 JS-valid Unicode whitespace controls')
