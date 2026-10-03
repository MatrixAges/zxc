import { writeCatalog } from './shared/catalog.ts'

const elements: Record<string, [string, boolean]> = Object.fromEntries(
	['u8', 'u16', 'u32', 'u64', 'i32', 'i64', 'f32', 'f64', 'bool', 'string'].map(name => [name, [name, false]])
)
elements.record = ['{ value: u64; }', false]
elements.nested_list = ['u64[]', true]
elements.nested_record = ['{ items: u64[]; }', true]

function program(element: string, body: string): string {
	return `export type Input = ${element}[];\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n${body}\n}\n`
}

const propagation = []
const consumption = []

for (const [name, [element, nested]] of Object.entries(elements)) {
	for (const [argument, expression] of [
		['borrowed', 'in'],
		['cloned', 'in.clone()'],
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
			let body = `  const owned = in.clone();\n  const [next, ${second}] = ${call};\n`

			body +=
				slot === 'both'
					? '  const [first, _] = next.reverse();\n  const [last, _] = removed.reverse();\n\n  return first.length + last.length;'
					: `  const [reversed, _] = ${slot}.reverse();\n\n  return reversed.length;`
			propagation.push({
				id: `ownership/propagation/${operation}/${name}/${argument}/${slot}`,
				source: program(element, body),
				phase: 'analyze',
				diagnostic: nested && argument === 'borrowed' ? 'ownership' : null
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
		for (const state of ['borrowed', 'old_owner', 'cloned']) {
			let body = state === 'borrowed' ? '  const values = in;' : '  const values = in.clone();'
			body += `\n  const [next, _] = values.${call};\n\n`
			body += state === 'old_owner' ? '  return values.length;' : '  return next.length;'

			consumption.push({
				id: `ownership/consumption/${operation}/${name}/${state}`,
				source: program(element, body),
				phase: 'analyze',
				diagnostic: state === 'cloned' ? null : 'ownership'
			})
		}

		if (['concat', 'splice'].includes(operation)) {
			const self_call = operation === 'concat' ? 'concat(values)' : 'splice(0, 0, values)'
			const body = `  const values = in.clone();\n  const [next, _] = values.${self_call};\n\n  return next.length;`
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
