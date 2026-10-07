import type { Sample } from './compound_references/source.ts'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import sourceProgram from './compound_references/source.ts'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'

type Original = {
    path: string
    sha256: string
    operator: string
    kind: 'lhs' | 'rhs' | 'resolved'
    identifier: string
    left?: number
    right?: number
    expected?: number
}
type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
const originals = JSON.parse(
    readFileSync(resolve(package_dir, 'src/data/compound_references.json'), 'utf8')
) as Array<Original>
const frontend: Array<Frontend> = []
const reviews = []
const operations = new Map([
    ['*=', 'multiply'],
    ['/=', 'divide'],
    ['%=', 'remainder'],
    ['+=', 'add'],
    ['-=', 'subtract']
])

function bits(value: number): string {
    const buffer = Buffer.alloc(8)

    buffer.writeDoubleBE(value)

    return buffer.toString('hex')
}

for (const original of originals) {
    const operation = operations.get(original.operator)
    const cases: Array<string> = []
    const diagnostics = []

    if (!operation) {
        reviews.push({
            path: original.path,
            sha256: original.sha256,
            status: 'excluded',
            reason: '完整读取原引用解析或写回检查。当前没有此移位/按位复合操作，JS动态Reference、数值转换和赋值表达式要求不能由算术状态更新替代。',
            contract: 'packages/core/IR契约.md',
            cases
        })
        continue
    }

    const identifier = original.identifier
    let samples: Array<Sample & { diagnostic: string | null; compile_diagnostic?: string }>

    if (original.kind === 'lhs') {
        samples = [
            { name: 'bare', target: `⟦${identifier}⟧`, right: 'state.right', diagnostic: 'name' },
            { name: 'root', target: `⟦${identifier}⟧.value`, right: 'state.right', diagnostic: 'name' },
            { name: 'field', target: `state.⟦missing_${identifier}⟧`, right: 'state.right', diagnostic: 'name' }
        ]
    } else if (original.kind === 'rhs') {
        samples = [
            { name: 'bare', target: 'state.scalar', right: '⟦y⟧', diagnostic: 'name' },
            { name: 'root', target: 'state.scalar', right: '⟦y⟧.value', diagnostic: 'name' },
            { name: 'field', target: 'state.scalar', right: 'state.⟦y⟧', diagnostic: 'name' }
        ]
    } else {
        samples = [
            { name: 'scalar', target: `state.${identifier}`, right: 'state.right', diagnostic: null },
            { name: 'field', target: `state.box.${identifier}`, right: 'state.right', diagnostic: null },
            { name: 'element', target: 'state.values[0]', right: 'state.right', diagnostic: null },
            {
                name: 'local_readonly',
                before: `const binding = state.scalar`,
                target: `⟦binding⟧`,
                right: 'state.right',
                diagnostic: 'ownership'
            },
            {
                name: 'outer_capture',
                setup: `const binding = in.left`,
                target: `⟦binding⟧`,
                right: 'state.right',
                diagnostic: 'ownership'
            },
            {
                name: 'before_declaration',
                target: `⟦binding⟧`,
                right: 'state.right',
                after: `const binding = state.scalar`,
                diagnostic: 'name'
            },
            {
                name: 'parameter_shadow',
                setup: `const binding = in.left`,
                parameter: 'binding',
                target: `binding.scalar`,
                right: `binding.right`,
                diagnostic: null
            },
            {
                name: 'duplicate_local',
                before: `const binding = state.scalar\n            const ⟦binding⟧ = state.right`,
                target: 'state.scalar',
                right: 'state.right',
                diagnostic: 'name'
            },
            {
                name: 'original_binding_name',
                before: `const ⟦${identifier}⟧ = state.scalar`,
                target: 'state.scalar',
                right: 'state.right',
                diagnostic: null,
                compile_diagnostic: 'naming'
            }
        ]

        const base = `language/statements/state_updates/references/${operation}`
        const program = sourceProgram({
            operator: original.operator,
            identifier,
            sample: {
                name: 'runtime',
                target: `state.${identifier}`,
                right: 'state.right',
                after: `state.box.${identifier} ${original.operator} state.right\n            state.values[0] ${original.operator} state.right`
            }
        }).source
        const id = `${base}/original`

        writeOutput(`tests/${base}.zx`, program)
        writeCatalog(`tests/${base}.jsonl`, [
            { id, left: bits(original.left!), right: bits(original.right!), expected: bits(original.expected!) }
        ])
        cases.push(id)
    }

    for (const sample of samples) {
        const { source, span } = sourceProgram({ operator: original.operator, identifier, sample })

        for (const phase of ['analyze', 'compile']) {
            const id = `language/types/compound_references/${original.path.split('/').at(-1)!.replace('.js', '')}/${sample.name}/${phase}`
            const diagnostic =
                phase === 'compile' ? (sample.compile_diagnostic ?? sample.diagnostic) : sample.diagnostic
            const row = { id, source, phase, diagnostic, ...(diagnostic && span ? { span } : {}) }

            frontend.push(row)
            cases.push(id)
            if (row.diagnostic) diagnostics.push({ case: id, phase, code: row.diagnostic, span })
        }
    }

    reviews.push({
        path: original.path,
        sha256: original.sha256,
        status: 'adapted',
        reason:
            original.kind === 'resolved'
                ? '保留原变量名字为状态字段、数值与复合操作，改为显式loop状态的普通字段、嵌套字段和列表元素真实f64写回并按位核验；扩展作用域解析、只读本地绑定、禁止捕获、声明顺序与合法参数遮蔽；普通绑定使用合法名字，原下划线绑定单独验证compile/naming与analyze通过差异。ZX不支持普通全局变量更新或赋值表达式值，不能声明JS Reference等价。'
                : '保留未声明左值或右值要求，逐项测试裸标识符、未知根投影及缺失字段的analyze/compile name与精确span。JS运行时ReferenceError被ZX静态诊断替代，去除eval或赋值表达式包裹，不声明运行时异常、动态Reference或严格模式等价。',
        contract: 'packages/core/IR契约.md',
        cases,
        diagnostics
    })
}

writeCatalog('tests/language/types/compound_references/cases.jsonl', frontend)
writeCatalog('upstream/reviews/language/expressions/compound_references.jsonl', reviews)
