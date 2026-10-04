import { resolve } from 'node:path'
import { package_dir, writeCatalog, writeOutput } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

type Sample = { path: string; sha256: string; names: Array<string> }

const sample = readRows<Sample>(resolve(package_dir, 'src/data/ascii_identifiers.jsonl'))[0]
const base = 'language/lexical/identifiers/ascii_lower/cases'
const values = [1n, 0n, 42n, 18446744073709551615n]
const branches = sample.names.map((name, index) => `    case ${index}:
      const ${name} = in.value

      return ${name}`).join('\n')
const rows = sample.names.flatMap((name, selector) => values.map(value => ({ id: `${base}/${name}/${value}`, input: { selector, value }, expected: { value } })))

writeOutput(`tests/${base}.zx`, 'export type Input = { selector: u64\n value: u64 }\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  switch (in.selector) {\n' + branches + '\n    default:\n      return 0\n  }\n}\n')
writeCatalog(`tests/${base}.jsonl`, rows)
writeCatalog('upstream/reviews/language/lexical/ascii_identifiers.jsonl', [{
	path: sample.path,
	sha256: sample.sha256,
	status: 'adapted',
	reason: '保留26个原始小写字母名称，var改const，在独立分支声明后通过原名称读取。使用原值1及0、42、u64最大值输入检验，不以重命名或直接返回输入替代绑定解析。',
	contract: 'packages/lint/src/root.zig',
	cases: rows.map(row => row.id),
	assertions: rows.map(row => ({ case: row.id, field: 'value', expected: row.expected.value }))
}])
