type Case = {
    name: string
    count: number
    source: string
    files: Record<string, string>
    result: 'proved' | 'counterexample' | 'infeasible'
}

const shapes = [
    { name: 'scalar', input: 'Mode', value: 'in' },
    { name: 'nested object', input: '{ nested: { mode: Mode }\n flag: bool }', value: 'in.nested.mode' },
    { name: 'tuple', input: '[Mode, bool]', value: 'mode' }
]

const cases: Array<Case> = [1, 2, 3, 4, 5, 8, 9].flatMap(count => {
    const members = Array.from({ length: count }, (_, index) => `M${index}`)

    return shapes.flatMap(shape => {
        const domain = members.map(member => `${shape.value} == Mode.${member}`).join(' || ')
        const excluded = members.map(member => `${shape.value} != Mode.${member}`).join(' && ')
        const rotation_cases = members
            .slice(0, -1)
            .map((member, index) => `Mode.${member} => Mode.${members[index + 1]}`)
        const rotation = `match ${shape.value} { ${[...rotation_cases, '_ => Mode.M0'].join(', ')} }`
        const scenarios: Array<{ name: string; clauses: string; body: string; result: Case['result'] }> = [
            { name: 'exhaustive domain', clauses: `ensures(${domain})`, body: shape.value, result: 'proved' },
            {
                name: 'last member counterexample',
                clauses: `ensures(out != Mode.${members.at(-1)})`,
                body: shape.value,
                result: 'counterexample'
            },
            { name: 'empty input domain', clauses: `requires(${excluded})`, body: shape.value, result: 'infeasible' }
        ]

        if (count > 1)
            scenarios.push({
                name: 'rotation has no fixed point',
                clauses: `ensures(out != ${shape.value})`,
                body: rotation,
                result: 'proved'
            })

        return scenarios
            .filter(scenario => shape.name !== 'tuple' || scenario.result !== 'infeasible')
            .map(scenario => {
                const tuple_predicate = shape.name === 'tuple' && scenario.result === 'proved'
                const output = tuple_predicate ? 'bool' : 'Mode'
                const clauses = tuple_predicate ? 'ensures(out)' : scenario.clauses
                const body = tuple_predicate
                    ? scenario.name === 'exhaustive domain'
                        ? domain
                        : `(${rotation}) != mode`
                    : scenario.body
                const binding = shape.name === 'tuple' ? '    const [mode, _] = in\n\n' : ''

                return {
                    name: `${count} members / ${shape.name} / ${scenario.name}`,
                    count,
                    result: scenario.result,
                    files: { 'types.zx': `export enum Mode { ${members.join(', ')} }\n` },
                    source: `import { Mode } from "./types"\n\nexport type Input = ${shape.input}\n\nexport type Output = ${output}\n\nexport default function (in: Input): Output ${clauses} {\n${binding}    return ${body}\n}\n`
                }
            })
    })
})

export default cases
