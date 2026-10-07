import type { Gaps, Target } from './compound_whitespace/source.ts'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { frontendSource, runtimeSource } from './compound_whitespace/source.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'

type Original = {
    name: string
    operator: string
    path: string
    sha256: string
    left_bits: string
    right_bits: string
    expected_bits: string
    groups: Array<{ name: string; gap_hex: string }>
}
type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const originals = JSON.parse(
    readFileSync(resolve(package_dir, 'src/data/compound_whitespace.json'), 'utf8')
) as Array<Original>
const frontend: Array<Frontend> = []
const reviews = []

function expectation(args: { id: string; source: string; mixed: boolean; expression: boolean }): Frontend {
    const { id, source, mixed, expression } = args
    const rejected = [...source].find(character => character.charCodeAt(0) > 127)
    const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0

    return {
        id,
        source,
        phase: rejected || expression ? 'parse' : 'analyze',
        diagnostic: rejected ? 'lexical' : expression ? 'syntax' : mixed ? 'type_mismatch' : null,
        ...(rejected ? { span: [start, start + 1] } : {})
    }
}

for (const original of originals) {
    if (!['*=', '/=', '%=', '+=', '-='].includes(original.operator)) {
        reviews.push({
            path: original.path,
            sha256: original.sha256,
            status: 'excluded',
            reason: `原文要求${original.operator}复合算术、JS数值位移/按位转换及表达式返回值；当前zxc没有对应复合操作。完整保留十组空白、二十项SameValue断言，不以乘除或简单整数索引冒充兼容。`,
            contract: 'packages/core/IR契约.md',
            cases: []
        })
        continue
    }

    const base = `language/statements/state_updates/whitespace/${original.name}`
    const shapes: Array<Gaps> = []
    const runtime = []
    const cases: Array<string> = []
    const diagnostics = []

    for (const group of original.groups) {
        const gap = Buffer.from(group.gap_hex, 'hex').toString('utf8')
        const rejected = [...gap].some(character => character.charCodeAt(0) > 127)

        for (const position of ['left', 'right', 'both']) {
            const gaps = { left: position === 'right' ? ' ' : gap, right: position === 'left' ? ' ' : gap }

            for (const target of ['scalar', 'field', 'element'] as Array<Target>) {
                for (const mixed of [false, true]) {
                    const id = `language/types/compound_whitespace/${original.name}/${group.name}/${position}/${target}/${mixed ? 'mixed' : 'number'}`
                    const source = frontendSource({
                        operator: original.operator,
                        gaps,
                        target,
                        mixed,
                        expression: false
                    })
                    const row = expectation({ id, source, mixed, expression: false })

                    frontend.push(row)
                    cases.push(id)
                    if (row.diagnostic)
                        diagnostics.push({
                            case: id,
                            phase: row.phase,
                            code: row.diagnostic,
                            ...(row.span ? { span: row.span } : {})
                        })
                }
            }

            const id = `language/types/compound_whitespace/${original.name}/${group.name}/${position}/expression-value`
            const source = frontendSource({ operator: original.operator, gaps, mixed: false, expression: true })
            const row = expectation({ id, source, mixed: false, expression: true })

            frontend.push(row)
            cases.push(id)
            diagnostics.push({
                case: id,
                phase: row.phase,
                code: row.diagnostic,
                ...(row.span ? { span: row.span } : {})
            })

            if (rejected) continue

            const shape = shapes.length
            const runtime_id = `${base}/${group.name}/${position}`

            shapes.push(gaps)
            runtime.push({
                id: runtime_id,
                left: original.left_bits,
                right: original.right_bits,
                third: shape.toString(16).padStart(16, '0'),
                expected: original.expected_bits
            })
            cases.push(runtime_id)
        }
    }

    writeCatalog(`tests/${base}.jsonl`, runtime)
    const imports: Array<string> = []
    const branches: Array<string> = []
    let first = 0

    for (const group of original.groups) {
        const gap = Buffer.from(group.gap_hex, 'hex').toString('utf8')

        if ([...gap].some(character => character.charCodeAt(0) > 127)) continue

        const symbol = group.name.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase())

        writeOutput(
            `tests/${base}/${group.name}.zx`,
            runtimeSource({ operator: original.operator, shapes: shapes.slice(first, first + 3), first })
        )
        imports.push(`import ${symbol} from "./${original.name}/${group.name}"`)
        branches.push(`    if (in.shape >= ${first} && in.shape < ${first + 3}) {\n        return ${symbol}(in)\n    }`)
        first += 3
    }

    writeOutput(
        `tests/${base}.zx`,
        `${imports.sort().join('\n')}

export type Input = { left: f64, right: f64, shape: u8 }

export type Output = { scalar: f64, field: f64, element: f64 }

export default function (in: Input): Output {
${branches.join('\n\n')}

    return { scalar: in.left, field: in.left, element: in.left }
}
`
    )
    reviews.push({
        path: original.path,
        sha256: original.sha256,
        status: 'adapted',
        reason: '逐项保存原10组真实空白字节与20项SameValue要求。六种ASCII空白执行f64复合写回，按位比较普通字段、嵌套字段、列表元素；扩展左右单侧。NBSP、LS、PS及组合串以首个非ASCII字节lexical拒绝，混合bool只在词法通过后type_mismatch；赋值表达式值位置syntax拒绝。保留余数负零0x8000000000000000。状态更新语句替代JS可返回值赋值表达式，不宣称Unicode空白或表达式返回值兼容。',
        contract: 'packages/core/IR契约.md',
        cases,
        diagnostics
    })
}

writeCatalog('tests/language/types/compound_whitespace/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/compound_whitespace.jsonl', reviews)
