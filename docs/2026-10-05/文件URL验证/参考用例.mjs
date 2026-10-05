import { writeFileSync } from 'node:fs'
import { posix, win32 } from 'node:path'
import { fileURLToPath, fileURLToPathBuffer, pathToFileURL } from 'node:url'

const cases = []

function appendCase(item, callback) {
	try {
		const value = callback()

		item.expected = Array.from(Buffer.isBuffer(value) ? value : Buffer.from(value))
	} catch (error) {
		item.error = error.code ?? error.name
	}

	cases.push(item)
}

for (const windows of [false, true]) {
	const cwd = windows ? 'C:\\work\\project' : '/work/project'
	const prefix = windows ? 'C:\\data\\' : '/data/'
	const paths = [
		'',
		'.',
		'..',
		'../leaf',
		'child/',
		'child\\',
		'/root/../leaf',
		prefix,
		prefix + 'a/../b/',
		prefix + 'a%2Fb',
		prefix + '你好🚀',
		prefix + 'a?b#c',
		prefix + 'a[]|~^'
	]

	if (windows) {
		paths.push(
			'D:\\folder\\a',
			'c:/folder/a',
			'\\rooted',
			'\\\\server\\share\\a',
			'\\\\nas\\My Docs\\File.doc',
			'\\\\?\\UNC\\server\\share\\a',
			'\\\\?\\C:\\path\\to\\file.txt',
			'\\\\你好\\share\\a',
			'\\\\host',
			'\\\\\\missing'
		)
	}

	if (windows) {
		for (const letter of 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') {
			paths.push('\\\\?\\' + letter + ':\\folder\\..\\leaf #.txt')
		}

		paths.push(String.raw`\\server\share\a\..\b`, String.raw`\\server\share\a/../b`)
	}

	for (let point = 0; point < 128; point += 1) {
		paths.push(prefix + 'a' + String.fromCharCode(point) + 'b')
	}

	for (const input of paths) {
		appendCase({ operation: 'from_path', input, windows, cwd }, () => {
			const path_api = windows ? win32 : posix
			let absolute = windows && input.startsWith('\\\\') ? input : path_api.resolve(cwd, input)

			if (input.endsWith('/') || (windows && input.endsWith('\\'))) {
				if (!absolute.endsWith(path_api.sep)) absolute += path_api.sep
			}

			return pathToFileURL(absolute, { windows }).href
		})
	}

	const urls = [
		'https://example.org/a',
		'data:text/plain,a',
		'file:///',
		'file:///C:/',
		'file:///C:/dir/a',
		'file:///C|/dir/a',
		'file:///c:/a?query#hash',
		'file://localhost/C:/a',
		'file://server/share/a',
		'file://xn--6qq79v/share/a',
		'file://[::1]/share/a',
		'file:///a%20b',
		'file:///C:/a%',
		'file:///C:/a%2',
		'file:///C:/a%GG',
		'file:///C:/a%252Fb',
		'file:///C:/%E4%BD%A0%E5%A5%BD',
		'file:///C:/%C0%AF',
		'file:///C:/%ED%A0%80',
		'file:///C:/%F4%90%80%80'
	]

	for (let byte = 0; byte < 256; byte += 1) {
		urls.push('file:///' + (windows ? 'C:/' : '') + 'a%' + byte.toString(16).padStart(2, '0') + 'b')
	}

	for (const input of new Set(urls)) {
		appendCase({ operation: 'to_path', input, windows }, () => fileURLToPath(input, { windows }))
		appendCase({ operation: 'to_bytes', input, windows }, () => fileURLToPathBuffer(input, { windows }))
	}
}

cases.push({
	operation: 'from_path',
	input: String.raw`\\host name\share\a`,
	windows: true,
	cwd: String.raw`C:\work\project`,
	error: 'ERR_INVALID_URL'
})

writeFileSync(
	new URL('参考用例.json', import.meta.url),
	JSON.stringify({ node: process.version, cases }, null, 2) + '\n'
)
console.log(`${cases.length} cases from Node ${process.version}`)
