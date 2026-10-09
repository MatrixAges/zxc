import assert from 'node:assert/strict'
import cases from './rx_floating/cases.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

for (const width of [32, 64] as const) {
    const base = `tests/rx/runtime/floating/f${width}`
    const rows = cases(width)

    assert.equal(rows.length, 756)
    assert.equal(new Set(rows.map(row => row.id)).size, rows.length)
    writeCatalog(base + '.jsonl', rows)
    writeOutput(
        base + '.rx',
        `<Module>
  <Switch on={$in.choose}>
    <Case value={true}>
      <Task name="selected" out={$ctx.identity}>
        <Call fn="identity" in={$in.safe} />
      </Task>
      <Return value={$ctx.task.selected} />
    </Case>
    <Default>
      <Task name="selected" out={$ctx.first}>
        <Call fn="first" in={$in.items} />
      </Task>
      <Return value={$ctx.task.selected} />
    </Default>
  </Switch>
</Module>
`
    )

    for (const operation of ['identity', 'first'])
        writeOutput(
            `${base}/${operation}.zx`,
            `export type Input = f${width}${operation === 'first' ? '[]' : ''}

export type Output = f${width}

export default function (in: Input): Output {
    return in${operation === 'first' ? '[0]' : ''}
}
`
        )
}
