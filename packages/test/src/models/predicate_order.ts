export type Method = 'every' | 'some'
export type Rule = 'cursor' | 'visited'
export type Spec = {
    method: Method
    rule: Rule
    input: { items: Array<number> }
    probe: { cursor: number }
}
export type Expected = {
    value: boolean
    calls: number
    cursor: number
    marked: Array<number>
    visits: Array<{ item: number; index: number }>
    events: Array<'source' | 'context' | 'visit'>
}
export type Row = Spec & { id: string; expected: Expected }

export default function expectation(spec: Spec): Expected {
    let last_index = spec.probe.cursor
    const visited: Array<number | undefined> = []
    const visits: Expected['visits'] = []
    const events: Expected['events'] = ['source']
    const callback = (item: number, index: number): boolean => {
        visits.push({ item, index })
        events.push('visit')

        if (spec.rule === 'cursor') {
            if (last_index !== index) return spec.method === 'some'

            last_index++

            return spec.method === 'every'
        }

        if (typeof visited[index] === 'undefined') {
            if (index !== 0 && typeof visited[index - 1] === 'undefined') return spec.method === 'some'

            visited[index] = 1

            return spec.method === 'every'
        }

        return spec.method === 'some'
    }
    const context = (): undefined => {
        events.push('context')

        return undefined
    }
    const value =
        spec.rule === 'visited'
            ? spec.input.items[spec.method](callback, context())
            : spec.input.items[spec.method](callback)

    return {
        value,
        calls: visits.length,
        cursor: last_index,
        marked: visited.flatMap((value, index) => (value === 1 ? [index] : [])),
        visits,
        events
    }
}
