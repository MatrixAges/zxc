import { writeCatalog, writeOutput } from './shared/catalog.ts'

const values = [null, 0, 1, 2]
const rows = values.flatMap((left, left_index) =>
    values.map((right, right_index) => ({
        id: `language/expressions/comparison/optional_enum/${left_index}/${right_index}`,
        input: { left, right },
        expected: {
            value: {
                equal: left === right,
                different: left !== right,
                left_none: left === null,
                right_none: right === null
            }
        }
    }))
)
const base = 'tests/language/expressions/comparison/optional_enum/cases'

writeCatalog(base + '.jsonl', rows)
writeOutput(
    base + '.zx',
    `export enum State { First, Second, Third }

export type Input = { left: u8?
 right: u8? }

export type Output = { equal: bool
 different: bool
 left_none: bool
 right_none: bool }

export default function (in: Input): Output {
    const left: State? = match {
        in.left == null => null,
        (in.left ?? 0) == 0 => State.First,
        (in.left ?? 0) == 1 => State.Second,
        _ => State.Third
    }

    const right: State? = match {
        in.right == null => null,
        (in.right ?? 0) == 0 => State.First,
        (in.right ?? 0) == 1 => State.Second,
        _ => State.Third
    }

  return { equal: left == right, different: left != right, left_none: left == null, right_none: null == right }
}
`
)

const frontend = []

for (const [name, operator] of [
    ['equal', '=='],
    ['not_equal', '!='],
    ['less', '<'],
    ['greater', '>'],
    ['less_equal', '<='],
    ['greater_equal', '>=']
]) {
    for (const identity of ['same', 'different']) {
        const right_type = identity === 'same' ? 'State' : 'Other'

        frontend.push({
            id: `language/types/optional_enum/${name}/${identity}`,
            source: `export enum State { First, Second, Third }

export enum Other { First, Second, Third }

export type Input = { left: State?
 right: ${right_type}? }

export type Output = bool

export default function (in: Input): Output {
  return in.left ${operator} in.right
}
`,
            phase: 'analyze',
            diagnostic: identity === 'same' && ['equal', 'not_equal'].includes(name) ? null : 'type_mismatch'
        })
    }
}

writeCatalog('tests/language/types/optional_enum/cases.jsonl', frontend)
