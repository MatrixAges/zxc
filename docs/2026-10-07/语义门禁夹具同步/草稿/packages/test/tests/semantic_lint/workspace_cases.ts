const identity = `export type Input = i64

export type Output = i64

export default function (in: Input): Output {
    return in
}
`

export default {
    'pkg.yaml': `name: semantic-workspace
version: 1.0.0
private: true

workspace:
    packages: ['packages/*', '!packages/ignored']
`,
    'packages/app/pkg.yaml': `name: lint-app
version: 1.0.0
entry: main.zx

dependencies:
    lint-numbers: workspace:*
`,
    'packages/app/main.zx': `import numbers from "lint-numbers"\n\n${identity.replace('return in', 'return numbers(in)')}`,
    'packages/numbers/pkg.yaml': 'name: lint-numbers\nversion: 1.0.0\nentry: main.zx\n',
    'packages/numbers/main.zx': identity,
    'packages/other/pkg.yaml': 'name: lint-other\nversion: 1.0.0\nentry: main.zx\n',
    'packages/other/main.zx': identity,
    'packages/organization/pkg.yaml': 'name: organization\nversion: 1.0.0\nprivate: true\n',
    'packages/ignored/pkg.yaml': 'invalid excluded manifest',
    'outside/pkg.yaml': 'invalid undeclared manifest',
    'packages/app/private.zx': 'invalid unreachable source'
}
