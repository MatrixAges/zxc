import assert from 'node:assert/strict'
import { readFileSync, writeFileSync } from 'node:fs'
import { join, resolve } from 'node:path'
import { pathToFileURL } from 'node:url'
import { outputs } from './草稿/运行支持/目录捕获.mjs'

const root = process.cwd()
const name = process.argv[2]
const generator = resolve(root, 'packages/test/src', name)
const capture = pathToFileURL(join(import.meta.dirname, '草稿/运行支持/目录捕获.mjs')).href
const source = readFileSync(generator, 'utf8').replace('./shared/catalog.ts', capture)
const temporary = join('/tmp', `zxc-catalog-probe-${name}`)

assert.equal(name.endsWith('.ts'), true)
writeFileSync(temporary, source)
await import(pathToFileURL(temporary).href)

for (const output of outputs) {
    const expected = readFileSync(resolve(root, 'packages/test', output.path), 'utf8')

    if ('rows' in output) {
        const actual_rows = expected
            .trimEnd()
            .split('\n')
            .map(line => JSON.parse(line))

        assert.equal(output.rows.length, actual_rows.length)

        const differences = output.rows.flatMap((row, index) => {
            const current = actual_rows[index]
            const fields = [...new Set([...Object.keys(row), ...Object.keys(current)])].filter(
                field => JSON.stringify(row[field]) !== JSON.stringify(current[field])
            )

            assert.equal(row.id, current.id)

            return fields.length
                ? [{ id: row.id, fields, generated_diagnostic: row.diagnostic, actual_diagnostic: current.diagnostic }]
                : []
        })

        console.log(
            JSON.stringify({
                path: output.path,
                cases: output.rows.length,
                differences: differences.length,
                samples: differences.slice(0, 5)
            })
        )
    } else {
        const generated_lines = output.content.split('\n')
        const actual_lines = expected.split('\n')
        const changed = generated_lines.flatMap((line, index) =>
            line !== actual_lines[index] ? [{ line: index + 1, generated: line, actual: actual_lines[index] }] : []
        )

        console.log(JSON.stringify({ path: output.path, differences: changed.length, samples: changed.slice(0, 6) }))
    }
}
