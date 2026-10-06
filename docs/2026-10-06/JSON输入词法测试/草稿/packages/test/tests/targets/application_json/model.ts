import type { Json } from '../../../src/shared/json.ts'

export type Target = 'native' | 'wasm32-freestanding' | 'wasm32-wasi'

export type Case = {
	id: string
	json_text: string
	expected: { value: Json } | { error: string }
}

export type Response = {
	status: number
	output: string
	stderr: string
}

export type Command = {
	command: string
	argv: Array<string>
	status: number | null
	signal: NodeJS.Signals | null
	error: string | null
	stdout: string
	stderr: string
}

export type Observation = {
	id: string
	target: Target
	input_utf8_hex: string
} & ({ executed: false; reason: string } | { executed: true; response: Response; passed: boolean })
