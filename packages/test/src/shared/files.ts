import { globSync } from 'node:fs'
import { resolve } from 'node:path'
import { package_dir } from './catalog.ts'

export function jsonFiles(directory: string): Array<string> {
	return globSync('**/*.jsonl', { cwd: resolve(package_dir, directory) })
		.sort()
		.map(path => resolve(package_dir, directory, path))
}
