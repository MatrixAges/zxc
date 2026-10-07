import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = {
    family: string
    path: string
    sha256: string
    gap_name: string
    left: number
    gap: string
    operator: string
    right: number
    expected: boolean
}
type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const samples = readRows<Sample>(resolve(package_dir, 'src/data/relational_whitespace.jsonl'))
const frontend: Array<Frontend> = []
const runtime = []
const branches: Array<string> = []
const reviews = new Map<
    string,
    { path: string; sha256: string; status: string; reason: string; contract: string; cases: Array<string> }
>()

for (const sample of samples) {
    if (!reviews.has(sample.path))
        reviews.set(sample.path, {
            path: sample.path,
            sha256: sample.sha256,
            status: 'adapted',
            reason: '逐项保留10条原始操作数、实际运算符与空白字符；扩展左右位置、混合类型及0/1/2运行输入。ZX接受ASCII空白，NBSP及Unicode行/段分隔符明确词法拒绝，不等价于JS全部接受；保留原文组合项的跨运算符表达式。',
            contract: 'packages/core/IR契约.md#表达式与求值',
            cases: []
        })
    const review = reviews.get(sample.path)!
    const rejected = [...sample.gap].find(character => character.charCodeAt(0) > 127)

    for (const position of ['left', 'right', 'both']) {
        const left_gap = position === 'right' ? ' ' : sample.gap
        const right_gap = position === 'left' ? ' ' : sample.gap

        for (const scalar of ['number', 'mixed']) {
            const left = scalar === 'number' ? String(sample.left) : 'true'
            const source = `export type Input = void

export type Output = bool

export default function (in: Input): Output {
  return ${left}${left_gap}${sample.operator}${right_gap}${sample.right}
}
`
            const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0
            const id = `language/types/relational_whitespace/${sample.family}/${sample.gap_name}/${position}/${scalar}`
            frontend.push({
                id,
                source,
                phase: rejected ? 'parse' : 'analyze',
                diagnostic: rejected ? 'lexical' : scalar === 'mixed' ? 'type_mismatch' : null,
                ...(rejected ? { span: [start, start + 1] } : {})
            })
            review.cases.push(id)
        }

        if (rejected) continue
        const shape = branches.length
        branches.push(`    case ${shape}: return in.value${left_gap}${sample.operator}${right_gap}${sample.right};`)

        for (const value of [0, 1, 2]) {
            const expected =
                sample.operator === '<'
                    ? value < sample.right
                    : sample.operator === '>'
                      ? value > sample.right
                      : sample.operator === '<='
                        ? value <= sample.right
                        : value >= sample.right
            const id = `language/expressions/comparison/whitespace/${sample.family}/${sample.gap_name}/${position}/${value}`
            runtime.push({ id, input: { shape, value }, expected: { value: expected } })
            review.cases.push(id)
        }
    }
}

writeCatalog('tests/language/types/relational_whitespace/cases.jsonl', frontend)
writeCatalog('tests/language/expressions/comparison/whitespace.jsonl', runtime)
writeOutput(
    'tests/language/expressions/comparison/whitespace.zx',
    `export type Input = { shape: u64
 value: f64 }

export type Output = bool

export default function (in: Input): Output {
  switch (in.shape) {
${branches.join('\n')}
    default: return false
  }
}
`
)
writeCatalog('upstream/reviews/language/expressions/relational_whitespace.jsonl', [...reviews.values()])
