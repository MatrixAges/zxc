type Release = { version: string; archive: string; sha256: string }
type Index = { format_version: number; packages: Array<{ name: string; versions: Array<Release> }> }
type Case = { name: string; index: Index; args: Array<string>; expected?: unknown; diagnostic?: string }

function release(version: string): Release {
	return { version, archive: `archives/sample-${version}.tar.gz`, sha256: 'a1'.repeat(32) }
}

const versions = ['2.0.0', '1.2.3', '1.10.0', '0.2.3', '1.2.4', '1.3.0-alpha.2', '1.3.0-alpha.10', '2.0.0-beta', '1.2.5+build.7']
const index: Index = { format_version: 1, packages: [{ name: 'sample', versions: versions.map(release) }] }
const cases: Array<Case> = [
	{ name: 'empty index', index: { format_version: 1, packages: [] }, args: ['index'], expected: { format_version: 1, packages: [] } },
	{ name: 'index preserves metadata and order', index, args: ['index'], expected: index },
]

for (const [order, candidates] of [['original', versions], ['reverse', [...versions].reverse()], ['rotated', [...versions.slice(3), ...versions.slice(0, 3)]]] as Array<[string, Array<string>]>) {
	for (const [range, selected] of [
		['*', '2.0.0'], ['^1.0.0', '1.10.0'], ['~1.2.0', '1.2.5+build.7'], ['1.2.3', '1.2.3'],
		['=1.2.5+different', '1.2.5+build.7'], ['1.2', '1.2.5+build.7'], ['<1.3.0', '1.2.5+build.7'],
		['>1.2.3 <1.2.5', '1.2.4'], ['0.2.3 || 1.2.3', '1.2.3'], ['^0.2.0', '0.2.3'],
		['>=1.3.0-alpha.2 <1.3.0', '1.3.0-alpha.10'], ['>=2.0.0-beta <2.0.0', '2.0.0-beta'],
		['1.2.3 - 1.10.0', '1.10.0'], ['>=3.0.0', null], ['<0.2.3', null],
	] as Array<[string, string | null]>) {
		cases.push({
			name: `resolve ${order} / ${range}`,
			index: { format_version: 1, packages: [{ name: 'sample', versions: candidates.map(release) }] },
			args: ['resolve', 'sample', range],
			...(selected ? { expected: release(selected) } : { diagnostic: `sample: no indexed version satisfies ${range}\n` }),
		})
	}
}

cases.push(
	{ name: 'unknown package', index, args: ['resolve', 'absent', '*'], diagnostic: 'absent: no indexed version satisfies *\n' },
	{ name: 'invalid range still checked for absent package', index, args: ['resolve', 'absent', '>=nope'], diagnostic: 'absent: >=nope: InvalidRange\n' },
	{ name: 'invalid range for present package', index, args: ['resolve', 'sample', '1.2.3 || nope'], diagnostic: 'sample: 1.2.3 || nope: InvalidRange\n' },
	{ name: 'scoped package selection', index: { format_version: 1, packages: [{ name: '@scope/sample', versions: [release('1.0.0')] }, ...index.packages] }, args: ['resolve', '@scope/sample', '*'], expected: release('1.0.0') },
)

for (const [name, invalid, code] of [
	['unsupported format', { ...index, format_version: 2 }, 'UnsupportedIndexVersion'],
	['uppercase package name', { ...index, packages: [{ name: 'Bad', versions: [release('1.0.0')] }] }, 'InvalidPackageName'],
	['no releases', { ...index, packages: [{ name: 'sample', versions: [] }] }, 'PackageHasNoVersions'],
	['duplicate package', { ...index, packages: [...index.packages, ...index.packages] }, 'DuplicatePackage'],
	['duplicate release', { ...index, packages: [{ name: 'sample', versions: [release('1.0.0'), release('1.0.0')] }] }, 'DuplicatePackageVersion'],
	['build metadata duplicate', { ...index, packages: [{ name: 'sample', versions: [release('1.0.0+a'), release('1.0.0+b')] }] }, 'DuplicatePackageVersion'],
] as Array<[string, Index, string]>) {
	cases.push({ name, index: invalid, args: ['index'], diagnostic: `index.json: index: ${code}\n` })
}

for (const [field, value, code] of [
	['archive', '', 'InvalidArchiveSource'], ['archive', 'file\nname', 'InvalidArchiveSource'],
	['archive', 'file\rname', 'InvalidArchiveSource'], ['archive', 'file\0name', 'InvalidArchiveSource'],
	['sha256', 'a'.repeat(63), 'InvalidArchiveDigest'], ['sha256', 'a'.repeat(65), 'InvalidArchiveDigest'],
	['sha256', 'g'.repeat(64), 'InvalidArchiveDigest'],
]) {
	cases.push({
		name: `invalid ${field} ${JSON.stringify(value)}`,
		index: { format_version: 1, packages: [{ name: 'sample', versions: [{ ...release('1.0.0'), [field]: value }] }] },
		args: ['index'],
		diagnostic: `index.json: index: ${code}\n`,
	})
}

export default cases
