import type { Instruction, Path, Plan } from './model.ts'

type Place = {
    parent?: Place
    children: Map<string, Place>
    exact: number
    subtree: number
}

type Value = { place: Place; owned: boolean }

export default function plan(program: Array<Instruction>): Plan {
    const last = new Map<number, number>()
    const endings = new Map<number, Array<Place>>()
    const values = new Map<number, Value>()
    const reuse: Array<boolean> = []
    let visits = 0
    let places = 0
    let loans = 0

    function createPlace(parent?: Place): Place {
        places += 1

        return { parent, children: new Map(), exact: 0, subtree: 0 }
    }

    function project(args: { place: Place; path: Path }): Place {
        let current = args.place

        for (const field of args.path) {
            visits += 1

            let child = current.children.get(field)

            if (!child) {
                child = createPlace(current)
                current.children.set(field, child)
            }

            current = child
        }

        return current
    }

    function changeLoan(args: { place: Place; delta: number }): void {
        args.place.exact += args.delta

        for (let current: Place | undefined = args.place; current; current = current.parent) {
            visits += 1
            current.subtree += args.delta
        }
    }

    function overlaps(place: Place): boolean {
        visits += 1

        if (place.subtree !== 0) return true

        for (let current = place.parent; current; current = current.parent) {
            visits += 1

            if (current.exact !== 0) return true
        }

        return false
    }

    for (const [position, instruction] of program.entries()) {
        if ('source' in instruction) {
            const end = instruction.kind === 'escape' ? program.length : position

            last.set(instruction.source, Math.max(last.get(instruction.source) ?? 0, end))
        }
    }

    for (const [position, instruction] of program.entries()) {
        for (const place of endings.get(position) ?? []) changeLoan({ place, delta: -1 })

        if (instruction.kind === 'own') {
            values.set(instruction.id, { place: createPlace(), owned: instruction.owned })
            continue
        }

        const source = values.get(instruction.source)!

        if (instruction.kind === 'borrow') {
            const place = project({ place: source.place, path: instruction.path })
            const end = (last.get(instruction.id) ?? position) + 1
            const scheduled = endings.get(end) ?? []

            scheduled.push(place)
            endings.set(end, scheduled)
            changeLoan({ place, delta: 1 })
            values.set(instruction.id, { place, owned: false })
            loans += 1
        } else if (instruction.kind === 'update') {
            const target = project({ place: source.place, path: instruction.path })
            const unique = source.owned && last.get(instruction.source) === position
            const in_place = unique && !overlaps(target)

            reuse[position] = in_place
            values.set(instruction.id, {
                place: in_place ? source.place : createPlace(),
                owned: true
            })
        }
    }

    return { reuse, visits, places, loans }
}
