import type { Iteration } from '../../shared/types.ts'
import { mkdir, readFile, readdir, rename, writeFile } from 'node:fs/promises'
import { dirname, resolve } from 'node:path'

export default class IterationStore {
	private root: string

	constructor(root: string) {
		this.root = root
	}

	async load(): Promise<Array<Iteration>> {
		const directory = resolve(this.root, '.zxc/zray/iterations')
		await mkdir(directory, { recursive: true })

		return Promise.all(
			(await readdir(directory))
				.filter(name => name.endsWith('.json'))
				.map(async name => {
					return JSON.parse(await readFile(resolve(directory, name), 'utf8')) as Iteration
				})
		)
	}

	async save(iteration: Iteration) {
		const directory = resolve(this.root, '.zxc/zray/iterations')
		await mkdir(directory, { recursive: true })
		const path = resolve(directory, `${iteration.id}.json`)
		await writeFile(`${path}.tmp`, JSON.stringify(iteration, null, 2))
		await rename(`${path}.tmp`, path)
		await this.document(iteration)
	}

	async document(iteration: Iteration) {
		const path = resolve(this.root, iteration.document)
		await mkdir(dirname(path), { recursive: true })
		const quote = (value: string) =>
			value
				.split('\n')
				.slice(0, 280)
				.map(line => `> ${line}`)
				.join('\n')
		const content = `# 模块迭代：${iteration.module}\n\n## Intent：最终目标\n\n${quote(iteration.prompt)}\n\n## Data：可用证据\n\n- 迭代 ID：${iteration.id}\n- Codex session：${iteration.session_id ?? '等待创建'}\n- 前次迭代：${iteration.previous_id ?? '无'}\n- 开始：${iteration.started_at}\n- 结束：${iteration.finished_at ?? '尚未结束'}\n- 基线提交：${iteration.base_commit || '准备中'}\n- 工作树：${iteration.worktree}\n\n## Edges：边界与限制\n\n- 独立 Git worktree；初始内容来自 HEAD、已跟踪文件的工作区差异及目标包的未跟踪源码。\n- session 仅在用户启动后执行，使用 workspace-write 沙箱。\n- 结果保留在工作树中，需要人工审阅、合入；完成状态不代表已验证正确。\n- 完整输出见事件日志（文档摘录每节最多 280 行）：.zxc/zray/events/${iteration.id}.jsonl\n\n## Answer：结果与成功标准\n\n- 状态：${iteration.status}\n\n### 会话结果\n\n${quote(iteration.summary || '尚无最终输出。')}\n\n### 工作树累计变更（包含初始工作区差异）\n\n${quote(iteration.changes || '尚无变更记录。')}\n\n### 自我审查\n\n请结合会话输出、实际 diff 和验证证据确认需求是否满足；未执行的验证不能视为通过。\n`
		await writeFile(`${path}.tmp`, content)
		await rename(`${path}.tmp`, path)
	}
}
