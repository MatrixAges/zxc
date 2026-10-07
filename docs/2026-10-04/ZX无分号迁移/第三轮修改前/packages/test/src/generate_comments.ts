import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Case = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }

function program(output: string, body: string): string {
    return `export type Input = void

export type Output = ${output}

export default function (in: Input): Output {
${body}\n}\n`
}

const whitespace: Record<string, string> = {
    tab: '\t',
    vertical_tab: '\v',
    form_feed: '\f',
    space: ' ',
    nbsp: '\u00a0',
    line_feed: '\n',
    carriage_return: '\r',
    line_separator: '\u2028',
    paragraph_separator: '\u2029'
}
whitespace.combined = Object.values(whitespace).join('')
const rows: Array<Case> = []
const accepted: Array<[string, string]> = []

for (const [name, characters] of Object.entries(whitespace)) {
    const rejected = [...characters].find(character => character.charCodeAt(0) > 127)
    if (!rejected) accepted.push([name, characters])

    for (const context of ['unary', 'leading', 'interpolation']) {
        const expression = '-' + characters + '1'
        const source =
            context === 'leading'
                ? characters + program('i64', '  return -1\n')
                : program(
                      context === 'interpolation' ? 'string' : 'i64',
                      '  return ' + (context === 'interpolation' ? '`value=${' + expression + '}`' : expression) + ';'
                  )
        const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0
        rows.push({
            id: `language/lexical/whitespace/${name}/${context}`,
            source,
            phase: rejected ? 'parse' : 'analyze',
            diagnostic: rejected ? 'lexical' : null,
            ...(rejected ? { span: [start, start + 1] } : {})
        })
    }
}

const endings = { lf: '\n', cr: '\r', crlf: '\r\n', lfcr: '\n\r' }
const payloads = ['', '/', 'return missing\n', '/* not a block', '*/', '} ` ${ {', '中文🌱']

for (const [ending_name, ending] of Object.entries(endings)) {
    for (const [index, payload] of payloads.entries()) {
        for (const context of ['statement', 'interpolation']) {
            const body =
                context === 'statement'
                    ? `  //${payload}${ending}  return 7;`
                    : '  return `value=${//' + payload + ending + '7}`;'
            rows.push({
                id: `language/lexical/comments/line/${ending_name}/${index}/${context}`,
                source: program(context === 'statement' ? 'u64' : 'string', body),
                phase: 'analyze',
                diagnostic: null
            })
        }
    }
}

for (const [name, text] of Object.entries({
    triple_slash: '///',
    block_then_line: '/* var\n*///x*/',
    line_in_block: '/* var\n//x\n*/',
    block_in_line: '// var /* x */',
    extra_close_in_line: '// var /* x / = */ 1 */',
    blocks_in_lines: '// var /* \n// x \n// =\n// 1*/'
})) {
    rows.push({
        id: `language/lexical/comments/mixed/${name}`,
        source: text + '\n' + program('u64', '  return 7\n'),
        phase: 'analyze',
        diagnostic: null
    })
}

for (const context of ['statement', 'interpolation']) {
    const source =
        context === 'statement' ? program('u64', '  /*CHECK#1/') : program('string', '  return `value=${/*CHECK#1/7}`;')
    const start = source.indexOf('/*')
    rows.push({
        id: `language/lexical/comments/unterminated/${context}`,
        source,
        phase: 'parse',
        diagnostic: 'lexical',
        span: [start, Buffer.byteLength(source)]
    })
}

writeCatalog('tests/language/lexical/comments/cases.jsonl', rows)

const expressions = accepted.map(([name, gap]) => ({
    name: `whitespace/${name}`,
    expression: '-' + gap + '1',
    value: '-1'
}))
for (const [name, ending] of Object.entries(endings)) {
    expressions.push({
        name: `line/${name}/statement`,
        expression: '// ignored } ` /*' + ending + 'return "7"',
        value: '7'
    })
    expressions.push({
        name: `line/${name}/interpolation`,
        expression: '`value=${// ignored } ` /*' + ending + '7}`',
        value: 'value=7'
    })
}

const runtime_rows = expressions.map(({ name, value }, index) => ({
    id: `language/lexical/comments/runtime/${name}`,
    input: index,
    expected: { value }
}))
const branches = expressions
    .map(({ name, expression }, index) => {
        if (name.endsWith('/statement')) return `    case ${index}: ${expression};\n`

        return `    case ${index}: return ${name.endsWith('/interpolation') ? expression : '`${' + expression + '}`'};\n`
    })
    .join('')

writeCatalog('tests/language/lexical/comments/runtime.jsonl', runtime_rows)
writeOutput(
    'tests/language/lexical/comments/runtime.zx',
    'export type Input = u64\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  switch (in) {\n' +
        branches +
        '    default: return "";\n  }\n}\n'
)
