import type { Instruction } from './model.ts'

import assert from 'node:assert/strict'
import test from 'node:test'
import enumerate from './enumerate.ts'
import execute from './execute.ts'
import plan from './plan.ts'

const leaves = [['first'], ['second']]

function compare(program: Array<Instruction>): ReturnType<typeof plan> {
    const result = plan(program)
    const actual = execute({ program, reuse: result.reuse, leaves })
    const expected = execute({ program, reuse: [], leaves })

    assert.deepEqual(actual, expected, JSON.stringify(program))

    return result
}

test('dead view ends without a runtime copy', () => {
    const result = compare([
        { kind: 'own', id: 0, owned: true },
        { kind: 'borrow', id: 1, source: 0, path: ['first'] },
        { kind: 'read', source: 1 },
        { kind: 'update', id: 2, source: 0, path: ['first'] },
        { kind: 'read', source: 2 }
    ])

    assert.equal(result.reuse[3], true)
})

test('overlapping live view blocks reuse while a sibling does not', () => {
    for (const field of ['first', 'second']) {
        const result = compare([
            { kind: 'own', id: 0, owned: true },
            { kind: 'borrow', id: 1, source: 0, path: [field] },
            { kind: 'update', id: 2, source: 0, path: ['first'] },
            { kind: 'read', source: 1 },
            { kind: 'read', source: 2 }
        ])

        assert.equal(result.reuse[2], field === 'second')
    }
})

test('escaped views and borrowed owners preserve storage', () => {
    for (const owned of [false, true]) {
        const result = compare([
            { kind: 'own', id: 0, owned },
            { kind: 'borrow', id: 1, source: 0, path: ['first'] },
            { kind: 'escape', source: 1 },
            { kind: 'update', id: 2, source: 0, path: ['first'] },
            { kind: 'read', source: 2 }
        ])

        assert.equal(result.reuse[3], false)
    }
})

test('ending a parent loan preserves a live reborrow and frees only siblings', () => {
    for (const field of ['first', 'second']) {
        const result = compare([
            { kind: 'own', id: 0, owned: true },
            { kind: 'borrow', id: 1, source: 0, path: [] },
            { kind: 'borrow', id: 2, source: 1, path: ['first'] },
            { kind: 'read', source: 1 },
            { kind: 'update', id: 3, source: 0, path: [field] },
            { kind: 'read', source: 2 },
            { kind: 'read', source: 3 }
        ])

        assert.equal(result.reuse[4], field === 'second')
    }
})

test('the concrete oracle detects invalid reuse with a live view', () => {
    const program: Array<Instruction> = [
        { kind: 'own', id: 0, owned: true },
        { kind: 'borrow', id: 1, source: 0, path: ['first'] },
        { kind: 'update', id: 2, source: 0, path: ['first'] },
        { kind: 'read', source: 1 }
    ]

    assert.notDeepEqual(
        execute({ program, reuse: [false, false, true], leaves }),
        execute({ program, reuse: [], leaves })
    )
})

test('enumerated straight-line programs preserve concrete storage observations', () => {
    let checked = 0

    for (const owned of [true, false])
        enumerate({
            program: [{ kind: 'own', id: 0, owned }],
            objects: [true],
            remaining: 4,
            visit: program => {
                compare(program)
                checked += 1
            }
        })

    assert.ok(checked > 10_000)
    console.log(`Concrete observation comparisons: ${checked}`)
})
