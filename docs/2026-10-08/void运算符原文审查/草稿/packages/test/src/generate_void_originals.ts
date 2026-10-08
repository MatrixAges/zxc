import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = {
    name: string
    source: string
    sha256: string
    check: number
    expression: string
    prefix: string
    phase: string
    diagnostic: string
    span: [number, number]
}

type Review = {
    path: string
    sha256: string
    status: string
    reason: string
    contract: string
    cases: Array<string>
    diagnostics: Array<{ case: string; phase: string; code: string; span: [number, number] }>
}

const samples = readRows<Sample>(resolve(package_dir, 'src/data/void_originals.jsonl'))
const cases = samples.map(sample => ({
    id: `language/types/void_originals/${sample.name}/${sample.check}`,
    source: `export type Input = u64

export type Output = void

export default function (in: Input): Output {
${sample.prefix}    return ${sample.expression}
}
`,
    phase: sample.phase,
    diagnostic: sample.diagnostic,
    span: sample.span
}))
const reviews = new Map<string, Review>()

for (const [index, sample] of samples.entries()) {
    let review = reviews.get(sample.source)

    if (!review) {
        review = {
            path: sample.source,
            sha256: sample.sha256,
            status: 'excluded',
            reason: '保留每项原始void表达式并实测词法或语法拒绝；x使用通用静态绑定以隔离运算符表面，完整原文上下文保存在来源数据。JavaScript void运算符的undefined结果、GetValue、isNaN转换、对象包装、eval、ReferenceError及赋值副作用未执行。当前ZX void类型不能据此认作同等运算符，诊断边界不计兼容执行或adapted。',
            contract: 'packages/core/IR契约.md#表达式与求值',
            cases: [],
            diagnostics: []
        }

        reviews.set(sample.source, review)
    }

    review.cases.push(cases[index].id)
    review.diagnostics.push({ case: cases[index].id, phase: sample.phase, code: sample.diagnostic, span: sample.span })
}

writeCatalog('tests/language/types/void_originals/cases.jsonl', cases)
writeCatalog('upstream/reviews/language/expressions/void_originals.jsonl', [...reviews.values()])
