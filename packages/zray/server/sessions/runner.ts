import type { ChildProcess } from 'node:child_process'
import type { Iteration } from '../../shared/types.ts'
import { spawn } from 'node:child_process'
import { randomUUID } from 'node:crypto'
import { appendFileSync, mkdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { createInterface } from 'node:readline'
import IterationStore from './store.ts'
import consumeEvent from './events.ts'
import createWorktree from './worktree.ts'
import { execFileAsync, stopProcess } from '../processes.ts'

export default class SessionRunner {
	iterations: Array<Iteration> = []
	private processes = new Map<string, ChildProcess>()
	private store: IterationStore
	private writes = Promise.resolve()
	private closing = false

	private root: string
	private codex_bin: string

	constructor(root: string, codex_bin: string) {
		this.codex_bin = codex_bin
		this.root = root
		this.store = new IterationStore(root)
	}

	async init() {
		this.iterations = (await this.store.load()).sort((a, b) => b.started_at.localeCompare(a.started_at))
		for (const iteration of this.iterations) {
			if (!['starting', 'running'].includes(iteration.status)) continue
			iteration.status = 'interrupted'
			iteration.finished_at = new Date().toISOString()
			await this.store.save(iteration)
		}
	}

	async start(args: { module: string; prompt: string; previous_id?: string }) {
		const { module, prompt, previous_id } = args
		if (this.closing) throw new Error('服务正在关闭')
		const active = this.iterations.filter(
			item => ['starting', 'running'].includes(item.status) || this.processes.has(item.id)
		)
		if (active.length >= 3) throw new Error('最多同时开发 3 个模块，请等待或停止一个任务')
		if (active.some(item => item.module === module)) throw new Error('该模块已有运行中的会话')

		const previous = this.iterations.find(item => item.id === previous_id)
		if (previous_id && (!previous?.session_id || previous.module !== module)) throw new Error('无法继续该会话')

		const id = randomUUID()
		const day = new Intl.DateTimeFormat('en-CA', {
			timeZone: 'Asia/Shanghai',
			year: 'numeric',
			month: '2-digit',
			day: '2-digit'
		}).format(new Date())
		const iteration: Iteration = {
			id,
			module,
			prompt,
			previous_id,
			session_id: previous?.session_id,
			worktree: previous?.worktree ?? resolve(this.root, '.zxc/zray/worktrees', id),
			base_commit: previous?.base_commit ?? '',
			status: 'starting',
			started_at: new Date().toISOString(),
			document: `docs/${day}/zray/模块迭代-${id}.md`,
			events: [],
			summary: '',
			changes: ''
		}

		this.iterations.unshift(iteration)
		await this.persist(iteration)
		if (iteration.status === 'failed') throw new Error(iteration.summary)
		this.launch(iteration).catch(error => {
			iteration.status = 'failed'
			iteration.summary = String(error)
			iteration.finished_at = new Date().toISOString()
			this.persist(iteration)
		})
		return iteration
	}

	private async launch(iteration: Iteration) {
		if (!iteration.previous_id)
			iteration.base_commit = await createWorktree({
				root: this.root,
				path: iteration.worktree,
				module: iteration.module
			})
		if (iteration.status === 'cancelled' || iteration.status === 'failed' || this.closing) {
			await this.persist(iteration)
			return
		}

		const args = ['exec', '--json', '--sandbox', 'workspace-write', '-c', 'approval_policy="never"']
		if (iteration.session_id) args.push('resume', iteration.session_id)
		args.push('-')
		mkdirSync(resolve(this.root, '.zxc/zray/events'), { recursive: true })
		const child = spawn(this.codex_bin, args, { cwd: iteration.worktree, detached: true })
		this.processes.set(iteration.id, child)
		iteration.status = 'running'

		const recordEvent = (line: string) => {
			try {
				appendFileSync(resolve(this.root, '.zxc/zray/events', `${iteration.id}.jsonl`), line + '\n')
				consumeEvent(iteration, line)
				this.persist(iteration)
			} catch (error) {
				iteration.summary = `事件记录失败：${String(error)}`
				iteration.status = 'failed'
				stopProcess(child)
			}
		}
		createInterface({ input: child.stdout! }).on('line', recordEvent)
		child.stderr?.on('data', data => {
			recordEvent(JSON.stringify({ type: 'stderr', message: data.toString() }))
		})
		child.stdin?.on('error', error => {
			iteration.summary = error.message
		})
		child.on('error', error => {
			iteration.status = 'failed'
			iteration.summary = `Codex 启动失败：${error.message}`
		})
		child.on('close', code => {
			this.processes.delete(iteration.id)
			this.finish(iteration, code).catch(error => console.error('迭代归档失败', error))
		})
		child.stdin?.end(
			`模块：${iteration.module}\n\n需求：\n${iteration.prompt}\n\n在当前独立工作树中完成此模块迭代，遵循仓库 AGENTS.md。不要自动提交或合入。完成后清楚报告变更、验证证据、限制和自我审查。zray 会把本轮结果写入主仓库 ${iteration.document}。`
		)
		await this.persist(iteration)
	}

	private async finish(iteration: Iteration, code: number | null) {
		if (['running', 'starting'].includes(iteration.status)) iteration.status = code === 0 ? 'completed' : 'failed'
		iteration.finished_at = new Date().toISOString()
		if (!iteration.summary && iteration.status === 'failed') {
			iteration.summary =
				iteration.events
					.filter(event => ['stderr', 'error', 'turn.failed'].includes(event.type))
					.map(event => event.text)
					.join('\n') || `Codex 退出码：${code}`
		}
		try {
			const { stdout } = await execFileAsync('git', ['status', '--short'], { cwd: iteration.worktree })
			iteration.changes = stdout
		} catch (error) {
			iteration.status = 'failed'
			iteration.changes = `读取工作树失败：${String(error)}`
		}
		await this.persist(iteration)
	}

	private persist(iteration: Iteration) {
		const snapshot = structuredClone(iteration)
		this.writes = this.writes
			.then(() => this.store.save(snapshot))
			.catch(error => {
				iteration.status = 'failed'
				iteration.summary = `文档写入失败：${String(error)}`
				const child = this.processes.get(iteration.id)
				if (child) stopProcess(child)
				console.error(error)
			})
		return this.writes
	}

	stop(id: string) {
		const iteration = this.iterations.find(item => item.id === id)
		if (!iteration || !['starting', 'running'].includes(iteration.status)) throw new Error('会话未运行')
		iteration.status = 'cancelled'
		iteration.finished_at = new Date().toISOString()
		const child = this.processes.get(id)
		if (child) stopProcess(child)
		return this.persist(iteration)
	}

	close() {
		this.closing = true
		for (const iteration of this.iterations) {
			if (['starting', 'running'].includes(iteration.status)) this.stop(iteration.id)
		}
	}
}
