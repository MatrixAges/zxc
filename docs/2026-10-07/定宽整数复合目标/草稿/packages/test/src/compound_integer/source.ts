export type Target = 'scalar' | 'nested' | 'list'

export default function sourceProgram(args: { scalar: string; target: Target }): string {
    const { scalar, target } = args
    const destination = { scalar: 'state.scalar', nested: 'state.box.value', list: 'state.values[state.selected]' }[
        target
    ]

    return `export type Input = { operation: u8, left: ${scalar}, right: ${scalar}, rounds: u8, selected: u64, values: ${scalar}[] }

export type Output = { scalar: ${scalar}, field: ${scalar}, values: ${scalar}[], original: ${scalar}[], mirror: ${scalar}[], rounds: u8 }

export default function (in: Input): Output {
    const round: u8 = 0
    const initial = { scalar: in.left, box: { value: in.left }, values: in.values, mirror: in.values, right: in.right, round, operation: in.operation, selected: in.selected, count: in.rounds }

    const result = loop(initial, {
        while: state => state.round < state.count,
        next: state => {
            switch (state.operation) {
                case 0: ${destination} += state.right
                case 1: ${destination} -= state.right
                case 2: ${destination} *= state.right
                case 3: ${destination} /= state.right
                case 4: ${destination} %= state.right
            }

            state.round += 1
        }
    })

    return { scalar: result.scalar, field: result.box.value, values: result.values, original: in.values, mirror: result.mirror, rounds: result.round }
}
`
}
