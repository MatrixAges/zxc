export type Input = { items: Array<number>; index: number; count: number; replacement: Array<number>; value: number }

export type Operation = 'reverse' | 'sort' | 'splice' | 'with'

export type Row = {
    id: string
    input: Input
    later: Input
    check: 'values' | 'allocations'
    expected: {
        value: Array<number>
        later: Array<number>
        unchanged: boolean
        new_storage: boolean
        later_new_storage: boolean
    }
}

export default function expectation(operation: Operation, input: Input): Array<number> {
    const { items, index, count, replacement, value } = input

    switch (operation) {
        case 'reverse':
            return items.toReversed()
        case 'sort':
            return items.toSorted((left, right) => left - right)
        case 'splice':
            return items.toSpliced(index, count, ...replacement)
        case 'with':
            return items.with(index, value)
    }
}
