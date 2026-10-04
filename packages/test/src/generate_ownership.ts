import { writeCatalog } from './shared/catalog.ts'

const elements: Record<string, { type: string; value: string; reference: boolean }> = Object.fromEntries(
	['u8', 'u16', 'u32', 'u64', 'i32', 'i64', 'f32', 'f64'].map(name => [
		name,
		{ type: name, value: '1', reference: false }
	])
)
elements.bool = { type: 'bool', value: 'true', reference: false }
elements.string = { type: 'string', value: '"value"', reference: true }
elements.record = { type: '{ value: u64 }', value: '{ value: 1 }', reference: true }
elements.nested_list = { type: 'u64[]', value: '[1]', reference: true }
elements.nested_record = { type: '{ items: u64[] }', value: '{ items: [1] }', reference: true }

function program(element: string, body: string): string {
	return `export type Input = ${element}[]

export type Output = u64

export default function (in: Input): Output {
${body}\n}\n`
}

const propagation = []
const consumption = []

for (const [name, { type: element, value, reference }] of Object.entries(elements)) {
	for (const [argument, expression] of [
		['borrowed', 'in'],
		['constructed_owner', `[${value}]`],
		['empty', '[]']
	]) {
		for (const [operation, slot] of [
			['concat', 'next'],
			['splice', 'next'],
			['splice', 'removed'],
			['splice', 'both']
		]) {
			const call = operation === 'concat' ? `owned.concat(${expression})` : `owned.splice(0, 0, ${expression})`
			const second = operation === 'concat' ? '_' : 'removed'
			let body = `  const owned: ${element}[] = [${value}]
  const [next, ${second}] = ${call}
`

			body +=
				slot === 'both'
					? '  const [first, _] = next.reverse()\n  const [last, _] = removed.reverse()\n\n  return first.length + last.length\n'
					: `  const [reversed, _] = ${slot}.reverse()

  return reversed.length
`
			propagation.push({
				id: `ownership/propagation/${operation}/${name}/${argument}/${slot}`,
				source: program(element, body),
				phase: 'analyze',
				diagnostic: reference && argument === 'borrowed' ? 'ownership' : null
			})
		}
	}

	const operations: Record<string, string> = {
		push: 'push(in[0])',
		pop: 'pop()',
		reverse: 'reverse()',
		concat: 'concat([])',
		splice: 'splice(0, 0, [])'
	}
	if (!['bool', 'record', 'nested_list', 'nested_record'].includes(name)) operations.sort = 'sort()'

	for (const [operation, call] of Object.entries(operations)) {
		for (const state of ['borrowed', 'old_owner', 'constructed_owner']) {
			let body =
				state === 'borrowed'
					? '  const values = in\n'
					: `  const values: ${element}[] = [${value}]
`
			body += `\n  const [next, _] = values.${call}

`
			body += state === 'old_owner' ? '  return values.length\n' : '  return next.length\n'

			consumption.push({
				id: `ownership/consumption/${operation}/${name}/${state}`,
				source: program(element, body),
				phase: 'analyze',
				diagnostic: state === 'constructed_owner' ? null : 'ownership'
			})
		}

		if (['concat', 'splice'].includes(operation)) {
			const self_call = operation === 'concat' ? 'concat(values)' : 'splice(0, 0, values)'
			const body = `  const values: ${element}[] = [${value}]
  const [next, _] = values.${self_call}

  return next.length
`
			consumption.push({
				id: `ownership/consumption/${operation}/${name}/self_argument`,
				source: program(element, body),
				phase: 'analyze',
				diagnostic: 'ownership'
			})
		}
	}
}

writeCatalog('tests/ownership/propagation/cases.jsonl', propagation)
writeCatalog('tests/ownership/consumption/cases.jsonl', consumption)
