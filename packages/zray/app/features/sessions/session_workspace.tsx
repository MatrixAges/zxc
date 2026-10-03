import type { Iteration, SourceFile } from '../../../shared/types'
import { useState } from 'react'
import { Button } from '@/vendor/ui/button'
import StatusBadge from '@/components/status_badge'
import SessionComposer from './session_composer'
import IterationDetail from './iteration_detail'

export default function SessionWorkspace({
	files,
	iterations,
	initial_module = '',
	history = false,
	package_filter = ''
}: {
	files: Array<SourceFile>
	iterations: Array<Iteration>
	initial_module?: string
	history?: boolean
	package_filter?: string
}) {
	const [composing, setComposing] = useState(!!initial_module)
	const [previous, setPrevious] = useState<Iteration>()
	const [selected, setSelected] = useState('')
	const visible = iterations.filter(item => !package_filter || item.module.startsWith(`packages/${package_filter}/`))
	const current = visible.find(item => item.id === selected) ?? visible[0]
	const active = iterations.filter(item => ['running', 'starting'].includes(item.status))
	const groups = history
		? [{ title: '全部迭代', items: visible }]
		: [
				{ title: '正在开发', items: visible.filter(item => ['starting', 'running'].includes(item.status)) },
				{ title: '等待审阅', items: visible.filter(item => item.status === 'completed') },
				{
					title: '需要关注',
					items: visible.filter(item => ['failed', 'cancelled', 'interrupted'].includes(item.status))
				}
			]

	const continueSession = (iteration: Iteration) => {
		setPrevious(iteration)
		setComposing(true)
	}

	return (
		<div className='page-stack'>
			<div className='page-title'>
				<h1>{history ? '迭代记录' : '模块开发'}</h1>
				<Button
					disabled={active.length >= 3}
					onClick={() => {
						setPrevious(undefined)
						setComposing(true)
					}}
				>
					＋ 新建开发会话
				</Button>
			</div>
			{!history && (
				<div className='session-capacity'>
					<span className='flex gap-1'>
						{[0, 1, 2].map(index => (
							<span key={index} className={`capacity-slot ${index < active.length ? 'occupied' : ''}`} />
						))}
					</span>
					<span>{active.length} / 3 并行开发中</span>
					<span className='ml-auto text-muted-foreground'>Codex CLI · 本地会话</span>
				</div>
			)}
			{composing && (
				<SessionComposer
					key={previous?.id ?? initial_module}
					files={files}
					initial_module={initial_module}
					previous={previous}
					onCancel={() => setComposing(false)}
					onStarted={() => {
						setComposing(false)
						setSelected('')
					}}
				/>
			)}
			{!visible.length ? (
				<div className='panel empty-state large'>
					<span className='empty-symbol'>⌘</span>
					<h3>{history ? '还没有模块迭代记录' : '把一个想法交给 Codex'}</h3>
					<p>
						选择模块，描述这轮开发目标。
						<br />
						session 动态与迭代文档会随开发过程更新。
					</p>
					<Button
						variant='outline'
						onClick={() => {
							setPrevious(undefined)
							setComposing(true)
						}}
					>
						创建第一个会话
					</Button>
				</div>
			) : (
				<>
					<div className={history ? 'history-list' : 'kanban-grid'}>
						{groups.map(group => (
							<section className='kanban-column' key={group.title}>
								<h2>
									{group.title}
									<span>{group.items.length}</span>
								</h2>
								{group.items.length ? (
									group.items.map(item => (
										<button
											className={`session-card ${current?.id === item.id ? 'selected' : ''}`}
											key={item.id}
											onClick={() => setSelected(item.id)}
										>
											<StatusBadge status={item.status} />
											<h3>{item.prompt}</h3>
											<p className='font-mono truncate'>{item.module}</p>
											<div>
												<time>
													{new Date(item.started_at).toLocaleString('zh-CN', {
														month: '2-digit',
														day: '2-digit',
														hour: '2-digit',
														minute: '2-digit'
													})}
												</time>
												<span>查看详情 ↗</span>
											</div>
										</button>
									))
								) : (
									<p className='kanban-empty'>暂无任务</p>
								)}
							</section>
						))}
					</div>
					{current && <IterationDetail key={current.id} iteration={current} onContinue={continueSession} />}
				</>
			)}
		</div>
	)
}
