export type Method = 'every' | 'some'
export type Probe = { failure: number }
type Items = { items: Array<number> }
export type Spec = { method: Method; probe: Probe } & (
    | { operation: 'source_value'; input: Items & { threshold: number } }
    | { operation: 'position'; input: Items & { selected_index: number; selected_value: number } }
)
export type Expected = {
    value?: boolean
    error?: 'CallbackFailure'
    calls: number
    visits: Array<{ item: number; index: number }>
    input: Spec['input']
    source_calls: number
}
export type Row = Spec & { id: string; expected: Expected }

export default function expectation(spec: Spec): Expected {
    const visits: Expected['visits'] = []
    const failure = new Error('CallbackFailure')
    const observed = { visits, input: spec.input, source_calls: 1 }

    try {
        const value = spec.input.items[spec.method]((item, index, source) => {
            visits.push({ item, index })

            if (spec.probe.failure !== 0 && visits.length === spec.probe.failure) throw failure
            if (spec.operation === 'source_value') return item > spec.input.threshold && source[index] === item

            const selected = index === spec.input.selected_index
            const matches = item === spec.input.selected_value

            return (spec.method === 'some' ? selected && matches : !selected || matches) && source[index] === item
        })

        return { ...observed, calls: visits.length, value }
    } catch (error) {
        if (error !== failure) throw error

        return { ...observed, calls: visits.length, error: 'CallbackFailure' }
    }
}
