import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { resolve } from 'node:path'
import vm from 'node:vm'

const base = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const rows = readFileSync(new URL('./原文证据.jsonl', import.meta.url), 'utf8').trim().split('\n').map(JSON.parse)
const harness = ['sta.js', 'assert.js'].map(name => readFileSync(resolve(base, 'harness', name), 'utf8')).join('\n')

assert.equal(vm.runInNewContext('#! valid script\n1'), 1)
const guard = new vm.SourceTextModule('#! valid module\nexport const value = 1')

await guard.link(() => { throw new Error('unexpected import') })
await guard.evaluate()
assert.equal(guard.namespace.value, 1)

const results = []

for (const row of rows) {
  const raw = readFileSync(resolve(base, row.path))

  assert.equal(createHash('sha256').update(raw).digest('hex'), row.sha256)
  assert.equal(raw.toString(), row.source)

  const modes = row.flags.includes('module') ? ['module'] : row.flags.includes('raw') ? ['raw'] : ['ordinary', 'strict']

  for (const mode of modes) {
    const source = mode === 'raw' || mode === 'module' ? row.source : (mode === 'strict' ? '"use strict";\n' : '') + harness + '\n' + row.source

    if (mode === 'module') {
      const module = new vm.SourceTextModule(source)

      await module.link(() => { throw new Error('unexpected import') })
      await module.evaluate()
    } else if (row.negative) assert.throws(() => new vm.Script(source), SyntaxError)
    else vm.runInNewContext(source, Object.create(null), { timeout: 30000 })

    results.push({ path: row.path, mode, check: row.negative ? 'parse-only rejection' : 'original execution', passed: true })
  }
}

writeFileSync(new URL('./原文结果.json', import.meta.url), JSON.stringify({ node: process.version, capabilities: ['script hashbang', 'module hashbang'], results }, null, 2) + '\n')
console.log(JSON.stringify({ files: rows.length, executions: results.filter(row => row.check === 'original execution').length, parse_only: results.filter(row => row.check === 'parse-only rejection').length, modules: results.filter(row => row.mode === 'module').length }))
