import type { Case } from './import_cases.ts'

function program(expression: string, imports = ''): string {
	return `${imports}export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return ${expression}
}
`
}

function call(path: string): string {
	return program('dep(in)', `import dep from ${JSON.stringify(path)}\n\n`)
}

const member = {
	name: 'math',
	entry: null,
	source: program('in + 100'),
	exports: { './one': 'one.zx', './nested/two': 'two.zx' },
	files: { 'one.zx': program('in + 1'), 'two.zx': program('in + 2'), 'secret.zx': program('in + 99') }
}
const undeclared = 'ZX package is not declared in the project dependencies'
const cases: Array<Case> = [
	{
		name: 'exports two public modules compose',
		source: program('two(one(in))', 'import one from "math/one"\nimport two from "math/nested/two"\n\n'),
		dependencies: { math: 'workspace:*' },
		members: { math: member },
		increment: 3
	},
	{
		name: 'exports explicit default',
		source: call('math'),
		dependencies: { math: 'workspace:*' },
		members: { math: { ...member, exports: { '.': 'one.zx' } } },
		increment: 1
	},
	{
		name: 'exports aliases use dependency spelling',
		source: call('local/nested/two'),
		dependencies: { local: 'workspace:math@*' },
		members: { math: member },
		increment: 2
	},
	{
		name: 'exports scoped package',
		source: call('@scope/math/one'),
		dependencies: { '@scope/math': 'workspace:*' },
		members: { math: { ...member, name: '@scope/math' } },
		increment: 1
	},
	{
		name: 'exports self reference shares owner',
		source: call('math/one'),
		dependencies: { math: 'workspace:*' },
		members: { math: { ...member, files: { ...member.files, 'one.zx': call('math/nested/two') } } },
		increment: 2
	},
	{
		name: 'exports shared implementation aliases',
		source: program('two(one(in))', 'import one from "math/one"\nimport two from "math/nested/two"\n\n'),
		dependencies: { math: 'workspace:*' },
		members: { math: { ...member, exports: { './one': 'one.zx', './nested/two': 'one.zx' } } },
		increment: 2
	},
	{
		name: 'exports internal relative closure',
		source: call('math/one'),
		dependencies: { math: 'workspace:*' },
		members: { math: { ...member, files: { ...member.files, 'one.zx': call('./secret.zx') } } },
		increment: 99
	}
]

for (const path of ['math', 'math/secret', 'math/secret.zx', 'math/one.zx', 'math/nested', 'math/nested/two/extra']) {
	cases.push({
		name: `exports hides ${path}`,
		source: call(path),
		dependencies: { math: 'workspace:*' },
		members: { math: member },
		diagnostic: undeclared
	})
}

cases.push({
	name: 'exports alias hides original package name',
	source: call('math/one'),
	dependencies: { local: 'workspace:math@*' },
	members: { math: member },
	diagnostic: undeclared
})

export default cases
