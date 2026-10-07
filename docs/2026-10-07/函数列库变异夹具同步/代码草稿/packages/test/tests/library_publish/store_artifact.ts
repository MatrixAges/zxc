import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'

type FunctionTable = {
    files: Array<string>
    input_types: Array<number>
    output_types: Array<number>
    store_modes: Array<string>
    stores: Array<{ paths: Array<string> }>
}
type Export = { name: string; path: string; function: number | null; types: Array<{ name: string; type_id: number }> }
type Artifact = {
    program: { functions: FunctionTable }
    exports: Array<Export>
    store_initializers: Array<{ identity: string; schema_version: number; function: number }>
}

export default function openArtifact(path: string) {
    const bytes = readFileSync(path, 'utf8')
    const first = bytes.indexOf('\n')
    const second = bytes.indexOf('\n', first + 1)
    const marker = bytes.slice(0, first)
    const text = bytes.slice(second + 1)
    assert.equal(marker, 'zxc.library.v2')
    assert.equal(bytes.slice(first + 1, second), createHash('sha256').update(text).digest('hex'))
    const payload = JSON.parse(text) as Artifact

    function exposeTransaction(): void {
        const functions = payload.program.functions
        const index = functions.store_modes.findIndex(
            (mode, index) => mode === 'transaction' && functions.stores[index].paths.length > 0
        )
        assert.notEqual(index, -1)

        payload.exports.push({
            name: './raw',
            path: functions.files[index],
            function: index,
            types: [
                { name: 'Input', type_id: functions.input_types[index] },
                { name: 'Output', type_id: functions.output_types[index] }
            ]
        })
    }

    function save(): void {
        const text = JSON.stringify(payload)
        const digest = createHash('sha256').update(text).digest('hex')
        writeFileSync(path, `${marker}\n${digest}\n${text}`)
    }

    return { payload, exposeTransaction, save }
}
