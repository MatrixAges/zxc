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

for (const sample of rows('packages/test/src/data/call_basics.jsonl')) {
  const bytes = readFileSync(resolve(upstream, sample.path))

  assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

  for (const prefix of ['', '"use strict";\n']) {
    runInNewContext(prefix + bytes.toString(), { Test262Error: class extends Error {} })
    runs++
  }
}

const base = 'packages/test/tests/language/expressions/call_whitespace'
const expressions = [...read(base + '/cases.zx').matchAll(/case (\d+):\n      return ([\s\S]*?)\n(?=    case|    default)/g)].map(match => match[2])
const helper = read(base + '/increment.zx').match(/return (.*)\n}/)[1].replace(/\bin\b/g, 'value')
const increment = new Function('value', `return ${helper}`)

for (const row of rows(base + '/cases.jsonl')) {
  assert.equal(new Function('input', 'increment', `return ${expressions[row.input.kind].replace(/\bin\b/g, 'input')}`)(row.input, increment), row.expected.value)
}

for (const row of rows(base + '/unicode.jsonl')) {
  const expression = row.source.match(/return ([\s\S]*?)\n}/)[1].replace(/\bin\b/g, 'input')

  new Script(expression)
  assert.ok(Buffer.from(row.source)[row.span[0]] >= 128)
}

assert.equal(runs, 24)
console.log('PASS: 12 original hashes and 24 full strict/sloppy executions; 12 actual ZX call/helper references; 4 JS-valid Unicode syntax controls')
