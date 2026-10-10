import { writeCatalog, writeOutput } from './shared/catalog.ts'

const prefix = 'language/types/boolean/assignment'
const frontend = []

function source(statement: string): string {
    return `export type Input = { value: f64, round: u32, rounds: u32 }

export type Output = f64

export default function (in: Input): Output {
    const result = loop(in, {
        while: state => state.round < state.rounds,
        next: state => {
            ${statement}

            state.round += 1
        }
    })

    return result.value
}
`
}

for (const [literal, value] of [
    ['true', 1],
    ['false', 0]
] as const) {
    const statement = `${literal} = ${value}`

    for (const [name, comment] of [
        ['original', ''],
        ['unicode_prefix', '// 漢字\n\n']
    ] as const) {
        const text = comment + source(statement)
        const offset = text.indexOf(statement)
        const start = Buffer.byteLength(text.slice(0, offset))

        frontend.push({
            id: `${prefix}/frontend/${literal}/${name}`,
            source: text,
            phase: 'parse',
            diagnostic: 'syntax',
            span: [start, start + Buffer.byteLength(literal)]
        })
    }

    const control = source(`state.value = ${value}`)
    const path = `${prefix}/assign_${value === 1 ? 'one' : 'zero'}`

    frontend.push({
        id: `${prefix}/frontend/${literal}/assignable_control`,
        source: control,
        phase: 'parse',
        diagnostic: null
    })
    writeOutput(`tests/${path}.zx`, control)
    writeCatalog(
        `tests/${path}.jsonl`,
        [
            { name: 'zero_rounds', input: { value: -7, round: 0, rounds: 0 } },
            { name: 'one_round', input: { value: 0, round: 0, rounds: 1 } },
            { name: 'two_rounds', input: { value: 42, round: 0, rounds: 2 } }
        ].map(({ name, input }) => ({
            id: `${path}/${name}`,
            input,
            expected: { value: input.rounds === 0 ? input.value : value }
        }))
    )
}

writeCatalog(`tests/${prefix}/frontend.jsonl`, frontend)
