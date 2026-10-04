import { writeCatalog } from './shared/catalog.ts'

const expressions: Array<[string, number, string]> = [
	["10", 1, "\"x\" < \"x\""],
	["10", 2, "\"x\" < \"\""],
	["10", 3, "\"abcd\" < \"ab\""],
	["10", 4, "\"abc\\u0064\" < \"abcd\""],
	["10", 5, "\"x\" + \"y\" < \"x\""],
	["10", 6, "x + \"y\" < x"],
	["11", 1, "\"x\" < \"x \""],
	["11", 2, "\"\" < \"x\""],
	["11", 3, "\"ab\" < \"abcd\""],
	["11", 4, "\"abcd\" < \"abc\\u0064\""],
	["11", 5, "\"x\" < \"x\" + \"y\""],
	["11", 6, "x < x + \"y\""],
	["11", 7, "\"a\\u0000\" < \"a\\u0000a\""],
	["11", 8, "\"x\" < \" x\""],
	["12_T1", 1, "\"xx\" < \"xy\""],
	["12_T1", 2, "\"xy\" < \"xx\""],
	["12_T1", 3, "\"x\" < \"y\""],
	["12_T1", 4, "\"aab\" < \"aba\""],
	["12_T1", 5, "\"\\u0061\\u0061\\u0061\\u0062\" < \"\\u0061\\u0061\\u0061\\u0061\""],
	["12_T1", 6, "\"a\\u0000a\" < \"a\\u0000b\""],
	["12_T1", 7, "\"aB\" < \"aa\""],
	["12_T1", 8, "\"\\uD7FF\" < \"\\u{10000}\""],
	["12_T1", 9, "\"\\uD800\" < \"\\uDC00\""],
	["12_T1", 10, "\"\\u{10000}\" < \"\\uFFFF\""],
	["12_T1", 11, "\"\\u{10000}\" < \"\\u{12345}\""],
	["12_T2", 1, "\"0\" < \"x\""],
	["12_T2", 2, "\"-\" < \"0\""],
	["12_T2", 3, "\".\" < \"0\""],
	["12_T2", 4, "\"+\" < \"-\""],
	["12_T2", 5, "\"-0\" < \"-1\""],
	["12_T2", 6, "\"+1\" < \"-1\""],
	["12_T2", 7, "\"1\" < \"1e-10\""],
]

const rows = expressions.map(([group, index, expression]) => {
	const escaped = expression.includes('\\u')

	return {
		id: `language/types/relational_strings/${group}/${index}`,
		source: `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  const x = "x";\n\n  return ${expression};\n}\n`,
		phase: escaped ? 'parse' : 'analyze',
		diagnostic: escaped ? 'lexical' : 'type_mismatch',
	}
})

for (const [name, left, right] of [['bmp_astral', '퟿', '𐀀'], ['astral_bmp', '𐀀', '￿'], ['astral_pair', '𐀀', '𒍅']]) {
	rows.push({
		id: `language/types/relational_strings/utf8/${name}`,
		source: `export type Input = void;\n\nexport type Output = bool;\n\nexport default function (in: Input): Output {\n  return "${left}" < "${right}";\n}\n`,
		phase: 'analyze',
		diagnostic: 'type_mismatch',
	})
}

writeCatalog('tests/language/types/relational_strings/cases.jsonl', rows)
