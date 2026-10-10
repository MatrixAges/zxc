import { writeCatalog, writeOutput } from './shared/catalog.ts'

const boolean_path = 'language/types/boolean/negation'
const null_path = 'language/types/null/binding'
const original = {
    strict_false: !false === true,
    abstract_false: !false == true,
    strict_true: !true === false,
    abstract_true: !true == false
}

writeOutput(
    `tests/${boolean_path}.zx`,
    `export type Input = bool

export type Output = {
  strict_false: bool
  abstract_false: bool
  strict_true: bool
  abstract_true: bool
  negated_input: bool
}

export default function (in: Input): Output {
  return {
    strict_false: !false == true,
    abstract_false: !false == true,
    strict_true: !true == false,
    abstract_true: !true == false,
    negated_input: !in,
  }
}
`
)
writeCatalog(
    `tests/${boolean_path}.jsonl`,
    [false, true].map(input => ({
        id: `${boolean_path}/${input ? 'true_control' : 'original'}`,
        input,
        expected: { value: { ...original, negated_input: !input } }
    }))
)

writeOutput(
    `tests/${null_path}.zx`,
    `export type Input = u64?

export type Output = u64?

export default function (in: Input): Output {
  const x: u64? = null

  return x
}
`
)
writeCatalog(`tests/${null_path}.jsonl`, [
    {
        id: `${null_path}/original_completion`,
        input: null,
        expected: { value: null }
    }
])
