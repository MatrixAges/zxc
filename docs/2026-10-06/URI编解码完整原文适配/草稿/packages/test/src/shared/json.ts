import { readFileSync } from 'node:fs'

export type Json = null | boolean | number | bigint | string | Array<Json> | { [key: string]: Json }

export function parseJson<T>(text: string): T {
    return JSON.parse(text, (_key, value: unknown, context?: { source?: string }) => {
        if (
            typeof value === 'number' &&
            Number.isInteger(value) &&
            !Number.isSafeInteger(value) &&
            context?.source &&
            /^-?\d+$/.test(context.source)
        ) {
            return BigInt(context.source)
        }

        return value
    }) as T
}

export function rawJson(text: string): unknown {
    return (JSON as typeof JSON & { rawJSON(text: string): unknown }).rawJSON(text)
}

export function stringify(value: unknown): string {
    return JSON.stringify(value, (_key, item: unknown) => (typeof item === 'bigint' ? rawJson(String(item)) : item))
}

export function asciiJson(value: unknown): string {
    return stringify(value).replace(
        /[\u007f-\uffff]/g,
        character => `\\u${character.charCodeAt(0).toString(16).padStart(4, '0')}`
    )
}

export function readRows<T>(path: string): Array<T> {
    const text = readFileSync(path, 'utf8')

    return text.trimEnd()
        ? text
              .trimEnd()
              .split('\n')
              .map(line => parseJson<T>(line))
        : []
}

export function jsonLines(rows: Array<unknown>): string {
    return rows.map(row => asciiJson(row) + '\n').join('')
}
