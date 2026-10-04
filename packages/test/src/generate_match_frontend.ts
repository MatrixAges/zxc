import { writeCatalog } from './shared/catalog.ts'

const rows = []
const cases = [
	['missing_default', 'u64', 'match in { 1 => 2, }', 'parse', 'syntax'],
	['default_not_last', 'u64', 'match in { _ => 0, 1 => 2, }', 'parse', 'syntax'],
	['duplicate_default', 'u64', 'match in { _ => 0, _ => 1, }', 'parse', 'syntax'],
	['missing_comma', 'u64', 'match in { 1 => 2 _ => 0 }', 'parse', 'syntax'],
	['missing_arrow', 'u64', 'match in { 1 2, _ => 0 }', 'parse', 'syntax'],
	['numeric_condition', 'u64', 'match { in => 2, _ => 0 }', 'analyze', 'type_mismatch'],
	['string_pattern', 'u64', 'match in { "1" => 2, _ => 0 }', 'analyze', 'type_mismatch'],
	['optional_target', 'u64?', 'match in { null => 2, _ => 0 }', 'analyze', 'type_mismatch'],
	['object_target', '{ value: u64 }', 'match in { in => 2, _ => 0 }', 'analyze', 'type_mismatch'],
	['list_target', 'u64[]', 'match in { in => 2, _ => 0 }', 'analyze', 'type_mismatch'],
	['void_target', 'void', 'match in { in => 2, _ => 0 }', 'analyze', 'type_mismatch'],
	['mixed_results', 'u64', 'match in { 1 => true, _ => 0 }', 'analyze', 'type_mismatch'],
	['unreachable_unknown', 'u64', 'match { true => 2, false => unknown_name, _ => 0 }', 'analyze', 'name'],
	['default_only', 'u64', 'match { _ => 42 }', 'analyze', null],
	['trailing_comma', 'u64', 'match in { 1 => 2, _ => 0, }', 'analyze', null],
	['no_trailing_comma', 'u64', 'match in { 1 => 2, _ => 0 }', 'analyze', null],
] as const

for (const [name, input, expression, phase, diagnostic] of cases) {
	rows.push({ id: `language/expressions/match/frontend/${name}`, source: `export type Input = ${input}

export type Output = u64

export default function (in: Input): Output {
  return ${expression}
}
`, phase, diagnostic })
}

writeCatalog('tests/language/expressions/match/frontend.jsonl', rows)
