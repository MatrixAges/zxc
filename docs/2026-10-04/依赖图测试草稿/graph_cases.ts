type Package = { name: string; version?: string; dependencies?: Record<string, string>; dev_dependencies?: Record<string, string> }
export type Case = {
	name: string
	root?: Omit<Package, 'name'>
	members: Record<string, Package>
	edges?: Array<[string, string, string, boolean]>
	diagnostic?: string
}

const pair = { 'pkgs/a': { name: 'a' }, 'pkgs/b': { name: 'b' } }
const missing = 'workspace dependency has no matching local package'
const mismatch = 'workspace package version does not satisfy the dependency range'
const invalid = 'invalid workspace version range'
const cycle = 'package dependencies must be acyclic'
const cases: Array<Case> = [
	{ name: 'root only', members: {}, edges: [] },
	{ name: 'members not implicitly linked', members: pair, edges: [] },
	{ name: 'direct dependency', root: { dependencies: { b: 'workspace:*' } }, members: pair, edges: [['root', 'b', 'b', false]] },
	{ name: 'development dependency', root: { dev_dependencies: { a: 'workspace:*' } }, members: pair, edges: [['root', 'a', 'a', true]] },
	{ name: 'separate dependency classes', root: { dependencies: { a: 'workspace:*' }, dev_dependencies: { b: 'workspace:*' } }, members: pair, edges: [['root', 'a', 'a', false], ['root', 'b', 'b', true]] },
	{ name: 'owner dependency scope', members: { 'pkgs/a': { name: 'a', dependencies: { b: 'workspace:*' } }, 'pkgs/b': { name: 'b' } }, edges: [['a', 'b', 'b', false]] },
	{ name: 'alias targets another name', root: { dependencies: { a: 'workspace:b@1.2.3' } }, members: pair, edges: [['root', 'a', 'b', false]] },
	{ name: 'scoped name', root: { dependencies: { '@scope/a': 'workspace:*' } }, members: { 'pkgs/a': { name: '@scope/a' } }, edges: [['root', '@scope/a', '@scope/a', false]] },
	{ name: 'scoped alias', root: { dependencies: { local: 'workspace:@scope/a@^1.0.0' } }, members: { 'pkgs/a': { name: '@scope/a' } }, edges: [['root', 'local', '@scope/a', false]] },
	{ name: 'relative root target', root: { dependencies: { local: 'workspace:./pkgs/a' } }, members: pair, edges: [['root', 'local', 'a', false]] },
	{ name: 'relative member target', members: { 'pkgs/a': { name: 'a', dependencies: { neighbor: 'workspace:../b' } }, 'pkgs/b': { name: 'b' } }, edges: [['a', 'neighbor', 'b', false]] },
	{ name: 'missing local target', root: { dependencies: { absent: 'workspace:*' } }, members: pair, diagnostic: `./pkg.yaml: dependency absent: ${missing}\n` },
	{ name: 'relative path outside members', root: { dependencies: { absent: 'workspace:../outside' } }, members: pair, diagnostic: `./pkg.yaml: dependency absent: ${missing}\n` },
	{ name: 'external does not use same named local', root: { dependencies: { a: '^1.0.0' } }, members: pair, diagnostic: './pkg.yaml: dependency a: external dependency is not installed; only workspace: sources are currently resolved\n' },
	{ name: 'duplicate dependency classes', root: { dependencies: { a: 'workspace:*' }, dev_dependencies: { a: 'workspace:*' } }, members: pair, diagnostic: './pkg.yaml: dependency a: dependency appears in both dependencies and dev_dependencies\n' },
	{ name: 'missing alias name', root: { dependencies: { a: 'workspace:@1.0.0' } }, members: pair, diagnostic: './pkg.yaml: dependency a: workspace alias requires a package name and version range\n' },
	{ name: 'invalid range', root: { dependencies: { a: 'workspace:>=nope' } }, members: pair, diagnostic: `./pkg.yaml: dependency a: ${invalid}\n` },
	{ name: 'root self cycle', root: { dependencies: { root: 'workspace:*' } }, members: {}, diagnostic: `./pkg.yaml: dependency root: ${cycle}\n` },
	{ name: 'unreferenced member self cycle', members: { 'pkgs/a': { name: 'a', dependencies: { a: 'workspace:*' } } }, diagnostic: `pkgs/a/pkg.yaml: dependency a: ${cycle}\n` },
	{ name: 'unreferenced indirect cycle', members: { 'pkgs/a': { name: 'a', dependencies: { b: 'workspace:*' } }, 'pkgs/b': { name: 'b', dependencies: { a: 'workspace:*' } } }, diagnostic: `pkgs/a/pkg.yaml: dependency a: ${cycle}\n` },
	{ name: 'development edge participates in cycle', members: { 'pkgs/a': { name: 'a', dependencies: { b: 'workspace:*' } }, 'pkgs/b': { name: 'b', dev_dependencies: { a: 'workspace:*' } } }, diagnostic: `pkgs/a/pkg.yaml: dependency a: ${cycle}\n` },
	{ name: 'diamond is not a cycle', root: { dependencies: { a: 'workspace:*', b: 'workspace:*' } }, members: { 'pkgs/a': { name: 'a', dependencies: { c: 'workspace:*' } }, 'pkgs/b': { name: 'b', dependencies: { c: 'workspace:*' } }, 'pkgs/c': { name: 'c' } }, edges: [['root', 'a', 'a', false], ['root', 'b', 'b', false], ['a', 'c', 'c', false], ['b', 'c', 'c', false]] },
]

for (const [range, accepted] of [['1.2.3', true], ['1.2.4', false], ['^1.0.0', true], ['^2.0.0', false], ['~1.2.0', true], ['~1.1.0', false], ['>=1.2.0 <2.0.0', true], ['>=2.0.0', false], ['^', true], ['~', true]] as const) {
	cases.push({ name: `version ${range}`, root: { dependencies: { a: `workspace:${range}` } }, members: pair, ...(accepted ? { edges: [['root', 'a', 'a', false]] as Array<[string, string, string, boolean]> } : { diagnostic: `./pkg.yaml: dependency a: ${mismatch}\n` }) })
}

export default cases
