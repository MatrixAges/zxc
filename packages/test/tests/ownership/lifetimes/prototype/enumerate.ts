import type { Instruction } from './model.ts'

export default function enumerate(args: {
    program: Array<Instruction>
    objects: Array<boolean>
    remaining: number
    visit: (program: Array<Instruction>) => void
}): void {
    const { program, objects, remaining, visit } = args

    for (let source = 0; source < objects.length; source += 1) visit([...program, { kind: 'read', source }])

    if (remaining === 0) return

    for (let source = 0; source < objects.length; source += 1) {
        const paths = objects[source] ? [[], ['first'], ['second']] : [[]]

        for (const path of paths) {
            const id = objects.length

            enumerate({
                program: [...program, { kind: 'borrow', id, source, path }],
                objects: [...objects, objects[source] && path.length === 0],
                remaining: remaining - 1,
                visit
            })
            enumerate({
                program: [...program, { kind: 'update', id, source, path }],
                objects: [...objects, objects[source]],
                remaining: remaining - 1,
                visit
            })
        }

        for (const kind of ['escape', 'read'] as const)
            enumerate({ program: [...program, { kind, source }], objects, remaining: remaining - 1, visit })
    }
}
