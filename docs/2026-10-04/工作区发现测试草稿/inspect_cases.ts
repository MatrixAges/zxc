export type Case = {
	name: string
	source: string
	expected?: Record<string, unknown>
	diagnostic?: { message: string; line: number; column: number }
}

const base = 'name: sample\nversion: 1.0.0\n'
const cases: Array<Case> = [
	{ name: 'minimal', source: base, expected: { name: 'sample', version: '1.0.0', entry: null, private: false } },
	{ name: 'scoped prerelease', source: 'name: "@scope/sample"\nversion: 1.2.3-alpha.1+build\n', expected: { name: '@scope/sample', version: '1.2.3-alpha.1+build' } },
	{ name: 'private boolean', source: base + 'private: true\n', expected: { private: true } },
	{ name: 'entry with spaces', source: base + 'entry: source folder/main.zx\n', expected: { entry: 'source folder/main.zx' } },
	{ name: 'dependency groups', source: base + 'dependencies:\n  other: "^1.0.0"\ndev_dependencies:\n  tooling: workspace:*\n', expected: { dependencies: [{ name: 'other', requirement: '^1.0.0' }], dev_dependencies: [{ name: 'tooling', requirement: 'workspace:*' }] } },
	{ name: 'workspace patterns', source: base + 'workspace:\n  packages:\n    - packages/*\n    - "!packages/ignored"\n', expected: { workspace: { packages: ['packages/*', '!packages/ignored'] } } },
	{ name: 'root sequence', source: '- sample\n', diagnostic: { message: 'expected a YAML mapping', line: 1, column: 1 } },
	{ name: 'duplicate key', source: base + 'name: other\n', diagnostic: { message: 'duplicate YAML mapping key', line: 3, column: 1 } },
	{ name: 'missing name', source: 'version: 1.0.0\n', diagnostic: { message: 'pkg.yaml requires name', line: 1, column: 1 } },
	{ name: 'missing version', source: 'name: sample\n', diagnostic: { message: 'pkg.yaml requires version', line: 1, column: 1 } },
	{ name: 'uppercase name', source: 'name: Sample\nversion: 1.0.0\n', diagnostic: { message: 'invalid package name; use lowercase name or @scope/name', line: 1, column: 7 } },
	{ name: 'invalid version', source: 'name: sample\nversion: latest\n', diagnostic: { message: 'version must be a semantic version', line: 2, column: 10 } },
	{ name: 'empty name', source: 'name: ""\nversion: 1.0.0\n', diagnostic: { message: 'empty strings and NUL are not allowed in this field', line: 1, column: 7 } },
	{ name: 'NUL name', source: 'name: "bad\\0name"\nversion: 1.0.0\n', diagnostic: { message: 'empty strings and NUL are not allowed in this field', line: 1, column: 7 } },
	{ name: 'unknown field', source: base + 'mystery: true\n', diagnostic: { message: 'unknown pkg.yaml field', line: 3, column: 1 } },
	{ name: 'quoted boolean', source: base + 'private: "true"\n', diagnostic: { message: 'expected an unquoted boolean', line: 3, column: 10 } },
	{ name: 'nonboolean private', source: base + 'private: yes\n', diagnostic: { message: 'expected true or false', line: 3, column: 10 } },
	{ name: 'parent entry', source: base + 'entry: ../main.zx\n', diagnostic: { message: 'entry must be a package-relative .zx file path', line: 3, column: 8 } },
	{ name: 'absolute entry', source: base + 'entry: /main.zx\n', diagnostic: { message: 'entry must be a package-relative .zx file path', line: 3, column: 8 } },
	{ name: 'wrong entry extension', source: base + 'entry: main.js\n', diagnostic: { message: 'entry must be a package-relative .zx file path', line: 3, column: 8 } },
	{ name: 'dependency sequence', source: base + 'dependencies: []\n', diagnostic: { message: 'expected a YAML mapping', line: 3, column: 15 } },
	{ name: 'unknown workspace field', source: base + 'workspace:\n  other: []\n', diagnostic: { message: 'unknown workspace field', line: 4, column: 3 } },
	{ name: 'workspace scalar', source: base + 'workspace:\n  packages: all\n', diagnostic: { message: 'workspace.packages must be a sequence', line: 4, column: 13 } },
	{ name: 'escaping workspace', source: base + 'workspace:\n  packages: [../outside]\n', diagnostic: { message: 'workspace package patterns must stay inside the workspace', line: 4, column: 14 } },
]

export default cases
