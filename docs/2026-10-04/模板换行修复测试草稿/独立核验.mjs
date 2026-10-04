import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { globSync, readFileSync } from 'node:fs'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const sample = readRows('packages/test/src/data/template_newlines.jsonl')[0]
const indexed = new Map(globSync('packages/test/upstream/index/**/*.jsonl').flatMap(path => readRows(path).map(row => [row.path, row.sha256])))
const original = readFileSync(`${root}/${sample.path}`, 'utf8')
const hash = createHash('sha256').update(original).digest('hex')

function readRows(path) {
  return readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
}

assert.equal(hash, sample.sha256)
assert.equal(hash, indexed.get(sample.path))

for (const strict of [false, true]) {
  let calls = 0
  const harness = { sameValue(actual, expected) { calls += 1; assert.equal(actual, expected) } }

  runInNewContext(`${strict ? '"use strict";\n' : ''}${original}`, { assert: harness }, { timeout: 1000 })
  assert.equal(calls, 9)
}

for (const name of ['lf', 'cr', 'crlf', 'ls', 'ps']) {
  assert.deepEqual(readFileSync(`docs/2026-10-04/模板换行差异复核/${name}.zx`), readFileSync(`docs/2026-10-04/模板换行修复测试草稿/${name}.zx`))
}

const path = 'packages/test/tests/language/expressions/template_newlines/cases'
const source = readFileSync(`${path}.zx`, 'utf8')
const body = source.slice(source.indexOf('  switch'), source.lastIndexOf('}')).replace('switch (in)', 'switch (input)').replace('${in}', '${input}')
const execute = new Function('input', body)
const rows = readRows(`${path}.jsonl`)

assert.equal(rows.length, 14)
assert.ok(source.includes('`\r\n\n\r`'))
assert.ok(original.includes('`\r\n\n\r`'))

for (const row of rows) assert.equal(execute(row.input), row.expected.value)
console.log('Original SHA / 18 complete assertions; five probe sources byte-identical; 14 actual ZX expressions PASS')
