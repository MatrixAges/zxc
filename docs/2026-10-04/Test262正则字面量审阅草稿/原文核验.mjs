import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const capabilities = [
  ['modifiers_add', () => new RegExp('(?i:a)').test('A')],
  ['modifiers_remove', () => !new RegExp('(?-i:a)', 'i').test('A')],
  ['modifiers_both', () => new RegExp('(?i-m:a)', 'm').test('A')],
  ['named', () => new RegExp('(?<x>a)\\k<x>').exec('aa').groups.x === 'a'],
  ['lookbehind', () => new RegExp('(?<=a)b').test('ab')],
  ['unicode', () => new RegExp('\\u{1F600}', 'u').test('😀')],
  ['sticky', () => { const value = new RegExp('a', 'y'); value.lastIndex = 1; return value.test('ba') && value.lastIndex === 2 }],
].map(([name, check]) => ({ name, passed: check() }))

writeFileSync(new URL('./参考引擎能力.json', import.meta.url), JSON.stringify({ node: process.version, capabilities }, null, 2) + '\n')
assert.ok(capabilities.every(row => row.passed))
const results = []

try {
  for (const row of rows) {
    const raw = readFileSync(resolve(base, row.path))
    assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
    assert.equal(raw.toString().split('---*/')[1].trim(), row.body)
    const harness = ['sta.js', 'assert.js', ...row.includes].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')

    for (const strict of [false, true]) {
      const source = (strict ? '"use strict";\n' : '') + harness + '\n' + raw.toString()
      const result = { path: row.path, strict, check: row.negative ? 'parse-only rejection' : 'original execution', passed: false }

      try {
        if (row.negative) assert.throws(() => new vm.Script(source), SyntaxError)
        else vm.runInNewContext(source, Object.create(null), { timeout: 30000 })
        result.passed = true
      } catch (error) {
        result.error = String(error)
        console.error(row.path, strict, result.error)
      }

      results.push(result)
    }
  }
} finally {
  writeFileSync(new URL('./原文结果.json', import.meta.url), JSON.stringify(results, null, 2) + '\n')
}

assert.equal(results.length, 472)
assert.equal(results.filter(row => row.check === 'parse-only rejection').length, 370)
assert.ok(results.every(row => row.passed))
console.log('236 original hashes and bodies verified; 370 parse-only rejections and 102 actual original executions passed after 7 capability checks')
