import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { Script } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readRows('packages/test/upstream/reviews/language/statements/block_syntax.jsonl')
const frontend = readRows('packages/test/tests/language/statements/block_syntax/cases.jsonl')
const indexed = new Map()

function readRows(path) {
  return readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
}

function readIndex(path) {
  for (const item of readdirSync(path, { withFileTypes: true })) {
    const file = join(path, item.name)

    if (item.isDirectory()) readIndex(file)
    else for (const row of readRows(file)) indexed.set(row.path, row.sha256)
  }
}

readIndex('packages/test/upstream/index')
assert.equal(rows.length, 11)

for (const row of rows) {
  const source = readFileSync(join(root, row.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')

  assert.equal(hash, row.sha256)
  assert.equal(hash, indexed.get(row.path))
  assert.match(source, /negative:\s+phase: parse\s+type: SyntaxError/)
  assert.doesNotMatch(source, /onlyStrict|noStrict|flags: \[module/)
  assert.throws(() => new Script(source), SyntaxError)
  assert.throws(() => new Script(`"use strict";\n${source}`), SyntaxError)

  if (row.status === 'adapted') {
    const test_case = frontend.find(item => item.id === row.cases[0])
    const body = source.slice(source.indexOf('if{}')).trim()

    assert.ok(test_case.source.includes(body))
    assert.equal(test_case.source.slice(...test_case.span), '{')
    assert.deepEqual(row.diagnostics[0].span, test_case.span)
  } else assert.deepEqual(row.cases, [])

  console.log(`${row.path}: SHA + strict/sloppy SyntaxError PASS`)
}

for (const row of frontend) {
  const body = row.source.slice(row.source.indexOf('  if'))
  const program = `function check(input) {\n${body.replaceAll('(in)', '(input)')}`

  assert.throws(() => new Script(program), SyntaxError)
  assert.equal(row.source.slice(...row.span), row.id.includes('semicolon_') ? ';' : '{')
}

console.log('11 originals / 22 parse checks; 5 adapted body parse checks and diagnostic spans PASS')
