export type Fields = {
	href: string
	protocol: string
	username: string
	password: string
	hostname: string
	port: string
	pathname: string
}

export default function toRecord(fields: Fields) {
	const { href, protocol, username, password, hostname, port, pathname } = fields
	const rest = href.slice(protocol.length)
	const opaque = !rest.startsWith('/')
	const hash = href.indexOf('#')
	const before_hash = hash < 0 ? href : href.slice(0, hash)
	const question = before_hash.indexOf('?')

	return {
		scheme: protocol.slice(0, -1),
		username,
		password,
		host: rest.startsWith('//') ? hostname : null,
		port: port === '' ? null : Number(port),
		path: opaque || pathname === '' ? [] : pathname.split('/').slice(1),
		opaque_path: opaque ? pathname : null,
		query: question < 0 ? null : before_hash.slice(question + 1),
		fragment: hash < 0 ? null : href.slice(hash + 1)
	}
}
