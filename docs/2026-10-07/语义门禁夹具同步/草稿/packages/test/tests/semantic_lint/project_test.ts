import assert from 'node:assert/strict'
import { test } from 'node:test'
import createFixture from './fixture.ts'

const identity = `export type Input = i64

export type Output = i64

export default function (in: Input): Output {
    return in
}
`
const main = `import increment from "./nested/increment"

${identity.replace('return in', 'return increment(in)')}`
const manifest = `name: semantic-test
version: 1.0.0

exports:
    .: main.zx
    ./extra: extra.zx
`
const files = {
    'pkg.yaml': manifest,
    'main.zx': main,
    'nested/increment.zx': identity,
    'extra.zx': identity,
    'unreachable.zx': 'this is not valid source'
}

for (const input of ['main.zx', 'pkg.yaml']) {
    test(`semantic lint / valid ${input} ignores unreachable invalid source`, () => {
        const fixture = createFixture(files)

        try {
            const result = fixture.run(['lint', input, '--semantic'])
            assert.equal(result.status, 0, result.stderr)
            assert.equal(result.stderr, '')
        } finally {
            fixture.cleanup()
        }
    })
}

for (const target of ['nested/increment.zx', 'extra.zx']) {
    test(`semantic lint / type failure and selection / ${target}`, () => {
        const fixture = createFixture({ ...files, [target]: identity.replace('return in', 'return true') })

        try {
            const ordinary = fixture.run(['lint', target])
            assert.equal(ordinary.status, 0, ordinary.stderr)

            const source = fixture.run(['lint', 'main.zx', '--semantic'])
            assert.equal(source.status, target === 'extra.zx' ? 0 : 1, source.stderr)

            const project = fixture.run(['lint', 'pkg.yaml', '--semantic'])
            assert.equal(project.status, 1, project.stderr)
            assert.match(project.stderr, /type|Type/)
            assert.ok(project.stderr.includes(target.split('/').at(-1)!))
        } finally {
            fixture.cleanup()
        }
    })
}

for (const entry of [
    { name: 'entry fallback', manifest: 'name: semantic-test\nversion: 1.0.0\nentry: main.zx\n', status: 0 },
    { name: 'no public modules', manifest: 'name: semantic-test\nversion: 1.0.0\n', status: 1 }
]) {
    test(`semantic lint / ${entry.name}`, () => {
        const fixture = createFixture({ ...files, 'pkg.yaml': entry.manifest })

        try {
            const result = fixture.run(['lint', 'pkg.yaml', '--semantic'])
            assert.equal(result.status, entry.status, result.stderr)
            if (entry.status) assert.match(result.stderr, /MissingPublicModules/)
        } finally {
            fixture.cleanup()
        }
    })
}

for (const entry of [
    { name: 'missing import', dependency: null, diagnostic: /FileNotFound|not found|missing/i },
    { name: 'reachable formatting', dependency: identity.replace('\n\n', '\n'), diagnostic: /format|blank/i },
    {
        name: 'import cycle',
        dependency: `import main from "../main"\n\n${identity.replace('return in', 'return main(in)')}`,
        diagnostic: /cycl/i
    }
]) {
    test(`semantic lint / ${entry.name}`, () => {
        const selected: Record<string, string> = { ...files }

        if (entry.dependency === null) delete selected['nested/increment.zx']
        else selected['nested/increment.zx'] = entry.dependency

        const fixture = createFixture(selected)

        try {
            const result = fixture.run(['lint', 'main.zx', '--semantic'])
            assert.equal(result.status, 1, result.stderr)
            assert.match(result.stderr, entry.diagnostic)
        } finally {
            fixture.cleanup()
        }
    })
}

for (const project of ['pkg.yaml', './pkg.yaml', 'nested/../pkg.yaml', 'absolute']) {
    test(`semantic lint / explicit project path / ${project}`, () => {
        const fixture = createFixture(files)

        try {
            const path = project === 'absolute' ? `${fixture.root}/pkg.yaml` : project
            const result = fixture.run(['lint', 'main.zx', '--semantic', '--project', path])
            assert.equal(result.status, 0, result.stderr)
            assert.equal(result.stderr, '')
        } finally {
            fixture.cleanup()
        }
    })
}
