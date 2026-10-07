import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'

type Function = {
    body: {
        root: number | null
        control: {
            block_first: Array<number>
            block_count: Array<number>
            statement_kinds: Array<string>
            statement_payloads: Array<number>
            results: Array<number | null>
        }
    }
    symbols: { names: Array<string> }
    expressions: {
        kinds: Array<string>
        payloads: Array<number>
        references: Array<number>
        integers: Array<number>
    }
    contracts: Array<{ kind: string }>
}
type Artifact = {
    exports: Array<{ name: string; function: number | null }>
    program: { functions: Array<Function> }
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
    const fn = payload.program.functions[exported.function!]
    assert.ok(fn.contracts.some(contract => contract.kind === 'ensures'))
    const { root, control } = fn.body
    assert.notEqual(root, null)
    assert.equal(control.block_count[root!], 1)
    const statement = control.block_first[root!]
    assert.equal(control.statement_kinds[statement], 'Result')
    const result = control.results[control.statement_payloads[statement]]
    assert.notEqual(result, null)

    const expressions = fn.expressions
    assert.equal(expressions.kinds[result!], 'Reference')
    const reference = expressions.payloads[result!]
    assert.equal(fn.symbols.names[expressions.references[reference]], 'in')

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
