import assert from 'node:assert/strict'

export default function checkAssembly(args: { assembly: string; type: string; cpu: string }): void {
    const { assembly, type, cpu } = args
    const functions = new Map<string, { instructions: Array<string>; calls: Array<string> }>()
    const aliases = new Map<string, string>()
    let current: { instructions: Array<string>; calls: Array<string> } | undefined

    for (const line of assembly.split('\n')) {
        const alias = line.match(/^([^\s=]+)\s*=\s*([^\s]+)\s*$/)

        if (alias) aliases.set(alias[1], alias[2])

        const declaration = line.match(/^\s*\.type\s+([^,\s]+),\s*@function/)

        if (declaration) {
            current = { instructions: [], calls: [] }
            functions.set(declaration[1], current)
        }

        if (!current) continue

        if (/^\s*f(?:32|64)(?:x[24])?\.(?:add|sub|mul|div)\b/.test(line)) current.instructions.push(line.trim())

        const call = line.match(/^\s*(?:return_)?call\s+([^\s,]+)/)

        if (call) current.calls.push(call[1])
        if (/^\s*end_function\b/.test(line)) current = undefined
    }

    const pending = ['zxc_execute']
    const visited = new Set<string>()
    const instructions: Array<string> = []

    assert.ok(
        functions.has(aliases.get('zxc_execute') ?? 'zxc_execute'),
        'WASM application entry is missing from assembly'
    )

    while (pending.length !== 0) {
        const name = pending.pop()!

        if (visited.has(name)) continue

        visited.add(name)

        const target = aliases.get(name)

        if (target) {
            pending.push(target)
            continue
        }

        const body = functions.get(name)

        if (!body) continue

        instructions.push(...body.instructions)
        pending.push(...body.calls)
    }

    assert.notEqual(instructions.length, 0, 'WASM application has no floating-point arithmetic')

    if (cpu === 'baseline+simd128') assert.ok(instructions.includes(`${type}x${type === 'f32' ? 4 : 2}.mul`))
    else assert.ok(instructions.every(instruction => !/f(?:32x4|64x2)\./.test(instruction)))
}
