import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { join } from 'node:path'
import { createContext, Script } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const base = 'docs/2026-10-04/选择重复声明测试草稿'
const review_path = 'packages/test/upstream/reviews/language/statements/switch_redeclarations.jsonl'
const rows = readRows(review_path)
const facts = JSON.parse(readFileSync(`${base}/逐项证据.json`, 'utf8'))
const indexed = new Map()
let negative_count = 0
let positive_count = 0

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
assert.equal(rows.length, 64)
assert.equal(new Set(facts.map(row => `${row.left}/${row.right}`)).size, 64)

for (const [index, row] of rows.entries()) {
  const source = readFileSync(join(root, row.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')

  assert.equal(hash, row.sha256)
  assert.equal(hash, indexed.get(row.path))
  assert.equal(facts[index].path, row.path)
  assert.equal(row.status, 'excluded')
  assert.deepEqual(row.cases, [])

  const modes = facts[index].flags.includes('onlyStrict') ? ['strict'] : ['sloppy', 'strict']

  for (const mode of modes) {
    const program = mode === 'strict' ? `"use strict";\n${source}` : source

    if (facts[index].negative) {
      assert.match(source, /negative:\s+phase: parse\s+type: SyntaxError/)
      assert.throws(() => new Script(program), SyntaxError)
      negative_count += 1
    } else {
      const context = createContext({})
      new Script(program).runInContext(context, { timeout: 1000 })
      assert.equal(new Script('f').runInContext(context, { timeout: 1000 }), undefined)
      positive_count += 1
    }
  }

  console.log(`${row.path}: SHA + original ${facts[index].negative ? 'parse SyntaxError' : 'normal execution'} PASS`)
}

assert.equal(negative_count, 125)
assert.equal(positive_count, 2)
assert.equal(readFileSync(review_path, 'utf8'), readFileSync(`${base}/审阅草稿.jsonl`, 'utf8'))

for (const name of ['case_default', 'default_case']) {
  const path = `packages/test/tests/language/statements/switch/scope/${name}`
  const source = readFileSync(`${path}.zx`, 'utf8')
  const body = source.slice(source.indexOf('  switch'))
  let branches = 0
  const modeled = body.replace('switch (in)', 'switch (input)').replace(/    (case 1:|default:)/g, label => {
    branches += 1

    return `${branches === 1 ? '' : '    }\n'}${label} {`
  }).replace(/\n  }\n}\n$/, '\n    }\n  }\n')
  const execute = new Function('input', modeled)

  for (const row of readRows(`${path}.jsonl`)) assert.equal(execute(row.input), row.expected.value)
}

const frontend = readRows('packages/test/tests/language/statements/switch_redeclarations/cases.jsonl')
for (const row of frontend.filter(row => row.diagnostic)) assert.equal(row.source.slice(...row.span), 'f')
console.log('63 negative files / 125 parse runs + 1 positive file / 2 executions; 4 modeled ZX outputs + 2 diagnostic spans PASS')
