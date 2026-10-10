export function caseSource(args: { indices: Array<number>; tokens: Array<string> }): string {
    const { indices, tokens } = args
    const cases = indices.map(index => '        case ' + index + ':\n            return ' + tokens[index]).join('\n')

    return (
        'export type Input = u64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n    switch (in) {\n' +
        cases +
        '\n        default:\n            return 0\n    }\n}\n'
    )
}

export function dispatchSource(args: { imports: Array<string>; branches: Array<string> }): string {
    const { imports, branches } = args

    return (
        imports.join('\n') +
        '\n\nexport type Input = u64\n\nexport type Output = f64\n\nexport default function (in: Input): Output {\n' +
        branches.join('\n\n') +
        '\n\n    return 0\n}\n'
    )
}
