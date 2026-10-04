type Member = { name: string; source: string; dependencies?: Record<string, string>; entry?: string | null; exports?: Record<string, string>; files?: Record<string, string> }
export type Case = {
	name: string
	source: string
	members: Record<string, Member>
	dependencies?: Record<string, string>
	dev_dependencies?: Record<string, string>
	patterns?: Array<string>
	files?: Record<string, string>
	links?: Record<string, string>
	entry?: string
	increment?: number
	diagnostic?: string
}

function program(expression: string, imports = ''): string {
	return `${imports}export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return ${expression}
}
`
}

function call(path: string, increment = 0): string {
	return program(`dep(in) + ${increment}`, `import dep from ${JSON.stringify(path)}

`)
}

const a = { name: 'a', source: program('in + 2') }
const b = { name: 'b', source: program('in + 3') }
const chain = { a: { name: 'a', dependencies: { b: 'workspace:*' }, source: call('b', 2) }, b }
const undeclared = 'ZX package is not declared in the project dependencies'
const boundary = 'file import crosses a package boundary; declare and import the package dependency'
const cases: Array<Case> = [
	{ name: 'declared transitive execution', source: call('a', 1), dependencies: { a: 'workspace:*' }, members: chain, increment: 6 },
	{ name: 'member entry discovers workspace', source: call('a', 1), dependencies: { a: 'workspace:*' }, members: chain, entry: 'pkgs/a/main.zx', increment: 5 },
	{ name: 'root alias belongs to owner', source: program('local(dep(in))', 'import dep from "a"\nimport local from "@/helper.zx"\n\n'), dependencies: { a: 'workspace:*' }, files: { 'helper.zx': program('in + 100') }, members: { a: { name: 'a', source: call('@/helper.zx'), files: { 'helper.zx': program('in + 2') } } }, increment: 102 },
	{ name: 'member relative file', source: call('a', 1), dependencies: { a: 'workspace:*' }, members: { a: { name: 'a', source: call('./nested/helper.zx'), files: { 'nested/helper.zx': program('in + 2') } } }, increment: 3 },
	{ name: 'development dependency visible', source: call('a'), dev_dependencies: { a: 'workspace:*' }, members: { a }, increment: 2 },
	{ name: 'declared package alias', source: call('local'), dependencies: { local: 'workspace:a@1.2.3' }, members: { a }, increment: 2 },
	{ name: 'scoped package import', source: call('@scope/a'), dependencies: { '@scope/a': 'workspace:*' }, members: { a: { ...a, name: '@scope/a' } }, increment: 2 },
	{ name: 'root cannot import transitive dependency', source: call('b'), dependencies: { a: 'workspace:*' }, members: chain, diagnostic: undeclared },
	{ name: 'member needs its own dependency', source: call('a'), dependencies: { a: 'workspace:*', b: 'workspace:*' }, members: { a: { ...a, source: call('b') }, b }, diagnostic: undeclared },
	{ name: 'alias does not expose original name', source: call('a'), dependencies: { local: 'workspace:a@*' }, members: { a }, diagnostic: undeclared },
	{ name: 'root relative path cannot cross member', source: call('./pkgs/a/main.zx'), dependencies: { a: 'workspace:*' }, members: { a }, diagnostic: boundary },
	{ name: 'member relative path cannot cross sibling', source: call('a'), dependencies: { a: 'workspace:*' }, members: { a: { name: 'a', dependencies: { b: 'workspace:*' }, source: call('../b/main.zx') }, b }, diagnostic: boundary },
	{ name: 'root alias cannot cross member', source: call('@/pkgs/a/main.zx'), dependencies: { a: 'workspace:*' }, members: { a }, diagnostic: boundary },
	{ name: 'undiscovered nested package is not a plain directory', source: call('./pkgs/b/main.zx'), patterns: ['pkgs/a'], members: { a, b }, diagnostic: 'SourceBelongsToUndeclaredPackage' },
	{ name: 'declared target needs public module', source: call('a'), dependencies: { a: 'workspace:*' }, members: { a: { ...a, entry: null } }, diagnostic: 'target a has no public modules' },
	{ name: 'source symlink cannot disguise owner', source: call('./linked.zx'), members: { a }, links: { 'linked.zx': 'pkgs/a/main.zx' }, diagnostic: 'PackageSourceMustUsePhysicalPath' },
]

export default cases
