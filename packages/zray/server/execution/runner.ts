import type { ChildProcess } from 'node:child_process'
import type { Run } from '../../shared/types.ts'
import { spawn } from 'node:child_process'
import { randomUUID } from 'node:crypto'
import { resolve } from 'node:path'
import { stopProcess } from '../processes.ts'

export default class TestRunner {
	runs: Array<Run> = []
	private processes = new Map<string, ChildProcess>()

	private root: string

	constructor(root: string) {
		this.root = root
	}

	start(package_name: string) {
		if (this.runs.some(run => run.package === package_name && run.status === 'running'))
			throw new Error('该包的测试正在执行')

		const run: Run = {
			id: randomUUID(),
			package: package_name,
			status: 'running',
			output: '$ zig build test\n',
			started_at: new Date().toISOString()
		}
		const child = spawn('zig', ['build', 'test'], {
			cwd: resolve(this.root, 'packages', package_name),
			detached: true
		})
		this.runs = [run, ...this.runs].slice(0, 30)
		this.processes.set(run.id, child)

		const append = (data: Buffer) => {
			run.output = (run.output + data.toString()).slice(-200_000)
		}
		child.stdout?.on('data', append)
		child.stderr?.on('data', append)
		child.on('error', error => {
			run.output += `\n无法启动 Zig：${error.message}\n请安装仓库要求的 Zig 版本，并确保启动 zray 的终端可以执行 zig。`
			run.status = 'failed'
		})
		child.on('close', code => {
			if (run.status === 'running') run.status = code === 0 ? 'passed' : 'failed'
			run.finished_at = new Date().toISOString()
			run.output += `\n[${run.status}] exit=${code ?? '未启动 / 信号终止'}`
			this.processes.delete(run.id)
		})

		return run
	}

	stop(id: string) {
		const child = this.processes.get(id)
		const run = this.runs.find(item => item.id === id)
		if (!child || !run) throw new Error('测试进程未运行')

		run.status = 'cancelled'
		stopProcess(child)
	}

	close() {
		for (const id of this.processes.keys()) this.stop(id)
	}
}
