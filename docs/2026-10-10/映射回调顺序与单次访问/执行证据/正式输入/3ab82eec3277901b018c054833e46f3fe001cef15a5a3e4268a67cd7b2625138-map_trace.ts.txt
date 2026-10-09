export type Probe = { rule: 'cursor' | 'violations'; cursor: number; failure: number }
export type Spec = { input: Array<number>; probe: Probe }
export type Expected = {
    value?: Array<boolean>
    error?: 'CallbackFailure'
    ordered: boolean
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
    let ordered = true
    const observed = { visits, input: spec.input, source_calls: 1 }

    try {
        const value = spec.input.map((item, index) => {
            visits.push({ item, index })

            if (spec.probe.failure !== 0 && visits.length === spec.probe.failure) throw failure

            if (spec.probe.rule === 'cursor') {
                if (index !== cursor) {
                    ordered = false

                    return false
                }

                cursor++

                return true
            }

            if (seen.has(index) || (index !== 0 && !seen.has(index - 1))) return true

            seen.add(index)

            return false
        })

        return { ...observed, ordered, calls: visits.length, value }
    } catch (error) {
        if (error !== failure) throw error

        return { ...observed, ordered, calls: visits.length, error: 'CallbackFailure' }
    }
}
