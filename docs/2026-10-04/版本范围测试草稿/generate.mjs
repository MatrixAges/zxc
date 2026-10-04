import assert from 'node:assert/strict'
import { createRequire } from 'node:module'
import { writeFileSync } from 'node:fs'

const require = createRequire(import.meta.url)
const semver = require('../../../node_modules/.pnpm/semver@7.8.5/node_modules/semver')
const metadata = require('../../../node_modules/.pnpm/semver@7.8.5/node_modules/semver/package.json')

assert.equal(metadata.version, '7.8.5')

const versions = [
    '0.0.0', '0.0.2', '0.0.3', '0.1.0', '0.2.3', '0.2.4', '0.3.0',
    '1.0.0', '1.2.0', '1.2.2', '1.2.3-0', '1.2.3-alpha', '1.2.3-alpha.2',
    '1.2.3-alpha.10', '1.2.3-beta', '1.2.3', '1.2.3+build.9', '1.2.4-alpha',
    '1.2.4', '1.3.0-0', '1.3.0', '2.0.0-alpha', '2.0.0', '2.3.4', '3.0.0',
]
const ranges = [
    '1.2.3', '=1.2.3', '1.2.3+different', '1', '1.2', '1.x', '1.2.X', 'x', 'X',
    '>=1.2.3', '>1.2.3', '<1.2.3', '<=1.2.3', '>= 1.2.3', '<= 1.2.3',
    '>1', '>1.2', '<1', '<1.2', '<=1', '<=1.2', '>=1', '>=1.2',
    '>x', '<x', '>=x', '<=x', '=x',
    '~1', '~1.2', '~1.2.3', '~0.2.3', '^1', '^1.2', '^1.2.3',
    '^0', '^0.0', '^0.0.2', '^0.2', '^0.2.3', '^0.0.0',
    '1.2.3 - 2.3.4', '1.2 - 2.3', '1 - 2', '1.2.3 - 2',
    '>=1.2.0 <2.0.0', '>2.0.0 <1.0.0', '1.2.3 || 2.3.4', '^0.2.3 || ~1.2.0',
    '>=1.2.3-alpha <2.0.0', '^1.2.3-alpha', '~1.2.3-alpha',
    '1.2.3-alpha.2', '>1.2.3-alpha.2', '<1.2.3-alpha.10',
    '1.2.3-alpha - 1.2.3', '>=1.2.3-alpha <1.3',
    '>=1.2.3-alpha <1.2.3 || >=1.2.4-alpha <1.3',
    '>=1.2.3-alpha <1.2.3 || >=2.0.0',
]

for (const range of ranges) assert.notEqual(semver.validRange(range), null, range)
for (const version of versions) assert.equal(semver.valid(version) !== null, true, version)

const rows = ranges.map(range => [range, versions.map(version => Number(semver.satisfies(version, range))).join('')])
const output = `import type { Case } from './graph_cases.ts'

const versions = ${JSON.stringify(versions)}
const expectations: Array<[string, string]> = [
${rows.map(row => '\t' + JSON.stringify(row) + ',').join('\n')}
]
const cases: Array<Case> = []

for (const [range, expected] of expectations) {
\tif (expected.length !== versions.length || !/^[01]+$/.test(expected)) throw new Error('invalid semver expectation vector')

\tfor (const [index, version] of versions.entries()) {
\t\tcases.push({
\t\t\tname: \`range \${JSON.stringify(range)} / \${version}\`,
\t\t\troot: { dependencies: { a: \`workspace:\${range}\` } },
\t\t\tmembers: { 'pkgs/a': { name: 'a', version } },
\t\t\t...(expected[index] === '1'
\t\t\t\t? { edges: [['root', 'a', 'a', false]] as Array<[string, string, string, boolean]> }
\t\t\t\t: { diagnostic: './pkg.yaml: dependency a: workspace package version does not satisfy the dependency range\\n' }),
\t\t})
\t}
}

for (const range of ['1..2', '01.2.3', '1.02.3', '1.2.03', '1.2.3.4', 'x.2', '1.x.3', '1.2-alpha', '1.2.3-', '1.2.3+', '!=1.2.3', '==1.2.3', '><1.2.3', '>=', '1.2.3 -', '1.2.3 - 2.0.0 extra', '1.2.3 || nope', 'nope || 1.2.3']) {
\tcases.push({
\t\tname: \`invalid range \${range}\`,
\t\troot: { dependencies: { a: \`workspace:\${range}\` } },
\t\tmembers: { 'pkgs/a': { name: 'a', version: '1.2.3' } },
\t\tdiagnostic: './pkg.yaml: dependency a: invalid workspace version range\\n',
\t})
}

for (const range of ['*', '^', '~']) {
\tfor (const version of ['0.0.0', '1.2.3-alpha', '2.0.0+build']) {
\t\tcases.push({
\t\t\tname: \`workspace shortcut \${range} / \${version}\`,
\t\t\troot: { dependencies: { a: \`workspace:\${range}\` } },
\t\t\tmembers: { 'pkgs/a': { name: 'a', version } },
\t\t\tedges: [['root', 'a', 'a', false]],
\t\t})
\t}
}

export default cases
`

writeFileSync(new URL('./range_cases.ts', import.meta.url), output)
console.log(JSON.stringify({ oracle: metadata.version, ranges: ranges.length, versions: versions.length, cases: ranges.length * versions.length }))
