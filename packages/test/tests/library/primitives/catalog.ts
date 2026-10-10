import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'

export type Suite = {
    name: string
    path: string
    kind: string
    sources?: Array<string>
}

export default function loadCatalog(path: string): Array<Suite> {
    const catalog = JSON.parse(readFileSync(path, 'utf8')) as { runtime: Array<Suite> }
    const suites = catalog.runtime.filter(
        suite =>
            ['language/types/number/', 'language/types/boolean/'].some(prefix => suite.path.startsWith(prefix)) ||
            [
                'language/types/null/binding',
                'language/expressions/comparison/f64',
                'language/expressions/comparison/f64_negated'
            ].includes(suite.path)
    )

    assert.ok(suites.length > 0)
    assert.equal(new Set(suites.map(suite => suite.name)).size, suites.length)

    for (const suite of suites) {
        assert.ok(
            ['control', 'floating', 'floating_unary', 'floating_ternary', 'floating_comparison'].includes(suite.kind)
        )
    }

    return suites
}
