import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { createContext, Script } from 'node:vm'

const root = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const base = 'docs/2026-10-04/裸块语义测试草稿'
const rows = readRows('packages/test/upstream/reviews/language/statements/bare_blocks.jsonl')
const indexed = new Map()
const results = []
const helper = readFileSync(join(root, 'harness/tcoHelper.js'), 'utf8')
const bootstrap = `
class Test262Error extends Error {}
const assert = {
  sameValue(actual, expected) {
    if (!Object.is(actual, expected)) throw new Test262Error('sameValue');
    record('sameValue');
  },
  throws(constructor, execute) {
    let thrown = false;
    try { execute(); } catch (error) {
      thrown = true;
      if (error.constructor !== constructor) throw new Test262Error('wrong error type');
    }
    if (!thrown) throw new Test262Error('missing exception');
    record('throws');
  }
};`

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
assert.equal(rows.length, 10)
assert.match(helper, /var \$MAX_ITERATIONS = 100000;/)

for (const row of rows) {
  const source = readFileSync(join(root, row.path), 'utf8')
  const hash = createHash('sha256').update(source).digest('hex')
  const tail_call = source.includes('features: [tail-call-optimization]')
  const negative = source.includes('negative:')
  const modes = source.includes('onlyStrict') ? ['strict'] : ['sloppy', 'strict']

  assert.equal(hash, row.sha256)
  assert.equal(hash, indexed.get(row.path))
  assert.equal(row.status, 'excluded')
  assert.deepEqual(row.cases, [])

  for (const mode of modes) {
    const program = `${mode === 'strict' ? '"use strict";\n' : ''}${tail_call ? helper : ''}\n${source}`
    const calls = []
    const context = createContext({ record(value) { calls.push(value) } })
    let outcome = 'pass'
    new Script(bootstrap).runInContext(context)

    if (negative) {
      assert.match(source, /negative:\s+phase: parse\s+type: SyntaxError/)
      assert.throws(() => new Script(program), SyntaxError)
    } else {
      try {
        new Script(program).runInContext(context, { timeout: 1000 })
      } catch (error) {
        if (!tail_call || error.name !== 'RangeError' || !/call stack/i.test(error.message)) throw error
        outcome = 'reference_stack_overflow_not_pass'
      }

      if (!tail_call) assert.equal(calls.length, (source.match(/assert\.(sameValue|throws)\(/g) ?? []).length)
    }

    results.push({ path: row.path, mode, negative, outcome, assertions: calls.length })
    console.log(`${row.path} ${mode}: ${outcome}`)
  }
}

const frontend = readRows('packages/test/tests/language/statements/bare_blocks/cases.jsonl')
for (const row of frontend) assert.equal(row.source.slice(...row.span), '{')
writeFileSync(`${base}/参考执行结果.json`, `${JSON.stringify({ helper_sha256: createHash('sha256').update(helper).digest('hex'), results }, null, 2)}\n`)
console.log('10 original SHA verified; parse/runtime results retained separately; 4 ZX spans checked')
