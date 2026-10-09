type Items = { items: Array<number> }
export type Spec =
    | { operation: 'length'; input: Items & { expected_length: number } }
    | { operation: 'position'; input: Items & { selected_index: number; selected_value: number } }
    | { operation: 'source_value'; input: Items & { threshold: number } }
    | { operation: 'stride'; input: Items & { period: number; phase: number } }
    | { operation: 'neighbors'; input: Items & { first: boolean } }

export default function expectation(spec: Spec) {
    const selected = spec.input.items.filter((item, index, source) => {
        if (spec.operation === 'length') return source.length === spec.input.expected_length
        if (spec.operation === 'position')
            return index === spec.input.selected_index && item === spec.input.selected_value
        if (spec.operation === 'source_value') return item > spec.input.threshold && source[index] === item
        if (spec.operation === 'stride') return index % spec.input.period === spec.input.phase && source[index] === item

        return index === 0 ? spec.input.first : item > source[index - 1]
    })

    return { value: { selected, items: spec.input.items } }
}
