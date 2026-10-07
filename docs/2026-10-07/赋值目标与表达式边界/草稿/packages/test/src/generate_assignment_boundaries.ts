import type { Json } from './shared/json.ts'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'

type Original = { path: string; sha256: string; status: string; reason: string }
type Runtime = {
    name: string
    path: string | null
    scalar: string
    fields: string
    statement: string
    result: string
    expected: Json
    seeds: Array<Json>
}
type Frontend = {
    name: string
    path: string | null
    source: string
    phase: string
    diagnostic: string | null
    span?: Array<number>
    original_expected?: number
}
type Review = Original & {
    contract: string
    cases: Array<string>
    assertions: Array<{ case: string; field: string; expected: Json }>
    diagnostics: Array<{ case: string; phase: string; code: string; span?: Array<number> }>
}

const data = JSON.parse(readFileSync(resolve(package_dir, 'src/data/assignment_boundaries.json'), 'utf8')) as {
    originals: Array<Original>
    runtime: Array<Runtime>
    frontend: Array<Frontend>
}
const base = 'language/statements/assignment_boundaries'
const reviews = new Map<string, Review>(
    data.originals.map(original => [
        original.path,
        {
            ...original,
            contract: 'packages/core/IR契约.md#表达式与求值',
            cases: [],
            assertions: [],
            diagnostics: []
        }
    ])
)

for (const sample of data.runtime) {
    const path = `${base}/${sample.name}`
    const rows = sample.seeds.map((input, index) => ({
        id: `${path}/${index}`,
        input,
        expected: { value: sample.expected }
    }))
    const review = sample.path ? reviews.get(sample.path)! : null

    writeCatalog(`tests/${path}.jsonl`, rows)
    writeOutput(
        `tests/${path}.zx`,
        `export type Input = ${sample.scalar}

export type Output = ${sample.scalar}

export default function (in: Input): Output {
    const initial = { ${sample.fields} }

    const result = loop(initial, {
        while: state => state.round < 1,
        next: state => {
            ${sample.statement}

            state.round += 1
        }
    })

    return ${sample.result}
}
`
    )

    if (review) {
        review.cases.push(...rows.map(row => row.id))
        review.assertions.push(...rows.map(row => ({ case: row.id, field: 'value', expected: sample.expected })))
    }
}

const frontend = data.frontend.map(sample => {
    const { name, path, original_expected, ...row } = sample
    const id = `${base}/frontend/${name}`

    if (path) {
        const review = reviews.get(path)!

        review.cases.push(id)

        if (row.diagnostic)
            review.diagnostics.push({ case: id, phase: row.phase, code: row.diagnostic, span: row.span })
    }

    return { id, ...row }
})

writeCatalog(`tests/${base}/frontend.jsonl`, frontend)
writeCatalog('upstream/reviews/language/expressions/assignment_boundaries.jsonl', [...reviews.values()])
