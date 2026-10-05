type Case = { name: string; input: Array<Array<string>>; output: string; failure?: string }

const cases: Array<Case> = [
	{ name: 'empty', input: [], output: 'done\n' },
	{ name: 'single', input: [['x\n']], output: 'x\ndone\n' },
	{ name: 'ordered', input: [['first\n'], ['second\n'], ['third\n']], output: 'first\nsecond\nthird\ndone\n' },
	{ name: 'repeated', input: [['a\n'], ['a\n'], ['b\n']], output: 'a\na\nb\ndone\n' },
	{
		name: 'unused columns',
		input: [
			['x\n', 'hidden\n'],
			['y\n', 'unused\n']
		],
		output: 'x\ny\ndone\n'
	},
	{ name: 'empty text', input: [[''], ['last\n']], output: 'last\ndone\n' },
	{ name: 'first failure', input: [[], ['unreachable\n']], output: '', failure: 'IndexOutOfBounds' },
	{
		name: 'middle failure',
		input: [['first\n'], [], ['unreachable\n']],
		output: 'first\n',
		failure: 'IndexOutOfBounds'
	},
	{
		name: 'last failure',
		input: [['first\n'], ['second\n'], []],
		output: 'first\nsecond\n',
		failure: 'IndexOutOfBounds'
	},
	{
		name: 'long ordered input',
		input: Array.from({ length: 40 }, (_, index) => [String(index) + '|']),
		output: Array.from({ length: 40 }, (_, index) => String(index) + '|').join('') + 'done\n'
	}
]

export default cases
