export type Sample = {
    name: string
    target: string
    right: string
    setup?: string
    before?: string
    after?: string
    parameter?: string
}

export default function sourceProgram(args: { operator: string; identifier: string; sample: Sample }): {
    source: string
    span?: Array<number>
} {
    const { operator, identifier, sample } = args
    const parameter = sample.parameter ?? 'state'
    const setup = sample.setup ? `${sample.setup}\n    ` : ''
    const body = [
        sample.before,
        `${sample.target} ${operator} ${sample.right}`,
        sample.after,
        `${parameter}.round += 1`
    ]
        .filter(Boolean)
        .join('\n\n            ')
    const marked = `export type Input = { left: f64, right: f64 }

export type Output = { scalar: f64, field: f64, element: f64 }

export default function (in: Input): Output {
    ${setup}const initial = { scalar: in.left, ${identifier}: in.left, box: { ${identifier}: in.left }, values: [in.left], right: in.right, round: 0 }

    const result = loop(initial, {
        while: state => state.round < 1,
        next: ${parameter} => {
            ${body}
        }
    })

    return { scalar: result.${identifier}, field: result.box.${identifier}, element: result.values[0] }
}
`
    const start = marked.indexOf('⟦')
    const end = marked.indexOf('⟧')
    const source = marked.replace('⟦', '').replace('⟧', '')
    const span =
        start < 0
            ? undefined
            : [
                  Buffer.byteLength(marked.slice(0, start)),
                  Buffer.byteLength(marked.slice(0, end)) - Buffer.byteLength('⟦')
              ]

    return { source, ...(span ? { span } : {}) }
}
