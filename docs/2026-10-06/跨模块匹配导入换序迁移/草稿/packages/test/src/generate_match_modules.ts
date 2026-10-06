import { writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'tests/language/expressions/match/modules/'
const imports =
	'import choose from "./nested/choose"\nimport { State } from "./types"\n\nimport type { Code } from "./types"\n\n'
const header = 'export type Input = Code\n\nexport type Output = u64\n\n'
const body =
	'export default function (in: Input): Output {\n  return match choose(in) { State.First => 11, State.Second => 22, _ => 33 }\n}\n'

writeOutput(base + 'types.zx', 'export enum State { First, Second, Third }\n\nexport type Code = u8\n')
writeOutput(
	base + 'nested/choose.zx',
	'import { State } from "../types"\n\nimport type { Code } from "../types"\n\nexport type Input = Code\n\nexport type Output = State\n\nexport default function (in: Input): Output {\n  return in == 0 ? State.First : in == 1 ? State.Second : State.Third\n}\n'
)
writeOutput(
	base + 'nested/pattern.zx',
	'import { State } from "../types"\n\nexport type Input = u8\n\nexport type Output = State\n\nexport default function (in: Input): Output {\n  return State.Second\n}\n'
)
writeOutput(
	base + 'nested/probe.zx',
	'import { State } from "../types"\n\nexport type Input = u64[]\n\nexport type Output = State\n\nexport default function (in: Input): Output {\n  return in[0] == 0 ? State.First : in[0] == 1 ? State.Second : State.Third\n}\n'
)

for (const name of ['canonical', 'reordered']) {
	writeOutput(base + name + '.zx', imports + header + body)
	writeCatalog(
		base + name + '.jsonl',
		[0, 1, 2, 255].map(input => ({
			id: `match_modules/${name}/${input}`,
			input,
			expected: { value: input === 0 ? 11 : input === 1 ? 22 : 33 }
		}))
	)
}

writeOutput(
	base + 'shared_pattern.zx',
	imports.replace('import { State }', 'import pattern from "./nested/pattern"\nimport { State }') +
		header +
		'export default function (in: Input): Output {\n  return match choose(in) { pattern(in) => 22, _ => 33 }\n}\n'
)
writeCatalog(
	base + 'shared_pattern.jsonl',
	[0, 1, 2, 255].map(input => ({
		id: `match_modules/shared_pattern/${input}`,
		input,
		expected: { value: input === 1 ? 22 : 33 }
	}))
)
writeOutput(
	base + 'lazy.zx',
	imports.replace('import { State }', 'import probe from "./nested/probe"\nimport { State }') +
		'export type Input = { state: Code\n items: u64[] }\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return match choose(in.state) { State.First => 11, probe(in.items) => 22, _ => 33 }\n}\n'
)
writeCatalog(base + 'lazy.jsonl', [
	{ id: 'match_modules/lazy/skipped_empty', input: { state: 0, items: [] }, expected: { value: 11 } },
	{
		id: 'match_modules/lazy/required_empty',
		input: { state: 1, items: [] },
		expected: { error: 'IndexOutOfBounds' }
	},
	{ id: 'match_modules/lazy/second_match', input: { state: 1, items: [1] }, expected: { value: 22 } },
	{ id: 'match_modules/lazy/fallback', input: { state: 2, items: [1] }, expected: { value: 33 } },
	{ id: 'match_modules/lazy/third_match', input: { state: 2, items: [2] }, expected: { value: 22 } },
	{ id: 'match_modules/lazy/first_mismatch', input: { state: 1, items: [0] }, expected: { value: 33 } }
])
