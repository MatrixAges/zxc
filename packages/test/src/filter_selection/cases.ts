import type { Spec } from '../models/filter_selection.ts'
import inputs from './inputs.ts'

export type Named = { name: string; spec: Spec }

export default function cases(operation: Spec['operation']): Array<Named> {
    const rows: Array<Named> = []

    for (const { name, items } of inputs) {
        const length = items.length

        if (operation === 'length') {
            for (const expected_length of new Set([0, 1, 2, length, length + 1, length + 17]))
                rows.push({
                    name: `${name}/length_${expected_length}`,
                    spec: { operation, input: { items, expected_length } }
                })
        } else if (operation === 'position') {
            const indices = length > 0 ? [...new Set([0, 1, length - 1, length, length + 17])] : [0]

            for (const selected_index of indices) {
                const values =
                    selected_index < length ? [...new Set([items[selected_index], items[selected_index] + 1, 0])] : [0]

                for (const selected_value of values)
                    rows.push({
                        name: `${name}/index_${selected_index}/value_${selected_value}`,
                        spec: { operation, input: { items, selected_index, selected_value } }
                    })
            }
        } else if (operation === 'source_value') {
            for (const threshold of [-11, 0, 9, 10, 11, 65535])
                rows.push({ name: `${name}/threshold_${threshold}`, spec: { operation, input: { items, threshold } } })
        } else if (operation === 'stride') {
            for (const period of length > 0 ? [1, 2, 3, 5] : [1]) {
                for (const phase of length > 0 ? [...new Set([0, period - 1, period, period + 1])] : [0])
                    rows.push({
                        name: `${name}/period_${period}/phase_${phase}`,
                        spec: { operation, input: { items, period, phase } }
                    })
            }
        } else {
            for (const first of [false, true])
                rows.push({ name: `${name}/first_${first}`, spec: { operation, input: { items, first } } })
        }
    }

    return rows
}
