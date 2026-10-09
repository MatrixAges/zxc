export type Probe = { rule: 'cursor' | 'ordered' | 'violations'; cursor: number; failure: number }
export type Spec = { input: Array<number>; probe: Probe }
export type Expected = {
    value?: Array<number>
    error?: 'CallbackFailure'
    calls: number
    visits: Array<{ item: number; index: number }>
    input: Array<number>
    source_calls: number
}
export type Row = Spec & { id: string; expected: Expected }

export default function expectation(spec: Spec): Expected {
    const visits: Expected['visits'] = []
    const seen = new Set<number>()
    const failure = new Error('CallbackFailure')
    let cursor = spec.probe.cursor
    const observed = { visits, input: spec.input, source_calls: 1 }

    try {
        const value = spec.input.filter((item, index) => {
            visits.push({ item, index })

            if (spec.probe.failure !== 0 && visits.length === spec.probe.failure) throw failure

            if (spec.probe.rule === 'cursor') {
                if (index !== cursor) return false

                cursor++

                return true
            }

            if (seen.has(index) || (index !== 0 && !seen.has(index - 1))) return spec.probe.rule === 'violations'

            seen.add(index)

            return spec.probe.rule === 'ordered'
        })

        return { ...observed, calls: visits.length, value }
    } catch (error) {
        if (error !== failure) throw error

        return { ...observed, calls: visits.length, error: 'CallbackFailure' }
    }
}
