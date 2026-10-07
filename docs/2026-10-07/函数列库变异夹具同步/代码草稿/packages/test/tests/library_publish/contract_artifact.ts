import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'

type FunctionTable = {
    roots: Array<number | null>
    control: Array<{
        block_first: Array<number>
        block_count: Array<number>
        statement_kinds: Array<string>
        statement_payloads: Array<number>
        results: Array<number | null>
    }>
    symbols: Array<{ names: Array<string> }>
    expressions: Array<{
        kinds: Array<string>
        payloads: Array<number>
        references: Array<number>
        integers: Array<number>
    }>
    contracts: Array<Array<{ kind: string }>>
}
type Artifact = {
    exports: Array<{ name: string; function: number | null }>
    program: { functions: FunctionTable }
}

export default function breakIdentity(encoded: Buffer): Buffer {
    const [marker, original_digest, ...rest] = encoded.toString().split('\n')
    const text = rest.join('\n')
    assert.equal(marker, 'zxc.library.v2')
    assert.equal(original_digest, createHash('sha256').update(text).digest('hex'))
    const payload = JSON.parse(text) as Artifact
    const exported = payload.exports.find(entry => entry.name === '.')
    assert.ok(exported)
    assert.notEqual(exported.function, null)
    const functions = payload.program.functions
    const function_index = exported.function!

    assert.ok(functions.contracts[function_index].some(contract => contract.kind === 'ensures'))

    const root = functions.roots[function_index]
    const control = functions.control[function_index]
    assert.notEqual(root, null)
    assert.equal(control.block_count[root!], 1)
    const statement = control.block_first[root!]
    assert.equal(control.statement_kinds[statement], 'Result')
    const result = control.results[control.statement_payloads[statement]]
    assert.notEqual(result, null)

    const expressions = functions.expressions[function_index]
    assert.equal(expressions.kinds[result!], 'Reference')
    const reference = expressions.payloads[result!]
    assert.equal(functions.symbols[function_index].names[expressions.references[reference]], 'in')

    expressions.references.splice(reference, 1)
    const integer = expressions.kinds.slice(0, result!).filter(kind => kind === 'Integer').length
    expressions.integers.splice(integer, 0, 0)

    for (let index = result! + 1; index < expressions.kinds.length; index++) {
        if (expressions.kinds[index] === 'Reference') expressions.payloads[index]--
        if (expressions.kinds[index] === 'Integer') expressions.payloads[index]++
    }

    expressions.kinds[result!] = 'Integer'
    expressions.payloads[result!] = integer

    const modified = JSON.stringify(payload)
    const digest = createHash('sha256').update(modified).digest('hex')
    assert.notEqual(digest, original_digest)

    return Buffer.from(`${marker}\n${digest}\n${modified}`)
}
