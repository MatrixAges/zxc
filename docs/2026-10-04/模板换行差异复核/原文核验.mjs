import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { globSync, readFileSync, writeFileSync } from 'node:fs'
import { runInNewContext } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const path = 'test/language/expressions/template-literal/tv-line-terminator-sequence.js'
const base = 'docs/2026-10-04/模板换行差异复核'
const source = readFileSync(`${root}/${path}`, 'utf8')
const hash = createHash('sha256').update(source).digest('hex')
const rows = globSync('packages/test/upstream/index/**/*.jsonl').flatMap(file => readFileSync(file, 'utf8').trim().split('\n').map(line => JSON.parse(line)))

assert.equal(hash, rows.find(row => row.path === path).sha256)
assert.doesNotMatch(source, /flags:|includes:|negative:/)

for (const strict of [false, true]) {
  let calls = 0
  const harness = { sameValue(actual, expected) { calls += 1; assert.equal(actual, expected) } }

  runInNewContext(`${strict ? '"use strict";\n' : ''}${source}`, { assert: harness }, { timeout: 1000 })
  assert.equal(calls, 9)
}

const values = ['lf', 'cr', 'crlf', 'ls', 'ps'].map(name => {
  const zx = readFileSync(`${base}/${name}.zx`, 'utf8')
  const expression = zx.slice(zx.indexOf('`'), zx.lastIndexOf('`') + 1)
  const value = new Function(`return ${expression}`)()

  return { name, expected_js_hex: Buffer.from(value, 'utf8').toString('hex') }
})

writeFileSync(`${base}/JS参考值.json`, `${JSON.stringify({ path, sha256: hash, original_assertions: 18, values }, null, 2)}\n`)
console.log('Original byte-preserved source SHA + 18 assertions PASS')
console.log(JSON.stringify(values))
