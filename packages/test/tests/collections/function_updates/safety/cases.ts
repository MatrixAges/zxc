export type Stage = 'source' | 'container' | 'index' | 'value' | 'after'
export type Operation = 'add' | 'subtract' | 'multiply' | 'divide' | 'remainder'
export type Case = {
    id: string
    left: bigint
    right: bigint
    outer: number
    inner: number
    selected: number
    failure: Stage | 'none'
    occurrence: number
    enabled: boolean
    empty: boolean
}

export const minimum = -(1n << 63n)
export const maximum = (1n << 63n) - 1n

export default function cases(operation: Operation): Array<Case> {
    const rows: Array<Case> = []
    const boundaries = [minimum, minimum + 1n, -7n, -1n, 0n, 1n, 7n, maximum - 1n, maximum]

    function add(id: string, options: Partial<Omit<Case, 'id'>>) {
        rows.push({
            id,
            left: 1n,
            right: 1n,
            outer: 1,
            inner: 1,
            selected: 0,
            failure: 'none',
            occurrence: 1,
            enabled: true,
            empty: false,
            ...options
        })
    }

    for (const left of boundaries) {
        for (const right of boundaries) add(`boundary/${left}/${right}`, { left, right })
    }

    const trap = {
        add: { left: maximum, right: 1n },
        subtract: { left: minimum, right: 1n },
        multiply: { left: minimum, right: -1n },
        divide: { left: minimum, right: -1n },
        remainder: { left: minimum, right: 0n }
    }[operation]

    for (const failure of ['source', 'container', 'index', 'value', 'after'] as const) {
        add(`trap/first-error/${failure}`, { ...trap, failure })
        add(`safe/later-error/${failure}`, { left: 0n, right: 1n, inner: 3, failure, occurrence: 2 })
    }

    add('trap/zero-outer', { ...trap, outer: 0 })
    add('trap/zero-inner', { ...trap, inner: 0 })
    add('trap/invalid-index', { ...trap, selected: 3 })
    add('trap/empty-list', { ...trap, empty: true })
    add('trap/invalid-parent', { ...trap, enabled: false })
    add('safe/repeated-negative', { left: -7n, right: -1n, outer: 2, inner: 3 })
    add('safe/last-index', { left: minimum, right: 1n, selected: 2 })

    if (operation === 'add') add('trap/second-round', { left: maximum - 1n, right: 1n, inner: 2 })
    if (operation === 'subtract') add('trap/second-round', { left: minimum + 1n, right: 1n, inner: 2 })
    if (operation === 'multiply') add('trap/second-round', { left: maximum / 2n, right: 2n, inner: 2 })
    const later_trap = {
        add: { left: maximum - 1n, right: 1n },
        subtract: { left: minimum + 1n, right: 1n },
        multiply: { left: maximum / 2n, right: 2n }
    }

    if (operation === 'add' || operation === 'subtract' || operation === 'multiply') {
        for (const failure of ['source', 'container', 'index', 'value', 'after'] as const) {
            add(`trap/later-error/${failure}`, { ...later_trap[operation], inner: 2, failure, occurrence: 2 })
        }
    }

    if (operation === 'divide') {
        add('trap/zero-divisor', { left: 1n, right: 0n })
        add('safe/minimum-divided-by-one', { left: minimum, right: 1n })
    }
    if (operation === 'remainder') add('safe/minimum-remainder-minus-one', { left: minimum, right: -1n })

    return rows
}
