export type Path = Array<string>

export type Instruction =
    | { kind: 'own'; id: number; owned: boolean }
    | { kind: 'borrow'; id: number; source: number; path: Path }
    | { kind: 'read'; source: number }
    | { kind: 'update'; id: number; source: number; path: Path }
    | { kind: 'escape'; source: number }

export type Plan = {
    reuse: Array<boolean>
    visits: number
    places: number
    loans: number
}
