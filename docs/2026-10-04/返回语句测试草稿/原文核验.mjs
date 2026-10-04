import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')

for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))
  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
  vm.runInNewContext(harness + '\n' + raw.toString(), Object.create(null), { timeout: 1000 })
}

for (const [name, ending] of [['lf', '\n'], ['cr', '\r'], ['crlf', '\r\n']]) {
  const path = `packages/test/tests/language/statements/return/newline/${name}`
  const source = readFileSync(path + '.zx', 'utf8')
  const row = JSON.parse(readFileSync(path + '.jsonl', 'utf8'))
  assert.ok(source.includes(`return${ending}1;`))
  assert.equal(new Function(`return${ending}1;`)(), undefined)
  assert.equal(row.expected.value, 1)
}

for (const ending of ['', '\n', '\r', '\r\n']) assert.equal(new Function(`return${ending};`)(), undefined)
for (const ending of ['\u2028', '\u2029']) assert.equal(new Function(`return${ending}1;`)(), undefined)
assert.equal(rows.length, 5)
console.log('5 complete original hashes/bodies passed; 3 exact ASCII newline fixtures retain JS undefined versus declared ZX value 1 difference; empty-return and Unicode JS controls verified')
