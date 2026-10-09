import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { pathToFileURL } from 'node:url'

const [repository, run, mode, task] = process.argv.slice(2)
const fixture = repository + '/packages/test/tests/targets'
const cpu = mode === 'simd' ? 'baseline+simd128' : 'baseline'

if (task === 'assembly') {
    const { default: checkAssembly } = await import(pathToFileURL(fixture + '/simd/assembly.ts'))

    checkAssembly({ assembly: readFileSync(run + '/f32-' + mode + '.s', 'utf8'), type: 'f32', cpu })
    console.log(JSON.stringify({ cpu, assembly_check: 'passed' }))
} else {
    assert.equal(task, 'semantics')

    const { default: createHost } = await import(pathToFileURL(fixture + '/wasm/host.ts'))
    const { default: check } = await import(pathToFileURL(fixture + '/simd/check.ts'))
    const { default: values, lengths } = await import(pathToFileURL(fixture + '/simd/values.ts'))
    const host = createHost(run + '/f32-' + mode + '.wasm')
    let count = 0

    try {
        for (const size of lengths) {
            const input = values({ size, special: false })
            const result = host.invoke(JSON.stringify(input))

            assert.equal(result.status, 0, result.result)
            check({ actual: JSON.parse(result.result), input, type: 'f32', json: true })
            count += 1
        }
    } finally {
        host.api.zxc_deinit()
    }

    console.log(JSON.stringify({ cpu, existing_semantics_cases_passed: count }))
}
