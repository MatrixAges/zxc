import type { WorktreeDiff } from '../../shared/types.ts'
import { lstat, readFile } from 'node:fs/promises'
import { resolve } from 'node:path'
import { execFileAsync } from '../processes.ts'

export default async function readWorktreeDiff(worktree: string, base_commit: string): Promise<WorktreeDiff> {
	const { stdout: diff } = await execFileAsync('git', ['diff', base_commit, '--'], {
		cwd: worktree,
		maxBuffer: 4_000_000
	})
	const { stdout: status } = await execFileAsync('git', ['status', '--short'], { cwd: worktree })
	const { stdout: untracked } = await execFileAsync('git', ['ls-files', '--others', '--exclude-standard', '-z'], {
		cwd: worktree
	})
	const files: WorktreeDiff['files'] = []
	const omitted: Array<string> = []
	let remaining = 200_000

	for (const path of untracked.split('\0').filter(Boolean)) {
		const absolute_path = resolve(worktree, path)
		const metadata = await lstat(absolute_path)
		if (!metadata.isFile() || !/\.(zig|zx|rx|ts|tsx|js|mjs|json|md|css|html|yaml|yml)$/.test(path)) continue
		if (metadata.size > remaining) {
			omitted.push(path)
			continue
		}

		const content = await readFile(absolute_path, 'utf8')
		remaining -= metadata.size
		files.push({ path, content })
	}

	return { patch: diff, status, files, omitted }
}
