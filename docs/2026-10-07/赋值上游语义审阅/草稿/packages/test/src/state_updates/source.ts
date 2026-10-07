export default function sourceProgram(args: { operator: string; scalar: string; initialized: boolean }): string {
    const { operator, scalar, initialized } = args
    const initial_field = initialized
        ? `initialized: ${scalar}
    `
        : ''
    const initial_value = initialized ? 'initialized: initialized, ' : ''
    const initial_capture = initialized ? '\n    const initialized = initial.scalar' : ''
    const input_flag = initialized ? ', assign_first: bool' : ''
    const state_fields = initialized ? ', left: in.left, assign_first: in.assign_first' : ''
    const prior_assignment = initialized
        ? `            if (state.assign_first) {
                state.scalar = state.left
                state.box.value = state.left
                state.values[0] = state.left
            }

`
        : ''

    return `export type Input = { left: ${scalar}, right: ${scalar}${input_flag} }

export type Output = { ${initial_field}scalar: ${scalar}, field: ${scalar}, element: ${scalar} }

export default function (in: Input): Output {
    const initial = { scalar: in.left, box: { value: in.left }, values: [in.left], right: in.right, round: 0${state_fields} }${initial_capture}

    const result = loop(initial, {
        while: state => state.round < 1,
        next: state => {
${prior_assignment}            state.scalar ${operator} state.right
            state.box.value ${operator} state.right
            state.values[0] ${operator} state.right

            state.round += 1
        }
    })

    return { ${initial_value}scalar: result.scalar, field: result.box.value, element: result.values[0] }
}
`
}
