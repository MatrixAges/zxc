export type Target = 'scalar' | 'field' | 'element'
export type Gaps = { left: string; right: string }

const destinations = { scalar: 'state.scalar', field: 'state.box.value', element: 'state.values[0]' }

function updates(args: { operator: string; gaps: Gaps; target?: Target }): string {
    const { operator, gaps, target } = args

    return Object.entries(destinations)
        .map(([name, destination]) => {
            const selected = target === undefined || name === target

            return `                    ${destination}${selected ? gaps.left : ' '}${operator}${selected ? gaps.right : ' '}state.right`
        })
        .join('\n')
}

function program(args: { body: string; mixed: boolean; selector: boolean }): string {
    const { body, mixed, selector } = args

    return `export type Input = { left: f64, right: ${mixed ? 'bool' : 'f64'}${selector ? ', shape: u8' : ''} }

export type Output = { scalar: f64, field: f64, element: f64 }

export default function (in: Input): Output {
    const initial = { scalar: in.left, box: { value: in.left }, values: [in.left], right: in.right, round: 0${selector ? ', shape: in.shape' : ''} }

    const result = loop(initial, {
        while: state => state.round < 1,
        next: state => {
${body}

            state.round += 1
        }
    })

    return { scalar: result.scalar, field: result.box.value, element: result.values[0] }
}
`
}

export function frontendSource(args: {
    operator: string
    gaps: Gaps
    target?: Target
    mixed: boolean
    expression: boolean
}): string {
    const { operator, gaps, target, mixed, expression } = args
    const body = expression
        ? `            const changed = (state.scalar${gaps.left}${operator}${gaps.right}state.right)\n            state.scalar = changed`
        : updates({ operator, gaps, target })

    return program({ body, mixed, selector: false })
}

export function runtimeSource(args: { operator: string; shapes: Array<Gaps>; first?: number }): string {
    const { operator, shapes, first = 0 } = args
    const branches = shapes.map(
        (gaps, shape) => `                case ${first + shape}:\n${updates({ operator, gaps })}`
    )

    return program({
        body: `            switch (state.shape) {\n${branches.join('\n')}\n            }`,
        mixed: false,
        selector: true
    })
}
