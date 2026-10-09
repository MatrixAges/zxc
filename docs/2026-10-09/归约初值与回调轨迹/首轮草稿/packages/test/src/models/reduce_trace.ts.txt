export type Mode = 'seeded' | 'unseeded'
export type Failure = 'none' | 'source' | 'seed' | 'callback'
export type Input = { items: Array<number>; seed: number }
export type Visit = {
    previous: number
    current: number
    index: number
    source_value: number
    source_length: number
}
export type Expected = {
    value?: number
    error?: string
    calls: number
    visits: Array<Visit>
    events: string
    source_calls: number
    seed_calls: number
}
export type Row = { id: string; input: Input; failure: Failure; fail_at: number; expected: Expected }
type Args = { mode: Mode; input: Input; failure: Failure; fail_at: number }

export default function expectation(args: Args): Expected {
    const { mode, input, failure, fail_at } = args
    const visits: Array<Visit> = []
    let events = ''
    let source_calls = 0
    let seed_calls = 0

    try {
        source_calls++
        events += 'S'

        if (failure === 'source') throw new Error('SourceFailure')

        function callback(previous: number, current: number, index: number, source: Array<number>): number {
            visits.push({ previous, current, index, source_value: source[index], source_length: source.length })
            events += 'V'

            if (failure === 'callback' && visits.length === fail_at) throw new Error('CallbackFailure')

            return current
        }

        function initial(): number {
            seed_calls++
            events += 'I'

            if (failure === 'seed') throw new Error('SeedFailure')

            return input.seed
        }

        const value = mode === 'seeded' ? input.items.reduce(callback, initial()) : input.items.reduce(callback)

        return { value, calls: visits.length, visits, events, source_calls, seed_calls }
    } catch (error) {
        if (error instanceof TypeError && mode === 'unseeded' && input.items.length === 0)
            return { error: 'IndexOutOfBounds', calls: visits.length, visits, events, source_calls, seed_calls }

        if (!(error instanceof Error) || !['SourceFailure', 'SeedFailure', 'CallbackFailure'].includes(error.message))
            throw error

        return { error: error.message, calls: visits.length, visits, events, source_calls, seed_calls }
    }
}
