import { copyFile, lstat, mkdir } from 'node:fs/promises'
import { spawn } from 'node:child_process'
import { dirname, resolve } from 'node:path'
import { execFileAsync } from '../processes.ts'

export default async function createWorktree(args: { root: string; path: string; module: string }) {
	const { root, path, module } = args
	const { stdout: base_commit } = await execFileAsync('git', ['rev-parse', 'HEAD'], { cwd: root })
	await mkdir(dirname(path), { recursive: true })
	await execFileAsync('git', ['worktree', 'add', '--detach', path, base_commit.trim()], { cwd: root })

	const { stdout: patch } = await execFileAsync('git', ['diff', 'HEAD', '--binary'], {
		cwd: root,
		maxBuffer: 20_000_000
	})
	if (patch) {
		await new Promise<void>((accept, reject) => {
			const child = spawn('git', ['apply', '--binary', '-'], { cwd: path })
			let error = ''
			child.stderr.on('data', data => {
				error += data.toString()
			})
			child.on('error', reject)
			child.stdin.on('error', reject)
			child.on('close', code => (code === 0 ? accept() : reject(new Error(error))))
			child.stdin.end(patch)
		})
	}

	const package_path = module.split('/').slice(0, 2).join('/')
	const { stdout: untracked } = await execFileAsync(
		'git',
		['ls-files', '--others', '--exclude-standard', '-z', '--', package_path],
		{ cwd: root }
	)
	for (const file of untracked.split('\0').filter(file => /\.(rx|zx|zig)$/.test(file))) {
		if (!(await lstat(resolve(root, file))).isFile()) continue
		const target = resolve(path, file)
		await mkdir(dirname(target), { recursive: true })
		await copyFile(resolve(root, file), target)
	}

	return base_commit.trim()
}
