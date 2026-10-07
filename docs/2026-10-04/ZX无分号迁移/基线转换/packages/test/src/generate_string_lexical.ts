import { range, writeCatalog } from './shared/catalog.ts'

const prefix =
    'export type Input = void\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return '

function source(literal: string, context: string): string {
    const expression = context === 'return' ? literal : '`prefix${' + literal + '}suffix`'

    return prefix + expression + ';\n}\n'
}

const escapes = {
    ...Object.fromEntries(range(10).map(digit => [`digit_${digit}`, '\\' + digit])),
    zero_eight: '\\08',
    octal_052: '\\052',
    unicode_empty: '\\u',
    unicode_separator: '\\u{1F_639}',
    hex_empty: '\\x',
    identity_q: '\\q'
}
const strings = []

for (const context of ['return', 'interpolation']) {
    for (const [name, escape] of Object.entries(escapes)) {
        const text = source('"' + escape + '"', context)
        const start = text.indexOf('\\')
        strings.push({
            id: `language/lexical/string/escape/${context}/${name}`,
            source: text,
            phase: 'parse',
            diagnostic: 'lexical',
            span: [start, start + 2]
        })
    }

    for (const byte of range(32)) {
        const text = source('"' + String.fromCharCode(byte) + '"', context)
        const start = text.indexOf('"')
        strings.push({
            id: `language/lexical/string/control/${context}/${byte.toString(16).padStart(2, '0')}`,
            source: text,
            phase: 'parse',
            diagnostic: 'lexical',
            span: [start, start + 2]
        })
    }

    for (const [name, escape] of Object.entries({
        newline: '\\n',
        return: '\\r',
        tab: '\\t',
        quote: '\\"',
        backslash: '\\\\'
    })) {
        strings.push({
            id: `language/lexical/string/valid/${context}/${name}`,
            source: source('"' + escape + '"', context),
            phase: 'analyze',
            diagnostic: null
        })
    }
}

for (const [name, literal] of [
    ['plain', '"abc'],
    ['backslash', '"abc\\']
]) {
    const text = prefix + literal
    strings.push({
        id: `language/lexical/string/unterminated/${name}`,
        source: text,
        phase: 'parse',
        diagnostic: 'lexical',
        span: [prefix.length, text.length]
    })
}

const invalid = [
    '80',
    'bf',
    'c0af',
    'c1bf',
    'e080af',
    'f08080af',
    'eda080',
    'edbfbf',
    'f4908080',
    'f5808080',
    'ff',
    'c2',
    'e282',
    'f09f92'
]
const valid = ['c280', 'dfbf', 'e0a080', 'ed9fbf', 'ee8080', 'f0908080', 'f48fbfbf']
const utf8 = []

for (const accepted of [false, true]) {
    for (const sequence of accepted ? valid : invalid) {
        const payload = Buffer.from(sequence, 'hex')

        for (const context of ['string', 'comment']) {
            const data =
                context === 'string'
                    ? Buffer.concat([Buffer.from(prefix + '"'), payload, Buffer.from('";\n}\n')])
                    : Buffer.concat([Buffer.from('// '), payload, Buffer.from('\n' + source('"ok"', 'return'))])
            const row = {
                id: `language/lexical/utf8/${context}/${sequence}`,
                source_hex: data.toString('hex'),
                phase: accepted ? 'analyze' : 'parse',
                diagnostic: accepted ? null : 'lexical',
                ...(!accepted ? { span: [0, data.length] } : {})
            }
            utf8.push(row)
        }
    }
}

writeCatalog('tests/language/lexical/string/cases.jsonl', strings)
writeCatalog('tests/language/lexical/utf8/cases.jsonl', utf8)
