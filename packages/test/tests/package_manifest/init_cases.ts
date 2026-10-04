type Case = { name: string; args: Array<string>; expected?: Record<string, unknown>; diagnostic?: string }
const usage = 'zxc pkg init <name> [--version <version>] [--entry <path>] [--private]\n'
const cases: Array<Case> = [
	{ name: 'default version', args: ['sample'], expected: { name: 'sample', version: '0.1.0' } },
	{ name: 'scoped name', args: ['@scope/sample'], expected: { name: '@scope/sample', version: '0.1.0' } },
	{ name: 'all options', args: ['sample', '--version', '1.2.3-alpha.2+build', '--entry', 'src/main.zx', '--private'], expected: { name: 'sample', version: '1.2.3-alpha.2+build', entry: 'src/main.zx', private: true } },
	{ name: 'reordered options', args: ['sample', '--private', '--entry', 'main.zx', '--version', '0.0.0'], expected: { name: 'sample', version: '0.0.0', entry: 'main.zx', private: true } },
	{ name: 'yaml punctuation in entry', args: ['sample', '--entry', 'src/a #b"c.zx'], expected: { name: 'sample', version: '0.1.0', entry: 'src/a #b"c.zx' } },
]

for (const args of [[], ['sample', '--unknown'], ['sample', 'extra'], ['sample', '--version'], ['sample', '--entry'], ['sample', '--private', '--private'], ['sample', '--version', '1.0.0', '--version', '2.0.0'], ['sample', '--entry', 'a.zx', '--entry', 'b.zx']]) {
	cases.push({ name: `invalid arguments ${JSON.stringify(args)}`, args, diagnostic: usage })
}

for (const [args, message] of [
	[['BadName'], 'invalid package name; use lowercase name or @scope/name'],
	[['@scope'], 'invalid package name; use lowercase name or @scope/name'],
	[[''], 'empty strings and NUL are not allowed in this field'],
	[['sample', '--version', 'latest'], 'version must be a semantic version'],
	[['sample', '--version', '01.2.3'], 'version must be a semantic version'],
	[['sample', '--entry', '../outside.zx'], 'entry must be a package-relative .zx or .rx file path'],
	[['sample', '--entry', '/absolute.zx'], 'entry must be a package-relative .zx or .rx file path'],
	[['sample', '--entry', 'src/a:b.zx'], 'entry must be a package-relative .zx or .rx file path'],
	[['sample', '--entry', 'main.ts'], 'entry must be a package-relative .zx or .rx file path'],
] as Array<[Array<string>, string]>) {
	cases.push({ name: `invalid manifest ${JSON.stringify(args)}`, args, diagnostic: `pkg.yaml: ${message}\n` })
}

export default cases
