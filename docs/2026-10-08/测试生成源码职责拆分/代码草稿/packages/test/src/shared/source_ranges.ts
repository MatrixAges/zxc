export default function sourceRanges(args: { indices: Array<number>; selector: string }): string {
    const { indices, selector } = args
    const spans: Array<{ first: number; last: number }> = []

    for (const index of indices) {
        const previous = spans.at(-1)

        if (previous && previous.last + 1 === index) {
            previous.last = index
        } else {
            spans.push({ first: index, last: index })
        }
    }

    return spans
        .map(span =>
            span.first === span.last
                ? `${selector} == ${span.first}`
                : `(${selector} >= ${span.first} && ${selector} <= ${span.last})`
        )
        .join(' || ')
}
