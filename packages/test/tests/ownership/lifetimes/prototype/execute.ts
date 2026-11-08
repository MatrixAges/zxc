import type { Instruction, Path } from './model.ts'

type Storage = Map<string, number>
type Value = { storage: Storage; path: string }

export default function execute(args: {
    program: Array<Instruction>
    reuse: Array<boolean>
    leaves: Array<Path>
}): Array<string> {
    const { program, reuse, leaves } = args
    const values = new Map<number, Value>()
    const observers: Array<Value> = []
    const trace: Array<string> = []
    let version = 0

    function key(path: Path): string {
        return path.map(field => `${field.length}:${field}`).join('/')
    }

    function read(value: Value): string {
        return JSON.stringify(
            [...value.storage]
                .filter(([path]) => path === value.path || path.startsWith(`${value.path}/`) || value.path === '')
                .map(([path, stored]) => [path.slice(value.path.length), stored])
        )
    }

    for (const [position, instruction] of program.entries()) {
        if (instruction.kind === 'own') {
            const value = {
                storage: new Map(leaves.map(path => [key(path), ++version])),
                path: ''
            }

            values.set(instruction.id, value)
            if (!instruction.owned) observers.push(value)
            continue
        }

        const source = values.get(instruction.source)!

        if (instruction.kind === 'borrow') {
            const suffix = key(instruction.path)
            const path = [source.path, suffix].filter(Boolean).join('/')

            values.set(instruction.id, { storage: source.storage, path })
        } else if (instruction.kind === 'read') {
            trace.push(read(source))
        } else if (instruction.kind === 'escape') {
            observers.push(source)
        } else {
            const contents = [...source.storage].filter(
                ([path]) => source.path === '' || path === source.path || path.startsWith(`${source.path}/`)
            )
            const storage = reuse[position]
                ? source.storage
                : new Map(contents.map(([path, stored]) => [path.slice(source.path.length).replace(/^\//, ''), stored]))
            const changed = key(instruction.path)

            for (const path of storage.keys()) {
                if (changed === '' || path === changed || path.startsWith(`${changed}/`)) storage.set(path, ++version)
            }

            values.set(instruction.id, { storage, path: '' })
        }
    }

    for (const observer of observers) trace.push(read(observer))

    return trace
}
