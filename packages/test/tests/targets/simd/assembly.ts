import assert from 'node:assert/strict'

export default function checkAssembly(args: { assembly: string; type: string; cpu: string }): void {
	const { assembly, type, cpu } = args
	const file = assembly.match(/^\s*\.file\s+(\d+)\s+"[^"\n]*"\s+"program\.zig"/m)?.[1]

	assert.ok(file, 'Generated program source is missing from WASM debug locations')

	let current_file: string | undefined
	const instructions: Array<string> = []

	for (const line of assembly.split('\n')) {
		const location = line.match(/^\s*\.loc\s+(\d+)\s/)

		if (location) current_file = location[1]
		if (current_file === file && /^\s*f(?:32|64)(?:x[24])?\.(?:add|sub|mul|div)\b/.test(line))
			instructions.push(line.trim())
	}

	assert.notEqual(instructions.length, 0, 'Generated program has no attributed floating-point arithmetic')

	if (cpu === 'baseline+simd128') assert.ok(instructions.includes(`${type}x${type === 'f32' ? 4 : 2}.mul`))
	else assert.ok(instructions.every(instruction => !/f(?:32x4|64x2)\./.test(instruction)))
}
