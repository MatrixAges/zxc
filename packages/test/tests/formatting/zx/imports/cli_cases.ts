const body = `export type Input = u64

export type Output = u64

export default function (in: Input): Output {
  return in
}
`

const cases = [
	{
		name: 'fixed value and type categories',
		source: `import type { LocalType } from "./zeta"
import type { RootType } from "@/zeta"
import type { PackageType } from "zeta"
import type { CType } from "c:zeta"
import type { ZigType } from "zig:zeta"
import type { StdType } from "std:zeta"
import localFn from "./zeta"
import { Mode } from "@/mode"
import packageFn from "zeta"
import cFn from "c:zeta"
import zigFn from "zig:zeta"
import stdFn from "std:zeta"

`,
		expected: `import stdFn from "std:zeta"
import zigFn from "zig:zeta"
import cFn from "c:zeta"
import packageFn from "zeta"

import { Mode } from "@/mode"

import localFn from "./zeta"

import type { StdType } from "std:zeta"
import type { ZigType } from "zig:zeta"
import type { CType } from "c:zeta"
import type { PackageType } from "zeta"
import type { RootType } from "@/zeta"
import type { LocalType } from "./zeta"

`
	},
	{
		name: 'stable same path declarations and named bindings',
		source: 'import second from "./same"\nimport first from "./same"\nimport { Zebra, Alpha } from "./same"\nimport type { OtherType } from "./same"\nimport type { InputType } from "./same"\n\n',
		expected:
			'import second from "./same"\nimport first from "./same"\nimport { Zebra, Alpha } from "./same"\n\nimport type { OtherType } from "./same"\nimport type { InputType } from "./same"\n\n'
	},
	{
		name: 'case sensitive UTF8 and external scoped package',
		source: 'import greek from "./α"\nimport accented from "./É"\nimport lower from "./z"\nimport upper from "./Z"\nimport parent from "../parent"\nimport root from "@/root"\nimport ordinary from "alpha"\nimport scoped from "@scope/zeta"\n\n',
		expected:
			'import scoped from "@scope/zeta"\nimport ordinary from "alpha"\n\nimport root from "@/root"\n\nimport parent from "../parent"\nimport upper from "./Z"\nimport lower from "./z"\nimport accented from "./É"\nimport greek from "./α"\n\n'
	},
	{
		name: 'line comments stay attached',
		source: 'import zeta from "./zeta" // zeta 尾注释\nimport alpha from "./alpha" // alpha tail\n\n',
		expected: 'import alpha from "./alpha" // alpha tail\nimport zeta from "./zeta" // zeta 尾注释\n\n'
	},
	{
		name: 'internal and trailing block comments stay attached',
		source: 'import { /* inside */ Zebra, Alpha } from "./zeta" /* zeta */\nimport first from "./alpha" /* alpha */\n\n',
		expected:
			'import first from "./alpha" /* alpha */\nimport { /* inside */ Zebra, Alpha } from "./zeta" /* zeta */\n\n'
	},
	{
		name: 'file header pins first import',
		source: '// file header\nimport zeta from "./zeta"\nimport beta from "./beta"\nimport alpha from "./alpha"\n\n',
		expected:
			'// file header\nimport zeta from "./zeta"\nimport alpha from "./alpha"\nimport beta from "./beta"\n\n'
	},
	{
		name: 'independent comment separates sorting sections',
		source: 'import delta from "./delta"\nimport alpha from "./alpha"\n// boundary\nimport zeta from "./zeta"\nimport gamma from "./gamma"\nimport beta from "./beta"\n\n',
		expected:
			'import alpha from "./alpha"\nimport delta from "./delta"\n// boundary\nimport zeta from "./zeta"\nimport beta from "./beta"\nimport gamma from "./gamma"\n\n'
	},
	{
		name: 'multiline trailing comment moves as one unit',
		source: 'import zeta from "./zeta" /* first line\nsecond line */\nimport alpha from "./alpha"\n\n',
		expected: 'import alpha from "./alpha"\nimport zeta from "./zeta" /* first line\nsecond line */\n\n'
	},
	{ name: 'no imports', source: '', expected: '' },
	{
		name: 'single import',
		source: 'import single from "./single"\n\n',
		expected: 'import single from "./single"\n\n'
	},
	{
		name: 'excess internal blank lines',
		source: 'import alpha from "./alpha"\n\n\nimport zeta from "./zeta"\n\n',
		expected: 'import alpha from "./alpha"\nimport zeta from "./zeta"\n\n'
	}
].map(entry => ({ ...entry, source: entry.source + body, expected: entry.expected + body }))

export default cases
