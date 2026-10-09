import type { Json } from '../shared/json.ts'

export type Spec =
    | { operation: 'concat'; seeded: boolean; items: Array<string>; seed: string }
    | { operation: 'sum'; seeded: boolean; items: Array<number>; seed: number }
    | { operation: 'constant'; items: Array<number>; returned: number }

export type Expected = { value: Json } | { error: 'IndexOutOfBounds' }

export default function expectation(spec: Spec): Expected {
    try {
        if (spec.operation === 'constant')
            return { value: { value: spec.items.reduce(() => spec.returned), items: spec.items } }

        if (spec.operation === 'concat') {
            const concat = (previous: string, current: string) => previous + current

            return { value: spec.seeded ? spec.items.reduce(concat, spec.seed) : spec.items.reduce(concat) }
        }

        const sum = (previous: number, current: number) => previous + current

        return { value: spec.seeded ? spec.items.reduce(sum, spec.seed) : spec.items.reduce(sum) }
    } catch (error) {
        const missing_initial = spec.operation === 'constant' || !spec.seeded

        if (error instanceof TypeError && spec.items.length === 0 && missing_initial)
            return { error: 'IndexOutOfBounds' }

        throw error
    }
}
