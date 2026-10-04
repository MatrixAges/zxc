import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'

type Function = {
	file_name: string
	input_type: number
	output_type: number
	store_mode: string
	stores: Array<unknown>
}
type Export = { name: string; path: string; function: number | null; types: Array<{ name: string; type_id: number }> }
type Artifact = {
	program: { functions: Array<Function> }
	exports: Array<Export>
	store_initializers: Array<{ identity: string; schema_version: number; function: number }>
}

export default function openArtifact(path: string) {
	const bytes = readFileSync(path, 'utf8')
	const first = bytes.indexOf('\n')
	const second = bytes.indexOf('\n', first + 1)
	const marker = bytes.slice(0, first)
	const text = bytes.slice(second + 1)
	assert.equal(marker, 'zxc.library.v2')
	assert.equal(bytes.slice(first + 1, second), createHash('sha256').update(text).digest('hex'))
	const payload = JSON.parse(text) as Artifact

	function exposeTransaction(): void {
		const index = payload.program.functions.findIndex(
			value => value.store_mode === 'transaction' && value.stores.length > 0
		)
		assert.notEqual(index, -1)
		const value = payload.program.functions[index]
		payload.exports.push({
			name: './raw',
			path: value.file_name,
			function: index,
			types: [
				{ name: 'Input', type_id: value.input_type },
				{ name: 'Output', type_id: value.output_type }
			]
		})
	}

	function save(): void {
		const text = JSON.stringify(payload)
		const digest = createHash('sha256').update(text).digest('hex')
		writeFileSync(path, `${marker}\n${digest}\n${text}`)
	}

	return { payload, exposeTransaction, save }
}
