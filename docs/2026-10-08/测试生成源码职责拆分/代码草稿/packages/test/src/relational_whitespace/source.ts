import sourceDependencies from '../shared/source_dependencies.ts'
import sourceRanges from '../shared/source_ranges.ts'
import writeZx from '../shared/write_zx.ts'

export type Branch = { shape: number; operator: string; source: string }

const names: Record<string, string> = { '<': 'less', '>': 'greater', '<=': 'less_equal', '>=': 'greater_equal' }
const contract =
    'export type Input = { shape: u64\n value: f64 }\n\nexport type Output = bool\n\nexport default function (in: Input): Output {\n'

export default async function writeWhitespaceSource(branches: Array<Branch>): Promise<void> {
    const groups = new Map<string, Array<Branch>>()

    for (const branch of branches) {
        const name = names[branch.operator]

        if (!name) throw new Error('unsupported relational operator: ' + branch.operator)

        const group = groups.get(name) ?? []

        group.push(branch)
        groups.set(name, group)
    }

    const imports: Array<string> = []
    const selections: Array<string> = []
    const sources: Array<string> = []
    const base = 'language/expressions/comparison/whitespace'

    for (const name of [...groups.keys()].sort()) {
        const group = groups.get(name)!
        const symbol = name.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase())
        const path = `tests/${base}/${name}.zx`

        writeZx(
            path,
            contract +
                '  switch (in.shape) {\n' +
                group.map(branch => branch.source).join('\n') +
                '\n    default: return false\n  }\n}\n'
        )
        imports.push(`import ${symbol} from "./whitespace/${name}"`)
        selections.push(
            `  if (${sourceRanges({ indices: group.map(branch => branch.shape), selector: 'in.shape' })}) {\n    return ${symbol}(in)\n  }`
        )
        sources.push(path)
    }

    writeZx(
        `tests/${base}.zx`,
        imports.join('\n') + '\n\n' + contract + selections.join('\n\n') + '\n\n  return false\n}\n'
    )
    await sourceDependencies({ path: base, sources })
}
