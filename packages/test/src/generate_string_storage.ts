import { writeCatalog, writeOutput } from './shared/catalog.ts'

const values = [null, '', 'same', 'other', '中文', 'a\u0000b', 'a\u0000c', 'a']
const rows = values.flatMap((left, left_index) => values.map((right, right_index) => ({
	id: `language/expressions/comparison/string_storage/${left_index}/${right_index}`,
	input: { left, right },
	expected: { value: {
		optional_equal: left === right,
		optional_different: left !== right,
		plain_equal: (left ?? '') === (right ?? ''),
		plain_different: (left ?? '') !== (right ?? ''),
	} },
})))
const base = 'tests/language/expressions/comparison/string_storage/cases'

writeCatalog(base + '.jsonl', rows)
writeOutput(base + '.zx', `export type Input = { left: string?
 right: string? }

export type Output = { optional_equal: bool
 optional_different: bool
 plain_equal: bool
 plain_different: bool }

export default function (in: Input): Output {
  const left = in.left ?? ""
  const right = in.right ?? ""

  return { optional_equal: in.left == in.right, optional_different: in.left != in.right, plain_equal: left == right, plain_different: left != right }
}
`)
