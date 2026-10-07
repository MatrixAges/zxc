import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = {
    name: string
    path: string
    sha256: string
    original_check: number
    original_expression: string
    original_expected: string
    prefix: string
    phase: string
    diagnostic: string
}

const samples = readRows<Sample>(resolve(package_dir, 'src/data/concatenation_remaining.jsonl'))
const cases = samples.map(sample => ({
    id: `language/types/concatenation_remaining/${sample.name}/${sample.original_check}`,
    source: `export type Input = void

export type Output = string

export default function (in: Input): Output {
${sample.prefix}    return ${sample.original_expression}
}
`,
    phase: sample.phase,
    diagnostic: sample.diagnostic
}))
const reviews = new Map<
    string,
    {
        path: string
        sha256: string
        status: string
        reason: string
        contract: string
        cases: Array<string>
        diagnostics: Array<{ case: string; phase: string; code: string }>
    }
>()

for (const [index, sample] of samples.entries()) {
    let review = reviews.get(sample.path)

    if (!review) {
        review = {
            path: sample.path,
            sha256: sample.sha256,
            status: 'excluded',
            reason: '逐项保留原表达式及必要对象/字符串上下文，验证当前ZX的明确诊断。原测试要求隐式ToString、typeof或JavaScript对象ToPrimitive；这些不属于当前静态加号契约。诊断拒绝及独立显式模板插值对照不代表原运行断言通过，不计adapted。',
            contract: 'packages/core/IR契约.md#表达式与求值',
            cases: [],
            diagnostics: []
        }
        reviews.set(sample.path, review)
    }

    review.cases.push(cases[index].id)
    review.diagnostics.push({ case: cases[index].id, phase: sample.phase, code: sample.diagnostic })
}

writeCatalog('tests/language/types/concatenation_remaining/cases.jsonl', cases)
writeCatalog('upstream/reviews/language/expressions/concatenation_remaining.jsonl', [...reviews.values()])
writeCatalog('tests/language/expressions/concatenation/string_identity.jsonl', [
    {
        id: 'language/expressions/concatenation/string_identity/abc',
        input: { value: 'abc' },
        expected: { value: 'abc' }
    }
])
writeOutput(
    'tests/language/expressions/concatenation/string_identity.zx',
    'export type Input = { value: string }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n    const x1 = in.value\n\n    return `${x1}${""}`\n}\n'
)
