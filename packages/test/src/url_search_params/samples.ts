type Entry = { key: string; value: string }

const pairs: Array<{ name: string; pairs: Array<[string, string]> }> = [
	{ name: 'empty', pairs: [] },
	{
		name: 'empty_fields',
		pairs: [
			['', ''],
			['', 'x'],
			['a', '']
		]
	},
	{
		name: 'duplicates',
		pairs: [
			['a', '1'],
			['b', '2'],
			['a', '3'],
			['a', '1']
		]
	},
	{
		name: 'case_sensitive',
		pairs: [
			['a', 'x'],
			['A', 'y'],
			['a', 'X']
		]
	},
	{
		name: 'numeric_order',
		pairs: [
			['10', 'ten'],
			['2', 'two'],
			['0', 'zero']
		]
	},
	{
		name: 'special_names',
		pairs: [
			['__proto__', 'a'],
			['constructor', 'b'],
			['toString', 'c']
		]
	},
	{
		name: 'encoding',
		pairs: [
			['a b', '+'],
			['&=', '%'],
			['?', '#'],
			['~!*', "'()"]
		]
	},
	{
		name: 'unicode',
		pairs: [
			['中文', '🌱'],
			['é', 'é'],
			['é', 'é']
		]
	},
	{
		name: 'nul',
		pairs: [
			['\0', 'a\0b'],
			['a', '\0']
		]
	},
	{
		name: 'utf16_order',
		pairs: [
			['\uE000', 'bmp'],
			['𐀀', 'astral'],
			['\uD7FF', 'before'],
			['😀', 'emoji']
		]
	},
	{
		name: 'prefixes',
		pairs: [
			['aa', '1'],
			['a', '2'],
			['aaa', '3'],
			['', '4']
		]
	},
	{
		name: 'stable_duplicates',
		pairs: Array.from({ length: 40 }, (_, index) => [index % 3 ? 'a' : 'b', String(index)])
	}
]

const samples: Array<{ name: string; entries: Array<Entry> }> = pairs.map(sample => ({
	name: sample.name,
	entries: sample.pairs.map(([key, value]) => ({ key, value }))
}))

for (let code = 0; code < 128; code++) {
	samples.push({
		name: `ascii_${code}`,
		entries: [{ key: String.fromCharCode(code), value: String.fromCharCode(code) }]
	})
}

export default samples
