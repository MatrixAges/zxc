import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'

type Function = {
	body: Array<{ result?: number }>
	symbols: Array<{ name: string }>
	expressions: Array<{ value: { reference?: number; integer?: number } }>
	contracts: Array<{ kind: string }>
}
type Artifact = {
	exports: Array<{ name: string; function: number | null }>
	program: { functions: Array<Function> }
}

export default function breakIdentity(encoded: Buffer): Buffer {
	const [marker, original_digest, ...rest] = encoded.toString().split('\n')
	const text = rest.join('\n')
	assert.equal(marker, 'zxc.library.v2')
	assert.equal(original_digest, createHash('sha256').update(text).digest('hex'))
	const payload = JSON.parse(text) as Artifact
	const exported = payload.exports.find(entry => entry.name === '.')
	assert.ok(exported)
	assert.notEqual(exported.function, null)
	const fn = payload.program.functions[exported.function!]
	assert.ok(fn.contracts.some(contract => contract.kind === 'ensures'))
	assert.equal(fn.body.length, 1)
	const result = fn.body[0].result
	assert.notEqual(result, undefined)
	const expression = fn.expressions[result!]
	assert.notEqual(expression.value.reference, undefined)
	assert.equal(fn.symbols[expression.value.reference!].name, 'in')
	expression.value = { integer: 0 }
	const modified = JSON.stringify(payload)
	const digest = createHash('sha256').update(modified).digest('hex')
	assert.notEqual(digest, original_digest)

	return Buffer.from(`${marker}\n${digest}\n${modified}`)
}
