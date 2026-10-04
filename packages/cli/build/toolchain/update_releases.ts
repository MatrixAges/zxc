const [version, output] = process.argv.slice(2)

if (!version || !output || process.argv.length !== 4) {
	throw new Error('bun update_releases.ts <version> <output.json>')
}

const response = await fetch('https://ziglang.org/download/index.json')

if (!response.ok) throw new Error(`Zig index request failed: ${response.status}`)

const index: unknown = await response.json()
const release_index = record(record(index)[version])
const hosts = ['aarch64-linux', 'aarch64-macos', 'x86_64-linux', 'x86_64-macos', 'x86_64-windows']
const releases = hosts.map(host => {
	const data = record(release_index[host])

	if (
		typeof data.tarball !== 'string' ||
		typeof data.shasum !== 'string' ||
		!data.tarball.startsWith('https://ziglang.org/') ||
		!/^[0-9a-f]{64}$/.test(data.shasum)
	) {
		throw new Error(`Invalid official release metadata: ${host}`)
	}

	return { host, archive: data.tarball, archive_sha256: data.shasum }
})

await Bun.write(output, JSON.stringify({ version, releases }, null, 2) + '\n')

function record(value: unknown): Record<string, unknown> {
	if (!value || typeof value !== 'object' || Array.isArray(value)) throw new Error('Expected release metadata object')

	return value as Record<string, unknown>
}

export {}
