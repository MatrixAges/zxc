import cases from './compound_integer/cases.ts'
import sourceProgram from './compound_integer/source.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

for (const scalar of ['u8', 'u16', 'u32', 'u64', 'i32', 'i64']) {
    for (const target of ['scalar', 'nested', 'list'] as const) {
        const base = `tests/runtime/safety/compound_integer/${scalar}/${target}`

        writeCatalog(base + '.jsonl', cases({ scalar, target }))
        writeOutput(base + '.zx', sourceProgram({ scalar, target }))
    }
}
