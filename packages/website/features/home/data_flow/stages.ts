const stages = [
	{ id: 'source', anchor: '.home-intro', height: 350, side: 'right' },
	{
		id: 'composition',
		before: true,
		anchor: '[aria-labelledby="why-zxc"]',
		height: 280,
		side: 'left'
	},
	{
		id: 'dependencies',
		anchor: '[aria-labelledby="two-files"]',
		height: 300,
		side: 'right'
	},
	{
		id: 'data',
		anchor: '[aria-labelledby="how-it-works"]',
		height: 560,
		side: 'left'
	},
	{
		id: 'structure',
		anchor: '[aria-labelledby="for-agents"]',
		height: 440,
		side: 'right'
	}
]

export type StagePlacement = { center: number; height: number }

export default stages
