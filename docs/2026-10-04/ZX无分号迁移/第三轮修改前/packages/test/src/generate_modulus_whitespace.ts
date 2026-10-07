import { writeCatalog, writeOutput } from './shared/catalog.ts'

type Frontend = { id: string; source: string; phase: string; diagnostic: string | null; span?: Array<number> }
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

const frontend: Array<Frontend> = []
const runtime = []
const branches: Array<string> = []

for (const [gap_name, gap] of Object.entries(whitespace)) {
    const rejected = [...gap].find(character => character.charCodeAt(0) > 127)

    for (const position of ['left', 'right', 'both']) {
        const left_gap = position === 'right' ? ' ' : gap
        const right_gap = position === 'left' ? ' ' : gap

        for (const scalar of ['number', 'mixed']) {
            const left = scalar === 'number' ? '1' : 'true'
            const source = `export type Input = void

export type Output = f64

export default function (in: Input): Output {
  return ${left}${left_gap}%${right_gap}1
}
`
            const start = rejected ? Buffer.byteLength(source.slice(0, source.indexOf(rejected))) : 0

            frontend.push({
                id: `language/types/modulus_whitespace/${gap_name}/${position}/${scalar}`,
                source,
                phase: rejected ? 'parse' : 'analyze',
                diagnostic: rejected ? 'lexical' : scalar === 'mixed' ? 'type_mismatch' : null,
                ...(rejected ? { span: [start, start + 1] } : {})
            })
        }

        if (rejected) continue

        const shape = branches.length

        branches.push(`    case ${shape}: return in.value${left_gap}%${right_gap}1;`)

        for (const value of [1, 0, 3]) {
            runtime.push({
                id: `language/expressions/modulus/whitespace/${gap_name}/${position}/${value}`,
                input: { shape, value },
                expected: { value: value % 1 }
            })
        }
    }
}

const base = 'tests/language/expressions/modulus/whitespace'

writeCatalog(base + '.jsonl', runtime)
writeOutput(
    base + '.zx',
    `export type Input = { shape: u64
 value: f64 }

export type Output = f64

export default function (in: Input): Output {
  switch (in.shape) {
${branches.join('\n')}
    default: return 0
  }
}
`
)
writeCatalog('tests/language/types/modulus_whitespace/cases.jsonl', frontend)
