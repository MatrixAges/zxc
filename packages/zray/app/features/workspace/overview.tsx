import type { Iteration, Run, Workspace } from '../../../shared/types'
import { HugeiconsIcon } from '@hugeicons/react'
import { ComputerTerminalIcon, RoboticIcon, CropIcon, BookOpen02Icon } from '@hugeicons/core-free-icons'
import { Button } from '@/vendor/ui/button'
import StatusBadge from '@/components/status_badge'

export default function Overview({
	workspace,
	iterations,
	runs,
	onNavigate
}: {
	workspace: Workspace
	iterations: Array<Iteration>
	runs: Array<Run>
	onNavigate: (page: string) => void
}) {
	const modules = workspace.files.filter(file => file.kind === 'module')
	const tests = workspace.files.filter(file => file.kind === 'test')
	const active = iterations.filter(item => ['running', 'starting'].includes(item.status))
	const stats = [
		{
			title: '模块源文件',
			value: modules.length,
			detail: `${workspace.packages.length} 个 Zig 包`,
			icon: CropIcon,
			page: 'modules'
		},
		{
			title: '测试文件',
			value: tests.length,
			detail: `${workspace.packages.filter(item => item.runnable).length} 个可执行测试包`,
			icon: ComputerTerminalIcon,
			page: 'tests'
		},
		{
			title: '开发中的模块',
			value: active.length,
			detail: 'Codex 独立会话 · 最多 3 路并行',
			icon: RoboticIcon,
			page: 'sessions'
		},
		{
			title: '模块迭代',
			value: iterations.length,
			detail: '每轮迭代均有 docs 文档',
			icon: BookOpen02Icon,
			page: 'history'
		}
	]

	return (
		<div className='page-stack'>
			<div className='stats-grid'>
				{stats.map(item => (
					<button className='stat-card text-left' key={item.title} onClick={() => onNavigate(item.page)}>
						<div className='flex items-center justify-between text-muted-foreground'>
							<span className='text-xs'>{item.title}</span>
							<HugeiconsIcon icon={item.icon} size={18} strokeWidth={1.5} />
						</div>
						<p className='my-4 font-mono text-3xl tracking-tight'>
							{item.value.toString().padStart(2, '0')}
						</p>
						<p className='text-[11px] text-muted-foreground'>{item.detail}</p>
					</button>
				))}
			</div>
			<div className='overview-grid'>
				<section className='panel'>
					<div className='panel-heading'>
						<h2>模块包</h2>
						<span className='eyebrow'>REPOSITORY</span>
					</div>
					<div className='divide-y'>
						{workspace.packages.map(item => (
							<div key={item.name} className='flex items-center gap-4 p-4'>
								<span className='package-glyph'>
									<HugeiconsIcon icon={CropIcon} size={18} />
								</span>
								<div className='flex-1'>
									<p className='font-mono text-sm'>{item.name}</p>
									<p className='mt-1 text-xs text-muted-foreground'>
										{
											workspace.files.filter(
												file => file.package === item.name && file.kind === 'module'
											).length
										}{' '}
										个模块源文件
									</p>
								</div>
								<span className='text-xs text-muted-foreground'>
									{item.runnable ? '支持包测试' : '源码预览'}
								</span>
							</div>
						))}
					</div>
				</section>
				<section className='panel'>
					<div className='panel-heading'>
						<h2>最近动态</h2>
						<span className='eyebrow'>ACTIVITY</span>
					</div>
					{!iterations.length && !runs.length ? (
						<div className='empty-state'>
							<HugeiconsIcon icon={RoboticIcon} size={30} strokeWidth={1} />
							<h3>准备好开始新的迭代</h3>
							<p>
								创建模块开发会话或执行测试，
								<br />
								真实的开发动态会出现在这里。
							</p>
							<Button variant='outline' onClick={() => onNavigate('modules')}>
								浏览模块
							</Button>
						</div>
					) : (
						<div className='divide-y'>
							{iterations.slice(0, 4).map(item => (
								<button className='activity-row' key={item.id} onClick={() => onNavigate('sessions')}>
									<div className='min-w-0 flex-1'>
										<p className='truncate text-sm'>{item.prompt}</p>
										<p className='truncate mt-1 font-mono text-[10px] text-muted-foreground'>
											{item.module}
										</p>
									</div>
									<StatusBadge status={item.status} />
								</button>
							))}
							{runs.slice(0, 3).map(run => (
								<button className='activity-row' key={run.id} onClick={() => onNavigate('tests')}>
									<span className='flex-1 text-left font-mono text-xs'>
										{run.package} / zig build test
									</span>
									<StatusBadge status={run.status} />
								</button>
							))}
						</div>
					)}
				</section>
			</div>
			<p className='workspace-note'>
				<span className='size-1.5 rounded-full bg-amber-500' />
				RX Runtime 尚未接入 · 当前支持源码预览与已有 Zig 包测试。
			</p>
		</div>
	)
}
