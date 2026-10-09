import type { Spec } from '../models/map_projection.ts'
import inputs from './inputs.ts'

type Named = { name: string; spec: Spec }

export default function cases(operation: Spec['operation']): Array<Named> {
    const rows: Array<Named> = []

    for (const { name, items } of inputs) {
        if (operation === 'source_value') {
            for (const threshold of [-11, 0, 9, 10, 11, 65535])
                rows.push({ name: `${name}/threshold_${threshold}`, spec: { operation, input: { items, threshold } } })
        } else if (operation === 'records') {
            for (const first of [-11, 0, 65535])
                rows.push({ name: `${name}/first_${first}`, spec: { operation, input: { items, first } } })
        } else rows.push({ name, spec: { operation, input: { items } } })
    }

    return rows
}
