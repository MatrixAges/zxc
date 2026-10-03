import type { Iteration, SourceFile } from '../../../shared/types'
import { useState } from 'react'
import { Button } from '@/vendor/ui/button'
import rpc from '@/lib/rpc'

export default function SessionComposer({
	files,
	initial_module,
	previous,
	onStarted,
	onCancel
}: {
	files: Array<SourceFile>
	initial_module: string
	previous?: Iteration
	onStarted: () => void
	onCancel: () => void
}) {
	const [module_path, setModulePath] = useState(previous?.module ?? initial_module)
	const [prompt, setPrompt] = useState('')
	const [busy, setBusy] = useState(false)
	const [error, setError] = useState('')
	const modules = files.filter(file => file.kind === 'module')

	const submit = async () => {
		setBusy(true)
		setError('')
		try {
			await rpc.iterations.start.mutate({ module: module_path, prompt, previous_id: previous?.id })
			setPrompt('')
			onStarted()
		} catch (error) {
			setError(String(error))
		}
		setBusy(false)
	}

	return (
		<section className='panel composer'>
			<div className='panel-heading'>
				<h2>{previous ? '继续模块迭代' : '发起模块开发'}</h2>
				<span className='eyebrow'>CODEX SESSION</span>
			</div>
			<div className='p-5 space-y-4'>
				<label className='field-label'>
					关联模块
					<input
						className='text-field font-mono text-xs'
						list='module-paths'
						value={module_path}
						onChange={event => setModulePath(event.target.value)}
						disabled={!!previous || busy}
						placeholder='输入或选择模块路径'
					/>
					<datalist id='module-paths'>
						{modules.map(file => (
							<option value={file.path} key={file.path} />
						))}
					</datalist>
				</label>
				<label className='field-label'>
					本轮开发需求
					<textarea
						className='text-field min-h-32 resize-y'
						value={prompt}
						disabled={busy}
						onChange={event => setPrompt(event.target.value)}
						maxLength={12000}
						placeholder='描述最终目标、相关证据、修改边界和验收标准…'
					/>
				</label>
				{previous?.session_id && (
					<p className='font-mono text-[10px] break-all text-muted-foreground'>
						SESSION / {previous.session_id}
					</p>
				)}
				<p className='text-xs leading-6 text-muted-foreground'>
					{previous
						? '沿用原 session 和工作树，新建一份迭代文档。'
						: '创建独立工作树和真实 Codex session，不同模块可并行开发。'}
					<br />
					结果保留在工作树供审阅，不自动合入当前源码。
				</p>
				{error && (
					<p role='alert' className='error-message'>
						{error}
					</p>
				)}
				<div className='flex justify-end gap-2'>
					<Button variant='ghost' onClick={onCancel} disabled={busy}>
						收起
					</Button>
					<Button
						onClick={submit}
						disabled={busy || !prompt.trim() || !modules.some(file => file.path === module_path)}
					>
						{busy ? '正在创建…' : previous ? '继续此 session' : '启动 Codex 开发'}
					</Button>
				</div>
			</div>
		</section>
	)
}
