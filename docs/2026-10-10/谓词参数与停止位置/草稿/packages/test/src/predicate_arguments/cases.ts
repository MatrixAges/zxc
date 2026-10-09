import type { Method, Spec } from '../models/predicate_arguments.ts'
import expectation from '../models/predicate_arguments.ts'
import inputs from './inputs.ts'

type Named = Spec & { name: string }

export default function cases(args: { method: Method; operation: Spec['operation'] }): Array<Named> {
    const { method, operation } = args
    const seeds: Array<Named> = []

    for (const { name, items } of inputs) {
        if (operation === 'source_value') {
            for (const threshold of [-11, 0, 9, 10, 11, 65535])
                seeds.push({
                    name: `${name}/threshold_${threshold}`,
                    method,
                    operation,
                    input: { items, threshold },
                    probe: { failure: 0 }
                })
        } else {
            const length = items.length
            const indices = [...new Set([0, Math.floor(length / 2), Math.max(0, length - 1), length])]

            for (const selected_index of indices) {
                const values = selected_index < length ? [items[selected_index], items[selected_index] + 1] : [0]

                for (const selected_value of values)
                    seeds.push({
                        name: `${name}/index_${selected_index}/value_${selected_value}`,
                        method,
                        operation,
                        input: { items, selected_index, selected_value },
                        probe: { failure: 0 }
                    })
            }
        }
    }

    return seeds.flatMap(seed => {
        const calls = expectation(seed).calls
        const failures = calls === 0 ? [0] : [...new Set([0, 1, Math.ceil(calls / 2), calls, calls + 1])]

        return failures.map(failure => ({ ...seed, name: `${seed.name}/failure_${failure}`, probe: { failure } }))
    })
}
