import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import createFixture from '../../../packages/test/tests/targets/application_json/fixture.ts'
import createHost from '../../../packages/test/tests/targets/wasm/host.ts'

const directory = dirname(fileURLToPath(import.meta.url))
const prior = JSON.parse(
    readFileSync(resolve(directory, '../JSON输出数值边界回归/Debug/application-json-output-scalar.txt'))
)
const compiler = prior.commands[0].command
const targets = ['native', 'wasm32-freestanding', 'wasm32-wasi']

const definitions = [
    { name: 'negative_zero_scalar', type: 'f64', input: '-0', expected: '0', actual: '-0' },
    {
        name: 'negative_zero_tuple',
        type: '[string, f64, f64]',
        input: '["-0",0,-0]',
        expected: '["-0",0,0]',
        actual: '["-0",0,-0]'
    },
    {
        name: 'negative_zero_object',
        type: '{ key: f64 }',
        input: '{"key":-0}',
        expected: '{"key":0}',
        actual: '{"key":-0}'
    },
    {
        name: 'infinity_scalar',
        type: 'f64',
        input: '{"numerator":1,"denominator":0}',
        expected: 'null',
        expression: 'in.numerator / in.denominator'
    },
    {
        name: 'infinity_object',
        type: '{ key: f64 }',
        input: '{"numerator":-1,"denominator":0}',
        expected: '{"key":null}',
        expression: '{ key: in.numerator / in.denominator }'
    },
    {
        name: 'nan_list',
        type: 'f64[]',
        input: '{"numerator":0,"denominator":0}',
        expected: '[null]',
        expression: '[in.numerator / in.denominator]'
    }
]

const results = []

for (const definition of definitions) {
    const source = resolve(directory, definition.name + '.zx')
    const input_type = definition.expression ? '{ numerator: f64, denominator: f64 }' : definition.type

    writeFileSync(
        source,
        `export type Input = ${input_type}\n\nexport type Output = ${definition.type}\n\nexport default function (in: Input): Output {\n  return ${definition.expression ?? 'in'}\n}\n`
    )

    const fixture = createFixture({ compiler, source, optimize: 'debug' })
    const observations = []

    try {
        const paths = new Map(targets.map(target => [target, fixture.build(target)]))
        const host = createHost(paths.get('wasm32-freestanding'))

        try {
            for (const target of targets) {
                const memory = target === 'wasm32-freestanding' ? host.invoke(definition.input) : null

                const response = memory
                    ? { status: memory.status, output: memory.result, stderr: '' }
                    : fixture.execute({ path: paths.get(target), target, text: definition.input })

                const text =
                    response.status === 0 && target !== 'wasm32-freestanding'
                        ? response.output.endsWith('\n')
                            ? response.output.slice(0, -1)
                            : response.output
                        : response.output

                observations.push({
                    target,
                    response,
                    raw_utf8_hex: Buffer.from(response.output).toString('hex'),
                    text,
                    expected: definition.expected,
                    matches_test262: response.status === 0 && text === definition.expected
                })

                if (definition.actual !== undefined) {
                    assert.equal(response.status, 0)
                    assert.equal(text, definition.actual)
                } else if (target === 'wasm32-freestanding') {
                    assert.notEqual(response.status, 0)
                    assert.equal(response.output, 'NonFiniteJsonNumber')
                } else {
                    assert.notEqual(response.status, 0)
                    assert.equal(response.output, '')
                    assert.match(response.stderr, /NonFiniteJsonNumber/)
                }
            }
        } finally {
            host.api.zxc_deinit()
        }
    } finally {
        results.push({
            definition,
            source_sha256: createHash('sha256').update(readFileSync(source)).digest('hex'),
            commands: fixture.commands,
            artifacts: fixture.artifacts,
            observations
        })
        fixture.close()
        writeFileSync(
            resolve(directory, '数值原文结果.json'),
            JSON.stringify(
                {
                    compiler,
                    compiler_sha256: createHash('sha256').update(readFileSync(compiler)).digest('hex'),
                    optimize: 'debug',
                    results
                },
                null,
                2
            ) + '\n'
        )
    }
}

assert.equal(results.flatMap(row => row.observations).length, 18)
assert.ok(results.flatMap(row => row.observations).every(row => !row.matches_test262))
console.log('6 ordinary typed applications; 18 exact-text observations; explicit contract differences confirmed')
