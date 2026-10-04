export type Case = {
	name: string
	patterns?: Array<string>
	files: Record<string, string>
	external?: Record<string, string>
	links?: Array<{ path: string; target: string; type: 'file' | 'dir' }>
	expected?: Array<[string, string]>
	diagnostic?: RegExp
}

function manifest(name: string): string {
	return `name: ${name}\nversion: 1.0.0\n`
}

const pair = { 'pkgs/b/pkg.yaml': manifest('b'), 'pkgs/a/pkg.yaml': manifest('a') }
const cases: Array<Case> = [
	{ name: 'no workspace', files: pair, expected: [['.', 'root']] },
	{ name: 'empty patterns', patterns: [], files: pair, expected: [['.', 'root']] },
	{ name: 'literal path', patterns: ['pkgs/b'], files: pair, expected: [['.', 'root'], ['pkgs/b', 'b']] },
	{ name: 'single segment star and sorting', patterns: ['pkgs/*'], files: { ...pair, 'pkgs/nested/deep/pkg.yaml': manifest('deep') }, expected: [['.', 'root'], ['pkgs/a', 'a'], ['pkgs/b', 'b']] },
	{ name: 'globstar zero and multiple segments', patterns: ['pkgs/**'], files: { 'pkgs/pkg.yaml': manifest('container'), 'pkgs/a/pkg.yaml': manifest('a'), 'pkgs/a/deep/pkg.yaml': manifest('deep') }, expected: [['.', 'root'], ['pkgs', 'container'], ['pkgs/a', 'a'], ['pkgs/a/deep', 'deep']] },
	{ name: 'globstar followed by literal', patterns: ['**/leaf'], files: { 'leaf/pkg.yaml': manifest('leaf'), 'x/leaf/pkg.yaml': manifest('nested') }, expected: [['.', 'root'], ['leaf', 'leaf'], ['x/leaf', 'nested']] },
	{ name: 'question one byte', patterns: ['pkgs/?'], files: { ...pair, 'pkgs/ab/pkg.yaml': manifest('ab') }, expected: [['.', 'root'], ['pkgs/a', 'a'], ['pkgs/b', 'b']] },
	{ name: 'star within segment', patterns: ['pkgs/a*'], files: { ...pair, 'pkgs/ab/pkg.yaml': manifest('ab') }, expected: [['.', 'root'], ['pkgs/a', 'a'], ['pkgs/ab', 'ab']] },
	{ name: 'exclude before include', patterns: ['!pkgs/b', 'pkgs/*'], files: pair, expected: [['.', 'root'], ['pkgs/a', 'a']] },
	{ name: 'exclude after include', patterns: ['pkgs/*', '!pkgs/b'], files: pair, expected: [['.', 'root'], ['pkgs/a', 'a']] },
	{ name: 'recursive exclusion', patterns: ['pkgs/**', '!pkgs/hidden/**'], files: { ...pair, 'pkgs/hidden/pkg.yaml': manifest('hidden'), 'pkgs/hidden/deep/pkg.yaml': manifest('deep') }, expected: [['.', 'root'], ['pkgs/a', 'a'], ['pkgs/b', 'b']] },
	{ name: 'overlapping includes once', patterns: ['pkgs/*', 'pkgs/**', 'pkgs/a'], files: pair, expected: [['.', 'root'], ['pkgs/a', 'a'], ['pkgs/b', 'b']] },
	{ name: 'exclude alone includes nothing', patterns: ['!pkgs/b'], files: pair, expected: [['.', 'root']] },
	{ name: 'matched directory without manifest', patterns: ['pkgs/*'], files: { ...pair, 'pkgs/empty/readme.txt': 'empty' }, expected: [['.', 'root'], ['pkgs/a', 'a'], ['pkgs/b', 'b']] },
	{ name: 'duplicate member names', patterns: ['pkgs/*'], files: { 'pkgs/b/pkg.yaml': manifest('same'), 'pkgs/a/pkg.yaml': manifest('same') }, diagnostic: /duplicate workspace package same; first declared at pkgs\/a\n$/ },
	{ name: 'duplicate root name', patterns: ['pkgs/*'], files: { 'pkgs/a/pkg.yaml': manifest('root') }, diagnostic: /duplicate workspace package root; first declared at \.\n$/ },
	{ name: 'invalid member manifest', patterns: ['pkgs/*'], files: { 'pkgs/a/pkg.yaml': manifest('a') + 'unknown: true\n' }, diagnostic: /:3:1: manifest: unknown pkg.yaml field\n$/ },
	{ name: 'nested workspace does not rescan', patterns: ['pkgs/*'], files: { 'pkgs/a/pkg.yaml': manifest('a') + 'workspace:\n  packages: [sub]\n', 'pkgs/a/sub/pkg.yaml': manifest('sub') }, expected: [['.', 'root'], ['pkgs/a', 'a']] },
	{ name: 'directory symlink ignored', patterns: ['aliases/*'], files: { 'real/pkg.yaml': manifest('real') }, links: [{ path: 'aliases/linked', target: 'workspace/real', type: 'dir' }], expected: [['.', 'root']] },
	{ name: 'manifest symlink inside root', patterns: ['pkgs/*'], files: { 'templates/pkg.yaml': manifest('linked') }, links: [{ path: 'pkgs/a/pkg.yaml', target: 'workspace/templates/pkg.yaml', type: 'file' }], expected: [['.', 'root'], ['pkgs/a', 'linked']] },
	{ name: 'manifest symlink escapes root', patterns: ['pkgs/*'], files: {}, external: { 'outside/pkg.yaml': manifest('outside') }, links: [{ path: 'pkgs/a/pkg.yaml', target: 'outside/pkg.yaml', type: 'file' }], diagnostic: /manifest escapes the workspace root\n$/ },
]

for (const directory of ['.git', '.zxc', '.zig-cache', 'zig-out', 'zig-pkg', 'node_modules']) {
	cases.push({ name: `ignore ${directory}`, patterns: ['**'], files: { [`${directory}/member/pkg.yaml`]: manifest('hidden'), 'visible/pkg.yaml': manifest('visible') }, expected: [['.', 'root'], ['visible', 'visible']] })
}

for (const pattern of ['pkgs/[ab]', 'pkgs/{a,b}', 'pkgs/@(a)', 'pkgs/a**']) {
	cases.push({ name: `unsupported ${pattern}`, patterns: [pattern], files: pair, diagnostic: /unsupported workspace pattern:/ })
}

export default cases
