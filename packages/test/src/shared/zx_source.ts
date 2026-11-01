import ts from 'typescript'
import { execFileSync } from 'node:child_process'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'

function utilityImports(source: string): string {
    const parsed = ts.createSourceFile('source.ts', source, ts.ScriptTarget.Latest, true)
    const imported = new Set<string>()

    for (const statement of parsed.statements) {
        if (!ts.isImportDeclaration(statement) || !statement.importClause) continue

        const clause = statement.importClause
        if (clause.name) imported.add(clause.name.text)

        const bindings = clause.namedBindings
        if (bindings && ts.isNamedImports(bindings)) {
            for (const element of bindings.elements) imported.add(element.name.text)
        }
    }

    const scanner = ts.createScanner(ts.ScriptTarget.Latest, true, ts.LanguageVariant.Standard, source)
    const utilities = new Set<string>()
    const template_depths: Array<number> = []
    let brace_depth = 0
    let previous = ts.SyntaxKind.Unknown
    let token = scanner.scan()

    while (token !== ts.SyntaxKind.EndOfFileToken) {
        if (token === ts.SyntaxKind.TemplateHead) template_depths.push(brace_depth)
        if (token === ts.SyntaxKind.OpenBraceToken) brace_depth += 1

        if (token === ts.SyntaxKind.CloseBraceToken) {
            if (template_depths.at(-1) === brace_depth) {
                token = scanner.reScanTemplateToken(false)
                if (token === ts.SyntaxKind.TemplateTail) template_depths.pop()
            } else {
                brace_depth -= 1
            }
        }

        if (token === ts.SyntaxKind.Identifier && previous !== ts.SyntaxKind.DotToken) {
            const name = scanner.getTokenText()
            if (
                (name === 'map' || name === 'reduce') &&
                !imported.has(name) &&
                scanner.lookAhead(() => scanner.scan()) === ts.SyntaxKind.OpenParenToken
            ) {
                utilities.add(name)
            }
        }

        previous = token
        token = scanner.scan()
    }

    const names = [...utilities].sort()

    return names.length === 0 ? source : `import { ${names.join(', ')} } from "std:utils"\n\n${source}`
}

export default function zxSource(source: string, verbatim = false): string {
    const prepared = utilityImports(source)
    if (verbatim) return prepared

    const temporary_dir = mkdtempSync(join(tmpdir(), 'zxc-source-'))
    const input_path = join(temporary_dir, 'source.zx')
    const tool_path = process.env.ZXC ?? resolve(import.meta.dirname, '../../../../zig-out/bin/zxc')

    try {
        writeFileSync(input_path, prepared)
        execFileSync(tool_path, ['fmt', input_path, '--write'])

        return readFileSync(input_path, 'utf8')
    } finally {
        rmSync(temporary_dir, { recursive: true, force: true })
    }
}
