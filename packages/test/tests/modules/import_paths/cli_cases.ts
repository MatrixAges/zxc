type Case = {
	name: string
	files: Record<string, string>
	outcome: { increment: number } | { diagnostic: RegExp }
}

const identity = `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return in
}
`

const helper = identity.replace('return in', 'return in + 1')
const shared = 'export enum Mode { First, Second }\n\nexport type Count = u64\n'
const suffix_diagnostic = /project imports must omit the \.zx extension; runtime and RX imports are forbidden/

function mainSource(paths: Array<string>): string {
	const imports = paths
		.map((path, index) => {
			const separator = index > 0 && paths[index - 1].startsWith('@/') !== path.startsWith('@/') ? '\n' : ''

			return separator + `import helper${index} from "${path}"`
		})
		.join('\n')
	const value = paths.reduce((value, _, index) => `helper${index}(${value})`, 'in')

	return imports + '\n\n' + identity.replace('return in', `return ${value}`)
}

const cases: Array<Case> = [
	...[
		{ name: 'relative', path: './helper', target: 'app/helper.zx' },
		{ name: 'parent directory', path: '../shared/helper', target: 'shared/helper.zx' },
		{ name: 'project root', path: '@/app/helper', target: 'app/helper.zx' },
		{ name: 'normalized directory', path: './nested/../helper', target: 'app/helper.zx' },
		{ name: 'dots in directory', path: '../v1.2/helper', target: 'v1.2/helper.zx' }
	].map(entry => ({
		name: entry.name,
		files: { 'app/main.zx': mainSource([entry.path]), [entry.target]: helper },
		outcome: { increment: 1 }
	})),
	{
		name: 'repeated normalized references share a function',
		files: {
			'app/main.zx': mainSource(['@/app/helper', './helper', './nested/../helper']),
			'app/helper.zx': helper
		},
		outcome: { increment: 3 }
	},
	{
		name: 'type and enum identity across relative and root paths',
		files: {
			'types/shared.zx': shared,
			'app/helper.zx': `import { Mode } from "../types/./shared"

import type { Count } from "../types/shared"

export type Input = { value: Count, mode: Mode }

export type Output = Count

export default function (in: Input): Output {
  return in.mode == Mode.Second ? in.value + 1 : in.value
}
`,
			'app/main.zx': `import { Mode } from "../types/shared"
import helper from "./helper"

import type { Count } from "@/types/shared"

export type Input = Count

export type Output = Count

export default function (in: Input): Output {
  return helper({ value: in, mode: Mode.Second })
}
`
		},
		outcome: { increment: 1 }
	},
	...['./helper.zx', '@/app/helper.zx', '../app/helper.zx'].map(path => ({
		name: `reject explicit function suffix ${path}`,
		files: { 'app/main.zx': mainSource([path]), 'app/helper.zx': helper },
		outcome: { diagnostic: suffix_diagnostic }
	})),
	...['import type { Count }', 'import { Mode }'].map(declaration => ({
		name: `reject explicit suffix ${declaration}`,
		files: { 'app/main.zx': `${declaration} from "../types/shared.zx"\n\n${identity}`, 'types/shared.zx': shared },
		outcome: { diagnostic: suffix_diagnostic }
	})),
	{
		name: 'reject directory index fallback',
		files: { 'app/main.zx': mainSource(['./helper']), 'app/helper/index.zx': helper },
		outcome: { diagnostic: /import target is missing from the source set/ }
	},
	{
		name: 'reject normalized cycle through unused imports',
		files: {
			'app/main.zx': 'import helper from "./nested/../helper"\n\n' + identity,
			'app/helper.zx': 'import main from "@/app/main"\n\n' + identity
		},
		outcome: { diagnostic: /ZX module imports must be acyclic, including unused imports/ }
	}
]

export default cases
