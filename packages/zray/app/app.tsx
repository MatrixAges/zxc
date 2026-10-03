import { useState } from 'react'
import { SidebarInset, SidebarProvider, SidebarTrigger } from '@/vendor/ui/sidebar'
import { TooltipProvider } from '@/vendor/ui/tooltip'
import { Separator } from '@/vendor/ui/separator'
import AppSidebar, { page_titles } from '@/components/app_sidebar'
import Overview from '@/features/workspace/overview'
import useWorkspace from '@/features/workspace/use_workspace'
import ModuleBrowser from '@/features/modules/module_browser'
import TestWorkspace from '@/features/tests/test_workspace'
import SessionWorkspace from '@/features/sessions/session_workspace'

export default function App() {
	const { workspace, versions, runs, iterations, error, refresh } = useWorkspace()
	const [page, setPage] = useState('overview')
	const [package_filter, setPackageFilter] = useState('')
	const [initial_module, setInitialModule] = useState('')
	const files = workspace?.files.filter(file => !package_filter || file.package === package_filter) ?? []
	const active_count = iterations.filter(item => ['running', 'starting'].includes(item.status)).length

	const navigate = (next: string) => {
		setInitialModule('')
		setPage(next)
	}
	const choosePackage = (name: string) => {
		setPackageFilter(name)
		if (page === 'overview') setPage('modules')
	}
	const develop = (path: string) => {
		setInitialModule(path)
		setPage('sessions')
	}

	return (
		<TooltipProvider>
			<SidebarProvider>
				<AppSidebar
					page={page}
					onNavigate={navigate}
					workspace={workspace}
					package_filter={package_filter}
					onPackage={choosePackage}
					active_count={active_count}
				/>
				<SidebarInset className='min-w-0'>
					<header className='app-header'>
						<SidebarTrigger aria-label='切换侧边栏' />
						<Separator orientation='vertical' className='h-4 data-vertical:self-center' />
						<span className='text-muted-foreground'>zxc</span>
						<span className='text-border'>/</span>
						<span>{page_titles[page]}</span>
						{package_filter && (
							<span className='font-mono text-xs text-muted-foreground'>/ {package_filter}</span>
						)}
						<div className='ml-auto flex items-center gap-4 font-mono text-[11px] text-muted-foreground'>
							<span>Zig {versions ? (versions.zig ?? '不可用') : '…'}</span>
							<span>zxc {versions ? (versions.zxc ?? '未知') : '…'}</span>
						</div>
					</header>
					<main className='main-content'>
						{error && (
							<div className='error-message mb-5' role='alert'>
								本地服务连接异常：{error}
								<button className='ml-3 underline' onClick={refresh}>
									重试
								</button>
							</div>
						)}
						{!workspace ? (
							<div className='empty-state large'>
								<h1>正在读取 zxc 工作区…</h1>
								<p>请通过 pnpm dev:zray 启动本地服务。</p>
							</div>
						) : (
							<>
								{page === 'overview' && (
									<Overview
										workspace={workspace}
										runs={runs}
										iterations={iterations}
										onNavigate={navigate}
									/>
								)}
								{page === 'modules' && <ModuleBrowser files={files} onDevelop={develop} />}
								{page === 'tests' && <TestWorkspace workspace={workspace} files={files} runs={runs} />}
								{(page === 'sessions' || page === 'history') && (
									<SessionWorkspace
										key={`${page}-${initial_module}`}
										files={files}
										iterations={iterations}
										initial_module={initial_module}
										history={page === 'history'}
										package_filter={package_filter}
									/>
								)}
							</>
						)}
					</main>
					<footer className='app-footer'>
						<span>zray · 为 zxc 开发而生</span>
						<span>源码有据，迭代有迹。</span>
					</footer>
				</SidebarInset>
			</SidebarProvider>
		</TooltipProvider>
	)
}
