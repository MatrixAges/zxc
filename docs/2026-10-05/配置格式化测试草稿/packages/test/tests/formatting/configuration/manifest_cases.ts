type Case = { name: string; source: string; expected?: string; custom?: boolean }

const cases: Array<Case> = [
	{
		name: 'scalar fields compact',
		source: 'name: sample\n\nversion: 1.0.0\n\n\nprivate: true\n',
		expected: 'name: sample\nversion: 1.0.0\nprivate: true\n'
	},
	{
		name: 'multiline dependencies separate without resolution',
		source: 'name: sample\nversion: 1.0.0\ndependencies:\n  missing: "^1.0.0"\nprivate: true\n',
		expected: 'name: sample\nversion: 1.0.0\n\ndependencies:\n  missing: "^1.0.0"\n\nprivate: true\n'
	},
	{
		name: 'trailing scalar comments retain text',
		source: 'name: sample # 中文  > 保留\n\nversion: "1.0.0" # version\n',
		expected: 'name: sample # 中文  > 保留\nversion: "1.0.0" # version\n'
	},
	{
		name: 'standalone comment attaches to next field',
		source: 'name: sample\nversion: 1.0.0\n# workspace\nworkspace:\n  packages: ["pkgs/*", "!pkgs/ignored"]\n',
		expected: 'name: sample\nversion: 1.0.0\n\n# workspace\nworkspace:\n  packages: ["pkgs/*", "!pkgs/ignored"]\n'
	},
	{
		name: 'anchors aliases and unicode byte offsets',
		source: 'name: sample\nversion: 1.0.0\ninclude_paths: &paths\n  - "路径/头文件"\nlibrary_paths: *paths\nprivate: true\n',
		expected:
			'name: sample\nversion: 1.0.0\n\ninclude_paths: &paths\n  - "路径/头文件"\n\nlibrary_paths: *paths\nprivate: true\n'
	},
	{
		name: 'unicode quoted path and inline hash',
		source: 'name: sample\nversion: 1.0.0\nentry: "路径/文件 #1.zx"\nworkspace:\n  packages:\n    - "源码/*"\nprivate: true\n',
		expected:
			'name: sample\nversion: 1.0.0\nentry: "路径/文件 #1.zx"\n\nworkspace:\n  packages:\n    - "源码/*"\n\nprivate: true\n'
	},
	{
		name: 'folded scalar retains its trailing blank lines',
		source: 'name: sample\nversion: 1.0.0\nentry: >-\n  source\n  folder/main.zx\n\n\nprivate: true\n',
		expected: 'name: sample\nversion: 1.0.0\n\nentry: >-\n  source\n  folder/main.zx\n\n\nprivate: true\n'
	},
	{
		name: 'literal scalar retains its trailing blank lines',
		source: 'name: sample\nversion: |-\n  1.0.0\n\n\nentry: main.zx\n',
		expected: 'name: sample\n\nversion: |-\n  1.0.0\n\n\nentry: main.zx\n'
	},
	{
		name: 'flow root and custom manifest kind',
		custom: true,
		source: '{name: sample, version: 1.0.0, entry: "source folder/main.zx"}'
	},
	{
		name: 'UTF8 BOM retained',
		source: '\uFEFFname: sample\n\nversion: 1.0.0\n',
		expected: '\uFEFFname: sample\nversion: 1.0.0\n'
	},
	{
		name: 'document markers retained',
		source: '---\n\nname: sample\n\nversion: 1.0.0\n...\n',
		expected: '---\n\nname: sample\nversion: 1.0.0\n...\n'
	},
	{
		name: 'nested flow mapping only separates root fields',
		source: 'name: sample\nversion: 1.0.0\nworkspace: {\n  packages: ["pkgs/*"]\n}\nprivate: true\n',
		expected: 'name: sample\nversion: 1.0.0\n\nworkspace: {\n  packages: ["pkgs/*"]\n}\n\nprivate: true\n'
	}
]

cases.push(
	{
		name: 'interior BOM remains scalar content',
		source: 'name: sample\nversion: 1.0.0\nentry: "路径/\uFEFFmain.zx"\nworkspace:\n  packages: ["pkgs/*"]\n',
		expected: 'name: sample\nversion: 1.0.0\nentry: "路径/\uFEFFmain.zx"\n\nworkspace:\n  packages: ["pkgs/*"]\n'
	},
	{
		name: 'supplementary unicode comment before root fields',
		source: '# 说明😀\nname: sample\n\nversion: 1.0.0\n',
		expected: '# 说明😀\nname: sample\nversion: 1.0.0\n'
	}
)

const bom_cases = cases
	.filter(entry => !entry.source.startsWith('\uFEFF'))
	.map(entry => ({
		...entry,
		name: `BOM / ${entry.name}`,
		source: `\uFEFF${entry.source}`,
		expected: `\uFEFF${entry.expected ?? entry.source}`
	}))

export default [...cases, ...bom_cases]
