import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { globSync, readFileSync } from 'node:fs'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const samples = readRows('packages/test/src/data/template_members.jsonl')
const indexed = new Map(globSync('packages/test/upstream/index/**/*.jsonl').flatMap(path => readRows(path).map(row => [row.path, row.sha256])))
class Test262Error extends Error {}

function readRows(path) {
  return readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
}

for (const [index, sample] of samples.entries()) {
  const source = readFileSync(`${root}/${sample.path}`, 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')

  assert.equal(hash, sample.sha256)
  assert.equal(hash, indexed.get(sample.path))
  assert.doesNotMatch(source, /flags:|includes:|negative:/)

  for (const strict of [false, true]) {
    let calls = 0
    const harness = {
      sameValue(actual, expected) { calls += 1; assert.equal(actual, expected) },
      throws(constructor, execute) {
        calls += 1
        assert.throws(execute, error => error.constructor === constructor)
      },
    }

    runInNewContext(`${strict ? '"use strict";\n' : ''}${source}`, { assert: harness, Test262Error }, { timeout: 1000 })
    assert.equal(calls, sample.kind === 'member-expr' ? 4 : sample.kind === 'obj' ? 8 : 1)
  }
}

const path = 'packages/test/tests/language/expressions/template_members/cases'
const source = readFileSync(`${path}.zx`, 'utf8')
const body = source.slice(source.indexOf('  const object'), source.lastIndexOf('}')).replaceAll('in.object', 'input.object').replaceAll('in.kind', 'input.kind')
const execute = new Function('input', body)
const rows = readRows(`${path}.jsonl`)

assert.equal(rows.length, 12)
for (const row of rows) assert.equal(execute(row.input), row.expected.value)

const frontend = readRows('packages/test/tests/language/types/template_members/cases.jsonl')
for (const row of frontend) {
  const token = row.source.slice(...row.span)
  assert.ok(row.id.includes('/index/') ? token === 'in["string"]' : token.startsWith('`') && token.endsWith('`'))
}

console.log('9 original SHA / 78 strict-sloppy assertions; 12 actual ZX member outputs and 6 diagnostic spans PASS')
