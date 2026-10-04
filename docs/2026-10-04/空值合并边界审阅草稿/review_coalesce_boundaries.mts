import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

const root = '/Users/xiewendao/Documents/MatrixAges/zxc'
const package_dir = join(root, 'packages/test')
const upstream = '/tmp/zxc-test262-reference/test262-7ab7fafa0003f73fc85c1b95d88094d33f7eb8bd'
const readRows = <T>(path: string): Array<T> => readFileSync(path, 'utf8').trim().split('\n').map(line => JSON.parse(line) as T)
const index = new Map(readRows<{ path: string; sha256: string }>(join(package_dir, 'upstream/index/language.jsonl')).map(row => [row.path, row.sha256]))
const decisions = [
	['chainable-with-bitwise-and.js', '四项分别要求 null/undefined 触发 42 & 43 得 42，false/true 保留自身。当前 ZX 完整操作符集合不含按位 AND，不能用 && 或常量 42 替换；另外独立 undefined 与异型回退也不提供。仅排除当前语言范围，未来加入位运算时必须重审。', 'docs/zx_design_doc.md#63-操作符'],
	['chainable-with-bitwise-or.js', '四项分别要求 null/undefined 触发 1 | 42 得 43，false/true 保留自身。当前 ZX 操作符集合不含按位 OR，不能用 || 或固定 43 替换；类型语法中的 | 也不是运行按位 OR。未来加入此运算符时必须重审。', 'docs/zx_design_doc.md#63-操作符'],
	['chainable-with-bitwise-xor.js', '四项分别要求 null/undefined 触发 1 ^ 42 得 43，false/true 保留自身。当前 ZX 操作符集合不含按位 XOR，不能用不等比较或预先算好的 43 作为实现证据。未来加入此运算符时必须重审。', 'docs/zx_design_doc.md#63-操作符'],
	['follows-undefined.js', '四项均以独立 undefined 为左值，结果分别为 42、undefined、null、false；ZX 明确没有独立 undefined 值。不能将其换成 optional null 后声称本文件已执行，故本文件整体排除；null 的适用测试另行保留。', 'docs/zx_design_doc.md'],
	['short-circuit-number-symbol.js', '十一项均要求同一 Symbol 在链首或空值后保留身份。ZX 明确没有 Symbol 类型，普通 bool/string/记录的保留或指针身份测试不能替代 Symbol 身份，故整体排除。', 'docs/zx_design_doc.md'],
	['tco-pos-null.js', '要求 null ?? f(n-1) 的递归调用在 MAX_ITERATIONS 深度尾调用执行且基例计数一次。ZX 调用图必须无环，不提供递归，因此普通 null 回退成功不能证明该尾调用保证，整体排除。', 'packages/zx/IR契约.md#类型模块与符号'],
	['tco-pos-undefined.js', '要求 undefined ?? f(n-1) 的递归尾调用在 MAX_ITERATIONS 深度成功且基例计数一次。ZX 同时不提供独立 undefined 与递归，不以普通 optional fallback 或有限函数链替代，整体排除。', 'docs/zx_design_doc.md'],
]

const reviews = decisions.map(([file, reason, contract]) => {
	const path = `test/language/expressions/coalesce/${file}`
	const sha256 = createHash('sha256').update(readFileSync(join(upstream, path))).digest('hex')

	assert.equal(index.get(path), sha256)

	return { path, sha256, status: 'excluded', reason, contract, cases: [] }
})

writeFileSync(join(package_dir, 'upstream/reviews/language/expressions/coalesce_boundaries.jsonl'), reviews.map(row => JSON.stringify(row)).join('\n') + '\n')
console.log(`${reviews.length} individually reviewed boundary files written`)
