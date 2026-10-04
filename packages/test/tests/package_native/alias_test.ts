import { test } from 'node:test'
import checkAliases from './alias_fixture.ts'

const mapping = { name: 'zig:original', specifier: 'zig:first' }

test('native ABI aliases / omitted mapping exposes original declaration name', () => {
	checkAliases({ access: 'zig:first' })
})

test('native ABI aliases / explicit alias remaps the implementation type entry', () => {
	checkAliases({ aliases: [mapping], access: mapping.name })
})

test('native ABI aliases / two names preserve one canonical object identity', () => {
	checkAliases({ aliases: [mapping, { name: 'zig:forwarded', specifier: mapping.specifier }], access: mapping.name, second_access: 'zig:forwarded' })
})

test('native ABI aliases / identical duplicate mapping is idempotent', () => {
	checkAliases({ aliases: [mapping, mapping], access: mapping.name })
})

test('native ABI aliases / unknown declaration target rejects before publication', () => {
	checkAliases({ aliases: [{ ...mapping, specifier: 'zig:missing' }], access: mapping.name, error: /\bUnknownNativeAbiAlias\b/ })
})

test('native ABI aliases / one name cannot reference different declaration identities', () => {
	checkAliases({ aliases: [mapping, { ...mapping, specifier: 'zig:second' }], access: mapping.name, error: /\bConflictingNativeAbiAlias\b/ })
})

test('native ABI aliases / explicit empty mapping does not restore default names', () => {
	checkAliases({ aliases: [], access: 'zig:first', error: /has no member named 'zig:first'/ })
})

test('native ABI aliases / backend failure preserves the previous executable', () => {
	checkAliases({ aliases: [], access: 'zig:first', error: /has no member named 'zig:first'/, preserve_output: true })
})

test('native ABI aliases / failed build leaves neither binary nor assembly output', () => {
	checkAliases({ aliases: [], access: 'zig:first', error: /has no member named 'zig:first'/, assembly: true })
})

test('native ABI aliases / backend failure preserves binary and assembly together', () => {
	checkAliases({ aliases: [], access: 'zig:first', error: /has no member named 'zig:first'/, preserve_output: true, assembly: true })
})
