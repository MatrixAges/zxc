import type { Instruction } from './model.ts'

import assert from 'node:assert/strict'
import { performance } from 'node:perf_hooks'
import plan from './plan.ts'

const size = Number(process.argv[2])
const depth = Number(process.argv[3])
const mode = process.argv[4] ?? 'shared'
const collect = (globalThis as { gc?: () => void }).gc

assert.ok(collect, 'Run with --expose-gc')
assert.ok(Number.isSafeInteger(size) && size > 0)
assert.ok(Number.isSafeInteger(depth) && depth > 0)
assert.ok(mode === 'shared' || mode === 'distinct')

const program: Array<Instruction> = [{ kind: 'own', id: 0, owned: true }]
const path = Array.from({ length: depth }, (_, index) => `field_${index}`)

for (let index = 0; index < size; index += 1)
    program.push({
        kind: 'borrow',
        id: index + 1,
        source: 0,
        path: mode === 'distinct' ? [...path.slice(0, -1), `leaf_${index}`] : path
    })

for (let index = 0; index < size; index += 1) program.push({ kind: 'read', source: index + 1 })

program.push({ kind: 'update', id: size + 1, source: 0, path: mode === 'distinct' ? [] : path })

for (let index = 0; index < 3; index += 1) plan(program)

collect()

const heap_before = process.memoryUsage().heapUsed
const samples: Array<{ wall_ms: number; cpu_ms: number }> = []
let result = plan(program)

for (let index = 0; index < 15; index += 1) {
    const cpu_before = process.cpuUsage()
    const start = performance.now()

    result = plan(program)

    const wall_ms = performance.now() - start
    const cpu = process.cpuUsage(cpu_before)

    samples.push({ wall_ms, cpu_ms: (cpu.user + cpu.system) / 1000 })
}

assert.equal(result.reuse[program.length - 1], true)
assert.equal(result.places, mode === 'distinct' ? size + depth : depth + 1)

const median = (values: Array<number>): number => values.sort((a, b) => a - b)[Math.floor(values.length / 2)]

console.log(
    JSON.stringify({
        size,
        depth,
        mode,
        instructions: program.length,
        places: result.places,
        loans: result.loans,
        visits: result.visits,
        wall_median_ms: median(samples.map(sample => sample.wall_ms)),
        cpu_median_ms: median(samples.map(sample => sample.cpu_ms)),
        heap_used_delta_bytes: process.memoryUsage().heapUsed - heap_before,
        node_peak_rss_bytes: process.resourceUsage().maxRSS * 1024,
        samples
    })
)
