import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Expression = { name: string; source: string }
const input = '{ group: u8\n value: bool?\n left: bool\n right: bool }'
const base = 'language/expressions/coalesce/logical'
const originals = {
    and: ['(null ?? 41) && 42', 'null ?? (41 && 42)', '(41 && 42) ?? null', '41 && (null ?? 42)'],
    or: [
        '(null ?? 42) || 43',
        'null ?? (42 || 43)',
        '(null || 42) ?? 43',
        'null || (42 ?? 43)',
        '(42 || 43) ?? null',
        '42 || (null ?? 43)'
    ]
}

for (const name of ['and', 'or'] as const) {
    const operator = name === 'and' ? '&&' : '||'
    const expressions: Array<Expression> = [
        { name: 'coalesce_first', source: `(in.value ?? in.left) ${operator} in.right` },
        { name: 'logical_fallback', source: `in.value ?? (in.left ${operator} in.right)` },
        { name: 'coalesce_right', source: `in.left ${operator} (in.value ?? in.right)` }
    ]
    const branches = expressions
        .map((expression, index) => `    case ${index}: return ${expression.source};`)
        .join('\n')
    const source = `export type Input = ${input}

export type Output = bool

export default function (in: Input): Output {
  switch (in.group) {
${branches}
    default: return false
  }
}
`
    const rows = []

    for (const [group, expression] of expressions.entries()) {
        for (const value of [null, false, true]) {
            for (const left of [false, true]) {
                for (const right of [false, true]) {
                    const logical = (first: boolean, second: boolean): boolean =>
                        name === 'and' ? first && second : first || second
                    const merged_left = value === null ? left : value
                    const merged_right = value === null ? right : value
                    const result =
                        group === 0
                            ? logical(merged_left, right)
                            : group === 1
                              ? value === null
                                  ? logical(left, right)
                                  : value
                              : logical(left, merged_right)

                    rows.push({
                        id: `${base}/${name}/${expression.name}/${value}/${left}/${right}`,
                        input: { group, value, left, right },
                        expected: { value: result }
                    })
                }
            }
        }
    }

    writeOutput(`tests/${base}/${name}.zx`, source)
    writeCatalog(`tests/${base}/${name}.jsonl`, rows)
}

writeCatalog(
    'tests/language/types/coalesce_logical/cases.jsonl',
    Object.entries(originals).flatMap(([name, expressions]) =>
        expressions.map((expression, index) => ({
            id: `language/types/coalesce_logical/${name}/original_${index + 1}`,
            source: `export type Input = void

export type Output = bool

export default function (in: Input): Output {
  return ${expression}
}
`,
            phase: 'analyze',
            diagnostic: 'type_mismatch'
        }))
    )
)
