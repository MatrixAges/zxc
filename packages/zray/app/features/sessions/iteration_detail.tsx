import type { Iteration, WorktreeDiff } from '../../../shared/types'
import { useState } from 'react'
import { Button } from '@/vendor/ui/button'
import StatusBadge from '@/components/status_badge'
import DiffView from '@/components/diff_view'
import rpc from '@/lib/rpc'

export default function IterationDetail({
	iteration,
	onContinue
}: {
	iteration: Iteration
	onContinue: (iteration: Iteration) => void
}) {
	const [error, setError] = useState('')
	const [content, setContent] = useState('')
	const [changes, setChanges] = useState<WorktreeDiff>()
	const [content_title, setContentTitle] = useState('')
	const [busy, setBusy] = useState(false)
	const active = ['running', 'starting'].includes(iteration.status)

	const stop = async () => {
		setBusy(true)
		try {
			await rpc.iterations.stop.mutate({ id: iteration.id })
		} catch (error) {
			setError(String(error))
		}
		setBusy(false)
	}
	const inspect = async (kind: 'document' | 'diff') => {
		setBusy(true)
		setError('')
		try {
			if (kind === 'diff') {
				setChanges(await rpc.iterations.diff.query({ id: iteration.id }))
			} else {
				const result = await rpc.iterations.document.query({ id: iteration.id })
				setContent(result.content)
				setChanges(undefined)
			}
			setContentTitle(kind === 'document' ? iteration.document : '工作树变更（包含初始工作区差异）')
		} catch (error) {
			setError(String(error))
		}
		setBusy(false)
	}

	return (
		<section className='panel overflow-hidden'>
			<div className='panel-heading gap-4'>
				<div className='min-w-0'>
					<h2 className='truncate'>{iteration.prompt}</h2>
					<p className='mt-2 font-mono text-[10px] text-muted-foreground break-all'>{iteration.module}</p>
				</div>
				<StatusBadge status={iteration.status} />
			</div>
			<div className='p-5 space-y-4'>
				<dl className='session-meta'>
					<div>
						<dt>SESSION</dt>
						<dd>{iteration.session_id ?? '等待 Codex 返回 session ID'}</dd>
					</div>
					<div>
						<dt>WORKTREE</dt>
						<dd>{iteration.worktree}</dd>
					</div>
					<div>
						<dt>ITERATION DOC</dt>
						<dd>{iteration.document}</dd>
					</div>
				</dl>
				<div className='flex gap-2 flex-wrap'>
					<Button variant='outline' size='sm' disabled={busy} onClick={() => inspect('document')}>
						迭代文档
					</Button>
					<Button
						variant='outline'
						size='sm'
						disabled={busy || !iteration.base_commit}
						onClick={() => inspect('diff')}
					>
						查看变更
					</Button>
					{active ? (
						<Button variant='outline' size='sm' disabled={busy} onClick={stop}>
							停止开发
						</Button>
					) : (
						<Button size='sm' disabled={!iteration.session_id} onClick={() => onContinue(iteration)}>
							继续迭代
						</Button>
					)}
				</div>
				{error && (
					<p className='error-message' role='alert'>
						{error}
					</p>
				)}
				{content_title ? (
					<div>
						<div className='flex gap-3 items-center justify-between mb-3'>
							<h3 className='text-xs break-all'>{content_title}</h3>
							<Button size='sm' variant='ghost' onClick={() => setContentTitle('')}>
								返回动态
							</Button>
						</div>
						{changes ? <DiffView changes={changes} /> : <pre className='document-content'>{content}</pre>}
					</div>
				) : (
					<div className='event-stream' aria-label='会话动态'>
						{!iteration.events.length && (
							<p className='text-sm text-muted-foreground p-4'>
								{iteration.status === 'starting'
									? '正在准备独立工作树…'
									: iteration.summary || '尚无会话事件'}
							</p>
						)}
						{iteration.events.map((event, index) => (
							<details
								className='event-item'
								key={`${event.at}-${index}`}
								open={
									event.type === 'item.completed' && event.text.startsWith('agent_message')
										? true
										: undefined
								}
							>
								<summary>
									<span className='event-dot' />
									<span className='truncate flex-1'>{event.text.split('\n')[0]}</span>
									<time>{new Date(event.at).toLocaleTimeString('zh-CN', { hour12: false })}</time>
								</summary>
								<pre>{event.text}</pre>
							</details>
						))}
					</div>
				)}
			</div>
		</section>
	)
}
