import type { Node } from 'typescript'
import { createRequire } from 'node:module'

const ts: typeof import('typescript') = createRequire(new URL('../../../packages/test/package.json', import.meta.url))(
	'typescript'
)
import rewriteSource from './source.ts'

type Edit = { start: number; end: number; text: string }

function isSource(value: string, fragments: boolean): boolean {
	if (/\bexport\s+(?:type|enum|default|declare)\b/.test(value) || /^\s*import\s+.+\s+from\s/.test(value)) return true
	if (!fragments || /\b(?:pub\s+(?:fn|const)|fn\s+\w+|static\s+inline|typedef|#include|std\.)|@import/.test(value))
		return false

	return (
		/^\s*\$[A-Za-z_]\w*\./.test(value) ||
		/(?:^|[\n{}])\s*(?:return|const|let|var|if|switch|case|default|while|for|throw|store)\b/.test(value) ||
		/^\s*\{[\s\S]*:\s*(?:bool|string|void|[ufi]\d+|[A-Z]\w*)[\s\S]*;[\s\S]*\}\s*$/.test(value)
	)
}

function encode(value: string, quote: string): string {
	let result = ''

	for (let index = 0; index < value.length; index++) {
		const character = value[index]

		if (character === '\\' || character === quote) result += '\\' + character
		else if (character === '\n') result += quote === '`' ? '\n' : '\\n'
		else if (character === '\r') result += '\\r'
		else if (character === '\t') result += '\\t'
		else if (quote === '`' && character === '$' && value[index + 1] === '{') result += '\\$'
		else result += character
	}

	return result
}

function apply(source: string, edits: Array<Edit>): string {
	let result = source

	for (const edit of edits.sort((left, right) => right.start - left.start))
		result = result.slice(0, edit.start) + edit.text + result.slice(edit.end)

	return result
}

export function typescript(source: string, fragments = false): string {
	const file = ts.createSourceFile('source.ts', source, ts.ScriptTarget.Latest, true, ts.ScriptKind.TS)
	const edits: Array<Edit> = []

	function visit(node: Node): void {
		const parent = node.parent

		if (
			parent &&
			ts.isCallExpression(parent) &&
			parent.arguments[0] === node &&
			ts.isPropertyAccessExpression(parent.expression) &&
			['includes', 'startsWith', 'endsWith', 'indexOf', 'lastIndexOf', 'replace', 'replaceAll'].includes(
				parent.expression.name.text
			)
		)
			return

		if (ts.isTemplateExpression(node)) {
			const parts = [node.head, ...node.templateSpans.map(span => span.literal)]
			const combined = parts.map(part => part.text).join('\x01')

			if (isSource(combined, fragments)) {
				const converted = rewriteSource(Buffer.from(combined)).toString()
				let offset = 0

				for (const part of parts) {
					const piece = converted.slice(offset, offset + part.text.length)
					const clean = piece
						.split('')
						.filter((character, index) => !(part.text[index] === ';' && character === ' '))
						.join('')

					if (clean !== part.text)
						edits.push({
							start: part.getStart(file) + 1,
							end: part.end - (part.kind === ts.SyntaxKind.TemplateTail ? 1 : 2),
							text: encode(clean, '`')
						})
					offset += part.text.length + 1
				}

				for (const span of node.templateSpans) visit(span.expression)
				return
			}

			if (/\bpub\s+(?:fn|const)|@import|static\s+inline|#include/.test(combined)) return
		}

		if ((ts.isStringLiteral(node) || ts.isNoSubstitutionTemplateLiteral(node)) && isSource(node.text, fragments)) {
			const converted = rewriteSource(Buffer.from(node.text), false).toString()
			const quote = source[node.getStart(file)]

			if (converted !== node.text)
				edits.push({ start: node.getStart(file) + 1, end: node.end - 1, text: encode(converted, quote) })
			return
		}

		ts.forEachChild(node, visit)
	}

	visit(file)

	return apply(source, edits)
}

export function zig(source: string, fragments = false): string {
	const edits: Array<Edit> = []
	const multiline = [...source.matchAll(/(?:^[ \t]*\\\\[^\r\n]*(?:\r?\n|$))+/gm)]

	for (const match of source.matchAll(/"(?:[^"\\\r\n]|\\.)*"/g)) {
		if (multiline.some(block => match.index >= block.index && match.index < block.index + block[0].length)) continue

		let value: string

		try {
			value = JSON.parse(match[0]) as string
		} catch {
			continue
		}

		if (!isSource(value, fragments)) continue

		const converted = rewriteSource(Buffer.from(value), false).toString()

		if (converted !== value)
			edits.push({ start: match.index, end: match.index + match[0].length, text: JSON.stringify(converted) })
	}

	for (const match of source.matchAll(/(?:^[ \t]*\\\\[^\r\n]*(?:\r?\n|$))+/gm)) {
		const lines = match[0].trimEnd().split(/\r?\n/)
		const prefix = lines[0].match(/^[ \t]*\\\\/)?.[0]

		if (!prefix) continue

		const value = lines.map(line => line.replace(/^[ \t]*\\\\/, '')).join('\n')

		if (!isSource(value, fragments)) continue

		const converted = rewriteSource(Buffer.from(value), false).toString()

		if (converted !== value)
			edits.push({
				start: match.index,
				end: match.index + match[0].length,
				text:
					converted
						.split('\n')
						.map(line => prefix + line)
						.join('\n') + '\n'
			})
	}

	return apply(source, edits)
}
