import { writeCatalog, writeOutput } from './shared/catalog.ts'

const groups: Record<string, Array<string>> = {
    'T1.1': [
        '"1" + "1"',
        'new String("1") + "1"',
        '"1" + new String("1")',
        'new String("1") + new String("1")',
        '"x" + "1"',
        '"1" + "x"'
    ],
    'T1.2': [
        '({} + function(){return 1})',
        '(function(){return 1} + {})',
        '(function(){return 1} + function(){return 1})',
        '({} + {})'
    ],
    'T2.1': [
        '"1" + 1',
        '1 + "1"',
        'new String("1") + 1',
        '1 + new String("1")',
        '"1" + new Number(1)',
        'new Number(1) + "1"',
        'new String("1") + new Number(1)',
        'new Number(1) + new String("1")',
        '"x" + 1',
        '1 + "x"'
    ],
    'T2.2': [
        'true + "1"',
        '"1" + true',
        'new Boolean(true) + "1"',
        '"1" + new Boolean(true)',
        'true + new String("1")',
        'new String("1") + true',
        'new Boolean(true) + new String("1")',
        'new String("1") + new Boolean(true)'
    ],
    'T2.3': ['"1" + undefined', 'undefined + "1"', 'new String("1") + undefined', 'undefined + new String("1")'],
    'T2.4': ['"1" + null', 'null + "1"', 'new String("1") + null', 'null + new String("1")']
}

const rows = []

for (const [group, expressions] of Object.entries(groups)) {
    for (const [index, expression] of expressions.entries()) {
        const syntax = expression.includes('new ') || expression.includes('function')

        rows.push({
            id: `language/types/addition_strings/${group}/${index + 1}`,
            source: `export type Input = void

export type Output = string

export default function (in: Input): Output {
  return ${expression}
}
`,
            phase: syntax ? 'parse' : 'analyze',
            diagnostic: syntax ? 'syntax' : expression.includes('undefined') ? 'name' : 'type_mismatch'
        })
    }
}

writeCatalog('tests/language/types/addition_strings/cases.jsonl', rows)

const pairs = [
    ['1', '1'],
    ['x', '1'],
    ['1', 'x'],
    ['', ''],
    ['', 'tail'],
    ['head', ''],
    ['中', '文'],
    ['🌱', '🍃'],
    ['e', '\u0301'],
    ['lego', '']
]
const base = 'tests/language/expressions/addition/explicit_strings'

writeCatalog(
    base + '.jsonl',
    pairs.map(([left, right], index) => ({
        id: `language/expressions/addition/explicit_strings/${index + 1}`,
        input: { left, right },
        expected: { value: left + right }
    }))
)
writeOutput(
    base + '.zx',
    'export type Input = { left: string\n right: string }\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return `${in.left}${in.right}`\n}\n'
)
