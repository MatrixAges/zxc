import { writeCatalog } from './shared/catalog.ts'

const samples = [
	{
		name: 'true_literal',
		expression: 'true',
		input: 'void',
		output: 'bool',
		diagnostic: null
	},
	{
		name: 'false_literal',
		expression: 'false',
		input: 'void',
		output: 'bool',
		diagnostic: null
	},
	{
		name: 'boolean_true',
		expression: 'Boolean(true)',
		input: 'void',
		output: 'bool',
		diagnostic: 'name'
	},
	{
		name: 'boolean_false',
		expression: 'Boolean(false)',
		input: 'void',
		output: 'bool',
		diagnostic: 'name'
	},
	{
		name: 'null_equal',
		expression: 'null == null',
		input: 'void',
		output: 'bool',
		diagnostic: 'type_mismatch'
	},
	{
		name: 'null_different',
		expression: 'null != null',
		input: 'void',
		output: 'bool',
		diagnostic: 'type_mismatch'
	},
	{
		name: 'null_regex',
		expression: 'RegExp("0").exec("1") == null',
		input: 'void',
		output: 'bool',
		diagnostic: 'name'
	},
	{
		name: 'escaped_true',
		expression: 'tru\\u{65}',
		input: 'void',
		output: 'bool',
		diagnostic: 'lexical'
	},
	{
		name: 'escaped_false',
		expression: 'f\\u{61}lse',
		input: 'void',
		output: 'bool',
		diagnostic: 'lexical'
	},
	{
		name: 'escaped_null',
		expression: 'n\\u{75}ll',
		input: 'void',
		output: 'bool',
		diagnostic: 'lexical'
	},
	{
		name: 'typed_null',
		expression: 'null',
		input: 'void',
		output: 'u64?',
		diagnostic: null
	},
	{
		name: 'typed_null_comparison',
		expression: 'in == null',
		input: 'u64?',
		output: 'bool',
		diagnostic: null
	},
	{
		name: 'escaped_member',
		expression: 'in.va\\u{6c}ue',
		input: '{ value: bool }',
		output: 'bool',
		diagnostic: 'lexical'
	},
	{
		name: 'plain_member',
		expression: 'in.value',
		input: '{ value: bool }',
		output: 'bool',
		diagnostic: null
	}
]

const cases = samples.map(sample => {
	const source = `export type Input = ${sample.input}

export type Output = ${sample.output}

export default function (in: Input): Output {
  return ${sample.expression}
}
`
	const offset = source.indexOf('\\')

	return {
		id: 'language/lexical/primitive_literals/' + sample.name,
		source,
		phase: sample.diagnostic === 'lexical' ? 'parse' : 'analyze',
		diagnostic: sample.diagnostic,
		...(sample.diagnostic === 'lexical' ? { span: [offset, offset + 1] } : {})
	}
})

writeCatalog('tests/language/lexical/primitive_literals/cases.jsonl', cases)
