import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { Script, runInNewContext } from 'node:vm'

const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = path => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
const samples = rows('packages/test/src/data/optional_chain_remaining.jsonl')
const prefix = 'test/language/expressions/optional-chaining/'
const all = [...samples, ...rows('packages/test/src/data/optional_chain_boundary.jsonl')]

assert.equal(new Set(all.map(row => row.path)).size, 38)
assert.deepEqual(all.map(row => row.path).sort(), readdirSync(resolve(upstream, prefix)).filter(name => name.endsWith('.js')).map(name => prefix + name).sort())

let events = []
const onRejection = reason => events.push(reason)
process.on('unhandledRejection', onRejection)
const counts = { runtime: 0, async: 0, negative: 0, expected_rejections: 0 }

try {
  for (const sample of samples) {
    const bytes = readFileSync(resolve(upstream, sample.path))
    const source = bytes.toString()
    const is_async = source.includes('flags: [async]')
    const includes = source.match(/includes: \[([^\]]+)\]/)?.[1].split(',').map(name => name.trim()) ?? []
    const harness = ['sta.js', 'assert.js', ...includes].map(name => readFileSync(resolve(upstream, 'harness', name), 'utf8')).join('\n')

    assert.equal(createHash('sha256').update(bytes).digest('hex'), sample.sha256)

    for (const mode of ['', '"use strict";\n']) {
      events = []

      if (source.includes('negative:')) {
        assert.throws(() => new Script(mode + source), SyntaxError)
        counts.negative++
        continue
      }

      if (is_async) {
        let calls = 0
        let timer

        try {
          await new Promise((resolveDone, rejectDone) => {
            timer = setTimeout(() => rejectDone(new Error('missing $DONE: ' + sample.path)), 3000)
            runInNewContext(mode + harness + '\n' + source, {
              $DONE(error) {
                calls++
                if (error !== undefined) rejectDone(error)
                else resolveDone()
              },
            }, { timeout: 1000 })
          })
          await new Promise(resolveTurn => setImmediate(resolveTurn))
          assert.equal(calls, 1)
        } finally {
          clearTimeout(timer)
        }
        counts.async++
      } else {
        runInNewContext(mode + harness + '\n' + source, {}, { timeout: 1000 })
        counts.runtime++
      }

      await new Promise(resolveTurn => setImmediate(resolveTurn))
      const expected = sample.path.endsWith('/member-expression-async-identifier.js') ? [undefined] : []
      assert.deepEqual(events, expected, sample.path)
      counts.expected_rejections += events.length
    }
    console.log('PASS', sample.path)
  }
} finally {
  process.off('unhandledRejection', onRejection)
}

for (const row of rows('packages/test/tests/language/expressions/optional_chain_remaining/cases.jsonl')) {
  const expression = row.source.match(/return (.*)\n}/)[1].replace(/\bin\b/g, 'input')
  new Script(expression)
  assert.equal(Buffer.from(row.source).subarray(...row.span).toString(), '.')
}
assert.deepEqual(counts, { runtime: 36, async: 12, negative: 2, expected_rejections: 2 })
console.log('PASS: 25 hashes; directory 38/38 unique; 8 JS-valid long-chain controls;', JSON.stringify(counts))
