type Release = { version: string; archive: string; sha256: string }
type Index = { format_version: number; packages: Array<{ name: string; versions: Array<Release> }> }
type Case = { name: string; source: string; diagnostic?: string; file?: string }

const release = { version: '1.0.0', archive: '不存在/归档.tgz', sha256: 'a1'.repeat(32) }
const index: Index = {
	format_version: 1,
	packages: [
		{ name: 'zeta', versions: [{ ...release, version: '2.0.0' }, release] },
		{ name: '@scope/alpha', versions: [{ ...release, version: '3.0.0-beta.1+build.2' }] }
	]
}
const cases: Array<Case> = [
	{ name: 'empty index', source: '{"packages":[],"format_version":1}' },
	{ name: 'package and version declaration order', source: JSON.stringify(index) },
	{ name: 'explicit kind overrides manifest basename', file: 'pkg.yaml', source: JSON.stringify(index) },
	{ name: 'escaped string semantics', source: JSON.stringify(index).replace('zeta', '\\u007aeta') },
	{ name: 'unknown field', source: '{"format_version":1,"packages":[],"extra":1}', diagnostic: 'UnknownField' },
	{
		name: 'duplicate JSON field',
		source: '{"format_version":1,"format_version":1,"packages":[]}',
		diagnostic: 'DuplicateField'
	},
	{ name: 'missing packages field', source: '{"format_version":1}', diagnostic: 'MissingField' },
	{
		name: 'unsupported version',
		source: '{"format_version":2,"packages":[]}',
		diagnostic: 'UnsupportedIndexVersion'
	},
	{ name: 'malformed JSON', source: 'not JSON', diagnostic: 'SyntaxError' }
]

for (const [name, packages, diagnostic] of [
	['invalid package name', [{ name: 'Bad', versions: [release] }], 'InvalidPackageName'],
	['no versions', [{ name: 'sample', versions: [] }], 'PackageHasNoVersions'],
	[
		'invalid digest',
		[{ name: 'sample', versions: [{ ...release, sha256: 'g'.repeat(64) }] }],
		'InvalidArchiveDigest'
	],
	['duplicate package', [...index.packages, ...index.packages], 'DuplicatePackage'],
	[
		'duplicate release metadata',
		[
			{
				name: 'sample',
				versions: [
					{ ...release, version: '1.0.0+a' },
					{ ...release, version: '1.0.0+b' }
				]
			}
		],
		'DuplicatePackageVersion'
	]
] as Array<[string, Index['packages'], string]>) {
	cases.push({ name, source: JSON.stringify({ format_version: 1, packages }), diagnostic })
}

export default cases
