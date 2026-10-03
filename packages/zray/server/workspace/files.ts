import type { SourceFile, Workspace } from '../../shared/types.ts'
import { readdir, readFile, realpath } from 'node:fs/promises'
import { extname, resolve, sep } from 'node:path'
import { execFileAsync } from '../processes.ts'

const excluded = new Set(['node_modules', '.git', '.zig-cache', 'zig-out', 'dist', 'vendor', 'generated'])
const extensions = new Set(['.zig', '.zx', '.rx'])

export default class WorkspaceFiles {
	private root: string

	constructor(root: string) {
		this.root = root
	}

	async list(): Promise<Workspace> {
		const files: Array<SourceFile> = []
		const packages: Workspace['packages'] = []

		const walk = async (directory: string, package_name: string) => {
			for (const entry of await readdir(resolve(this.root, directory), { withFileTypes: true })) {
				if (excluded.has(entry.name) || entry.name.startsWith('.')) continue

				const path = `${directory}/${entry.name}`

				if (entry.isDirectory()) await walk(path, package_name)
				if (!entry.isFile() || !extensions.has(extname(path))) continue
				if (!path.includes('/src/') && !path.includes('/examples/') && !path.includes('/tests/')) continue

				files.push({
					path,
					package: package_name,
					kind: path.includes('/tests/') ? 'test' : 'module',
					language: extname(path).slice(1)
				})
			}
		}

		for (const entry of await readdir(resolve(this.root, 'packages'), { withFileTypes: true })) {
			if (!entry.isDirectory() || entry.name === 'zray') continue

			const directory = `packages/${entry.name}`
			const children = await readdir(resolve(this.root, directory))
			if (!children.includes('build.zig')) continue

			const build = await readFile(resolve(this.root, directory, 'build.zig'), 'utf8')
			packages.push({ name: entry.name, runnable: /\.step\(\s*"test"\s*,/.test(build) })
			await walk(directory, entry.name)
		}

		return { name: 'zxc', files: files.sort((a, b) => a.path.localeCompare(b.path)), packages }
	}

	async versions() {
		const [zig, manifest] = await Promise.all([
			execFileAsync('zig', ['version'], { timeout: 5000 })
				.then(result => result.stdout.trim())
				.catch(() => null),
			readFile(resolve(this.root, 'build.zig.zon'), 'utf8')
		])

		return { zig, zxc: manifest.match(/\.version\s*=\s*"([^"]+)"/)?.[1] ?? null }
	}

	async source(path: string) {
		const workspace = await this.list()
		if (!workspace.files.some(file => file.path === path)) throw new Error('文件不在工作区索引中')

		const resolved = await realpath(resolve(this.root, path))
		if (!resolved.startsWith(`${await realpath(this.root)}${sep}`)) throw new Error('文件超出工作区')

		return { path, content: await readFile(resolved, 'utf8') }
	}
}
