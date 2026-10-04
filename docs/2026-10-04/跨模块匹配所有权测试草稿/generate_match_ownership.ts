import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'tests/language/expressions/match/ownership/'
const imports = 'import make from "./helpers/make.zx";\nimport other from "./helpers/other.zx";\n\n'

writeOutput(base + 'helpers/make.zx', 'export type Input = u64;\n\nexport type Output = u64[];\n\nexport default function (in: Input): Output {\n  return [in, in + 1, in + 2];\n}\n')
writeOutput(base + 'helpers/other.zx', 'export type Input = u64;\n\nexport type Output = u64[];\n\nexport default function (in: Input): Output {\n  return [in + 10, in + 20];\n}\n')
writeOutput(base + 'helpers/borrow.zx', 'export type Input = u64[];\n\nexport type Output = u64[];\n\nexport default function (in: Input): Output {\n  return in;\n}\n')
writeOutput(base + 'owned.zx', imports + 'export type Input = { choice: bool; value: u64; };\n\nexport type Output = u64[];\n\nexport default function (in: Input): Output {\n  const values = match in.choice { true => make(in.value), _ => other(in.value) };\n\n  const [next, _] = values.reverse();\n\n  return next;\n}\n')
writeOutput(base + 'mixed_read.zx', 'import make from "./helpers/make.zx";\nimport borrow from "./helpers/borrow.zx";\n\nexport type Input = { choice: bool; value: u64; items: u64[]; };\n\nexport type Output = u64[];\n\nexport default function (in: Input): Output {\n  return match in.choice { true => make(in.value), _ => borrow(in.items) };\n}\n')

const owned = []
const mixed = []

for (const choice of [false, true]) {
	for (const value of [0, 7, 100]) {
		owned.push({ id: `match_ownership/owned/${choice}/${value}`, input: { choice, value }, expected: { value: choice ? [value + 2, value + 1, value] : [value + 20, value + 10] } })

		for (const [index, items] of [[], [9], [7, 8, 9]].entries()) {
			mixed.push({ id: `match_ownership/mixed_read/${choice}/${value}/${index}`, input: { choice, value, items }, expected: { value: choice ? [value, value + 1, value + 2] : items } })
		}
	}
}

writeCatalog(base + 'owned.jsonl', owned)
writeCatalog(base + 'mixed_read.jsonl', mixed)
