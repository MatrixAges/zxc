const stages = [
	{ title: 'INPUT, MADE EXPLICIT', anchor: '.home-intro', height: 350, side: 'right' },
	{
		title: 'SMALL UNITS, ONE SYSTEM',
		before: true,
		anchor: '[aria-labelledby="why-zxc"]',
		height: 280,
		side: 'left'
	},
	{
		title: 'DEPENDENCIES IN ONE DIRECTION',
		anchor: '[aria-labelledby="two-files"]',
		height: 300,
		side: 'right'
	},
	{
		title: 'TYPED DATA IN MOTION',
		anchor: '[aria-labelledby="how-it-works"]',
		height: 560,
		side: 'left'
	},
	{
		title: 'STRUCTURE AT EVERY SCALE',
		anchor: '[aria-labelledby="for-agents"]',
		height: 440,
		side: 'right'
	}
]

export type StagePlacement = { center: number; height: number }

export default stages
