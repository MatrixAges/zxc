import type { Json } from './shared/json.ts'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { package_dir, writeOutput } from './shared/catalog.ts'
import { asciiJson, parseJson } from './shared/json.ts'
import { quote } from './zig_string.ts'

type Case = Record<string, Json> & { name: string }

const directory = 'tests/rx/attributes'

for (const name of ['parsing', 'schema']) {
    const cases = parseJson<Array<Case>>(readFileSync(resolve(package_dir, `${directory}/${name}.json`), 'utf8'))
    const declarations = ['const fixture = @import("fixture.zig");', '']

    for (const { name: title, ...value } of cases) {
        declarations.push(`test ${quote(title)} {
    try fixture.check(
        \\\\${asciiJson(value)}
    );
}
`)
    }

    writeOutput(`${directory}/${name}_test.zig`, declarations.join('\n'))
    console.log(`${name}: ${cases.length} cases`)
}
