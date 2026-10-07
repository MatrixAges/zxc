import { writeCatalog } from './shared/catalog.ts'

function program(output: string, expression: string): string {
    return `export type Input = void

export type Output = ${output}

export default function (in: Input): Output {
  return ${expression}
}
`
}

const suffixes = {
    trailing_separator: '_',
    double_separator: '__0',
    before_exponent: '_e2',
    missing_exponent: 'e',
    missing_upper_exponent: 'E',
    missing_positive_exponent: 'e+',
    missing_negative_exponent: 'E-',
    separator_after_exponent: 'e_1',
    separator_after_sign: 'e+_1',
    exponent_trailing_separator: 'e1_',
    exponent_double_separator: 'e1__0',
    fraction_trailing_separator: '.0_',
    fraction_double_separator: '.0__1',
    fraction_missing_exponent: '.0e',
    fraction_missing_positive_exponent: '.0e+',
    fraction_exponent_separator: '.0e_1'
}
const invalid = []

for (const prefix of ['0', '1', '12', '1234']) {
    for (const [name, suffix] of Object.entries(suffixes)) {
        const token = prefix + suffix

        for (const [context, output, expression] of [
            ['integer', 'u64', 'TOKEN'],
            ['float', 'f64', 'TOKEN'],
            ['boolean', 'bool', 'TOKEN'],
            ['template', 'string', '`value-${TOKEN}`']
        ]) {
            const template = program(output, expression)
            const start = template.indexOf('TOKEN')
            invalid.push({
                id: `language/lexical/numeric/invalid/${name}/${prefix}/${context}`,
                source: template.replace('TOKEN', token),
                phase: 'parse',
                diagnostic: 'lexical',
                span: [start, start + token.length]
            })
        }
    }
}

for (const [name, token] of Object.entries({
    adjacent_long: '1__0123456789',
    adjacent_multidigit: '10__0123456789',
    trailing_multidigit: '10_',
    fraction_before_exponent: '10.0_e1'
})) {
    for (const [context, output] of [
        ['integer', 'u64'],
        ['boolean', 'bool']
    ]) {
        const template = program(output, 'TOKEN')
        const start = template.indexOf('TOKEN')
        invalid.push({
            id: `language/lexical/numeric/invalid/upstream/${name}/${context}`,
            source: template.replace('TOKEN', token),
            phase: 'parse',
            diagnostic: 'lexical',
            span: [start, start + token.length]
        })
    }
}

const valid = [
    ['zero', '0', 'u64'],
    ['leading_zero', '01', 'u64'],
    ['decimal', '1.25', 'f64'],
    ['integer_separator', '1_000', 'u64'],
    ['fraction_separator', '1.2_5', 'f64'],
    ['exponent_separator', '1e2_0', 'f64'],
    ['exponent_positive', '1.25e+2', 'f64'],
    ['exponent_negative', '1.25e-2', 'f64'],
    ['uppercase_exponent', '1E2', 'f64'],
    ['all_separators', '1_2.3_4E+1_0', 'f64']
].map(([name, token, scalar]) => ({
    id: `language/lexical/numeric/valid/${name}`,
    source: program(scalar, token),
    phase: 'analyze',
    diagnostic: null
}))

writeCatalog('tests/language/lexical/numeric/invalid.jsonl', invalid)
writeCatalog('tests/language/lexical/numeric/valid.jsonl', valid)
