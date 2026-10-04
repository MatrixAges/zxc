import { writeCatalog } from './shared/catalog.ts'

const groups: Record<string, Array<string>> = {
  "T1.1": [
    "true + true",
    "new Boolean(true) + true",
    "true + new Boolean(true)",
    "new Boolean(true) + new Boolean(true)"
  ],
  "T1.2": [
    "1 + 1",
    "new Number(1) + 1",
    "1 + new Number(1)",
    "new Number(1) + new Number(1)"
  ],
  "T1.3": [
    "null + undefined",
    "undefined + null",
    "undefined + undefined",
    "null + null"
  ],
  "T2.1": [
    "true + 1",
    "1 + true",
    "new Boolean(true) + 1",
    "1 + new Boolean(true)",
    "true + new Number(1)",
    "new Number(1) + true",
    "new Boolean(true) + new Number(1)",
    "new Number(1) + new Boolean(true)"
  ],
  "T2.2": [
    "1 + null",
    "null + 1",
    "new Number(1) + null",
    "null + new Number(1)"
  ],
  "T2.3": [
    "1 + undefined",
    "undefined + 1",
    "new Number(1) + undefined",
    "undefined + new Number(1)"
  ],
  "T2.4": [
    "true + undefined",
    "undefined + true",
    "new Boolean(true) + undefined",
    "undefined + new Boolean(true)"
  ],
  "T2.5": [
    "true + null",
    "null + true",
    "new Boolean(true) + null",
    "null + new Boolean(true)"
  ]
}

const rows = []

for (const [group, expressions] of Object.entries(groups)) {
	for (const [index, expression] of expressions.entries()) {
		const syntax = expression.includes('new ')
		const diagnostic = syntax ? 'syntax' : expression.includes('undefined') && !expression.startsWith('null') ? 'name' : expression === '1 + 1' ? null : 'type_mismatch'

		rows.push({
			id: `language/types/addition_conversion/${group}/${index + 1}`,
			source: `export type Input = void;\n\nexport type Output = f64;\n\nexport default function (in: Input): Output {\n  return ${expression};\n}\n`,
			phase: syntax ? 'parse' : 'analyze',
			diagnostic,
		})
	}
}

writeCatalog('tests/language/types/addition_conversion/cases.jsonl', rows)
