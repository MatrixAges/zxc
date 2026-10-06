import { writeCatalog } from './shared/catalog.ts'

const registration = 'Module registration requires a project relative .rx file path inside the project root'
const duplicate = 'Module file path is already registered'
const missing = 'Referenced module file is not registered'
const escape = 'Module reference escapes the project root or is not a valid module path'
const cycle = 'Reference creates a circular module dependency'
const empty = 'RX attribute must not be empty'

function failure(args: { owner: number; message: string; reference?: boolean }) {
	const { owner, message, reference = false } = args

	return { failure: { owner, message, reference } }
}

function makeCase(args: {
	name: string
	paths: Array<string>
	owner?: number | null
	kind?: string
	reference?: string | null
	expected: { paths: Array<string> } | ReturnType<typeof failure>
}) {
	const { name, paths, owner = null, kind = 'call', reference = null, expected } = args

	return { id: 'rx/modules/paths/' + name, paths, owner, kind, reference, expected }
}

const rows = []
const invalid = [
	'/absolute.rx',
	'../outside.rx',
	'app.rx',
	'api.gateway.rx',
	'data.store.rx',
	'x/',
	'x',
	'x.zx',
	'x\\y.rx',
	'x:y.rx',
	'x\0y.rx',
	'',
	'.rx'
]

for (const [index, path] of invalid.entries()) {
	for (const owner of [0, 1]) {
		const paths = owner === 0 ? [path, 'valid.rx'] : ['valid.rx', path]
		rows.push(
			makeCase({
				name: `registration/${index}/${owner}`,
				paths,
				expected: failure({ owner, message: registration })
			})
		)
	}
}

const aliases = [
	'team/user.rx',
	'./team/user.rx',
	'team//user.rx',
	'team/tmp/../user.rx',
	'./team/./user.rx',
	'tmp/../team/user.rx'
]

for (const [index, alias] of aliases.entries()) {
	for (const reverse of [false, true]) {
		if (alias === 'team/user.rx' && reverse) continue

		const paths = ['team/user.rx', alias]
		if (reverse) paths.reverse()

		rows.push(
			makeCase({
				name: `duplicate/${index}/${Number(reverse)}`,
				paths,
				expected: failure({ owner: 1, message: duplicate })
			})
		)
	}
}

const identities = [
	[
		['team/user.rx', 'other/user.rx'],
		['team/user.rx', 'other/user.rx']
	],
	[
		['team/user.rx', 'team/User.rx'],
		['team/user.rx', 'team/User.rx']
	],
	[
		['./team//tmp/../user.rx', 'other/./user.rx'],
		['team/user.rx', 'other/user.rx']
	]
]

for (const [index, [paths, normalized]] of identities.entries())
	rows.push(makeCase({ name: `identity/${index}`, paths, expected: { paths: normalized } }))

for (const kind of ['call', 'import']) {
	for (const [index, reference] of [
		'users',
		'./users',
		'users.rx',
		'./users.rx',
		'tmp/../users',
		'./tmp/../users.rx'
	].entries()) {
		for (const owner of [0, 1]) {
			const paths = owner === 0 ? ['area/index.rx', 'area/users.rx'] : ['area/users.rx', 'area/index.rx']
			rows.push(
				makeCase({
					name: `resolved/${kind}/${index}/${owner}`,
					paths,
					owner,
					kind,
					reference,
					expected: { paths }
				})
			)
		}
	}

	for (const owner of [0, 1]) {
		const paths = owner === 0 ? ['index.rx', 'other.rx'] : ['other.rx', 'index.rx']

		for (const [index, reference] of ['absent', 'nested/absent', 'tmp/../absent.rx'].entries())
			rows.push(
				makeCase({
					name: `missing/${kind}/${index}/${owner}`,
					paths,
					owner,
					kind,
					reference,
					expected: failure({ owner, message: missing, reference: true })
				})
			)
		for (const [index, reference] of ['../outside', 'tmp/../../outside.rx'].entries())
			rows.push(
				makeCase({
					name: `escape/${kind}/${index}/${owner}`,
					paths,
					owner,
					kind,
					reference,
					expected: failure({ owner, message: escape, reference: true })
				})
			)
	}

	for (const [index, reference] of ['self', './self.rx', 'tmp/../self'].entries())
		rows.push(
			makeCase({
				name: `cycle/${kind}/${index}`,
				paths: ['self.rx'],
				owner: 0,
				kind,
				reference,
				expected: failure({ owner: 0, message: cycle, reference: true })
			})
		)

	const invalid_refs = [
		'/users',
		'users/',
		'app',
		'app.rx',
		'api.gateway',
		'data.store.rx',
		'.',
		'..',
		'x\\y',
		'x:y',
		'x\0y',
		'',
		' ',
		'\t',
		'\n',
		'\r\n'
	]

	for (const [index, reference] of invalid_refs.entries()) {
		const message = !reference.trim()
			? empty
			: kind === 'import'
				? 'Import must reference a relative module file path'
				: 'Module must reference a local RX path or a declared package module'

		for (const owner of [0, 1]) {
			const target = reference && !reference.trim() ? reference + '.rx' : 'other.rx'
			const paths = owner === 0 ? ['index.rx', target] : [target, 'index.rx']
			rows.push(
				makeCase({
					name: `invalid_reference/${kind}/${index}/${owner}`,
					paths,
					owner,
					kind,
					reference,
					expected: failure({ owner, message, reference: true })
				})
			)
		}
	}
}

writeCatalog('tests/rx/modules/paths/cases.jsonl', rows)
