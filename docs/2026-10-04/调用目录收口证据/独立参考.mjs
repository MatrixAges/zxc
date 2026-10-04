import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync, mkdtempSync, writeFileSync, rmSync } from 'node:fs'
import { resolve, join } from 'node:path'
import { tmpdir } from 'node:os'
import { createContext, runInContext, runInNewContext } from 'node:vm'
import { spawnSync } from 'node:child_process'

const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const jsc = '/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Helpers/jsc'
const rows = path => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line))
const hash = data => createHash('sha256').update(data).digest('hex')
const samples = rows('packages/test/src/data/call_remaining.jsonl')
const prefix = 'test/language/expressions/call/'
const reviews = []

for (const name of readdirSync('packages/test/upstream/reviews/language/expressions')) {
  if (!name.endsWith('.jsonl')) continue
  reviews.push(...rows('packages/test/upstream/reviews/language/expressions/' + name).filter(row => row.path.startsWith(prefix)))
}
assert.equal(reviews.length, 92)
assert.equal(new Set(reviews.map(row => row.path)).size, 92)
assert.deepEqual(reviews.map(row => row.path).sort(), readdirSync(resolve(upstream, prefix)).map(name => prefix + name).sort())
for (const row of reviews) assert.equal(hash(readFileSync(resolve(upstream, row.path))), row.sha256)

const temporary = mkdtempSync(join(tmpdir(), 'zxc-call-tail-'))
const helpers = {}
let node_runs = 0
let jsc_runs = 0
const reference_limits = []

try {
  for (const sample of samples) {
    const bytes = readFileSync(resolve(upstream, sample.path))
    const source = bytes.toString()
    const includes = source.match(/includes: \[([^\]]+)\]/)?.[1].split(',').map(name => name.trim()) ?? []
    const harness = ['sta.js', 'assert.js', ...includes].map(name => {
      const data = readFileSync(resolve(upstream, 'harness', name))
      helpers[name] = hash(data)
      if (name === 'tcoHelper.js') assert.match(data.toString(), /var \$MAX_ITERATIONS = 100000;/)
      return data.toString()
    }).join('\n')
    const modes = source.includes('flags: [onlyStrict]') ? ['"use strict";\n'] : source.includes('flags: [noStrict]') ? [''] : ['', '"use strict";\n']
    assert.equal(hash(bytes), sample.sha256)

    for (const mode of modes) {
      const script = mode + harness + '\n' + source
      if (includes.includes('tcoHelper.js') || sample.path.includes('/eval-spread')) {
        const path = join(temporary, 'case.js')
        writeFileSync(path, script + '\nprint("COMPLETE");\n')
        const result = spawnSync(jsc, [path], { encoding: 'utf8', timeout: 10000 })
        assert.equal(result.error, undefined)
        if (result.status !== 0 && includes.includes('tcoHelper.js') && /RangeError: Maximum call stack size exceeded/.test(result.stdout + result.stderr)) {
          reference_limits.push(sample.path)
          console.log('REFERENCE_LIMIT original-depth stack overflow:', sample.path)
        } else {
          assert.equal(result.status, 0, result.stdout + result.stderr)
          assert.equal(result.stdout.trim(), 'COMPLETE')
          jsc_runs++
        }
      } else {
        runInNewContext(script, {
          $262: {
            createRealm() {
              const context = createContext({})
              return { global: runInContext('globalThis', context) }
            },
          },
        }, { timeout: 1000 })
        node_runs++
      }
    }
    if (!reference_limits.includes(sample.path)) console.log('PASS', sample.path)
  }
} finally {
  rmSync(temporary, { recursive: true, force: true })
}
assert.equal(node_runs, 33)
assert.equal(jsc_runs + reference_limits.length, 14)
console.log('HARNESS_SHA256', JSON.stringify(helpers))
console.log('JSC_BINARY', jsc, hash(readFileSync(jsc)))
console.log(JSON.stringify({ reviewed_paths: 92, original_files: 29, node_pass: node_runs, jsc_pass: jsc_runs, reference_limits, original_tail_depth: 100000 }))
