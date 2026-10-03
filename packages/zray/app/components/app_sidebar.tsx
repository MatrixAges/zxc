import type { Workspace } from '../../shared/types'
import { HugeiconsIcon } from '@hugeicons/react'
import {
	CodeIcon,
	ComputerTerminalIcon,
	RoboticIcon,
	BookOpen02Icon,
	CropIcon,
	ChartRingIcon
} from '@hugeicons/core-free-icons'
import {
	Sidebar,
	SidebarContent,
	SidebarGroup,
	SidebarGroupLabel,
	SidebarHeader,
	SidebarMenu,
	SidebarMenuButton,
	SidebarMenuItem,
	SidebarSeparator
} from '@/vendor/ui/sidebar'

const navigation = [
	{ id: 'overview', title: '工作区总览', icon: ChartRingIcon },
	{ id: 'tests', title: '测试用例', icon: ComputerTerminalIcon },
	{ id: 'modules', title: '模块预览', icon: CropIcon },
	{ id: 'sessions', title: '模块开发', icon: RoboticIcon },
	{ id: 'history', title: '迭代记录', icon: BookOpen02Icon }
]

export const page_titles = Object.fromEntries(navigation.map(item => [item.id, item.title]))

export default function AppSidebar({
	page,
	onNavigate,
	workspace,
	package_filter,
	onPackage,
	active_count
}: {
	page: string
	onNavigate: (page: string) => void
	workspace?: Workspace
	package_filter: string
	onPackage: (name: string) => void
	active_count: number
}) {
	return (
		<Sidebar variant='inset'>
			<SidebarHeader className='p-2'>
				<div className='flex items-center gap-2 px-2 py-1'>
					<div className='brand-mark'>
						<HugeiconsIcon icon={CodeIcon} size={23} />
					</div>
					<div>
						<span className='text-xl font-semibold tracking-tight'>
							zray<span className='text-muted-foreground'>.</span>
						</span>
						<p className='text-[11px] text-muted-foreground tracking-wide'>ZXC DEV UI</p>
					</div>
				</div>
			</SidebarHeader>
			<SidebarContent>
				<SidebarGroup>
					<SidebarGroupLabel>工作空间</SidebarGroupLabel>
					<SidebarMenu>
						{navigation.map(item => (
							<SidebarMenuItem key={item.id}>
								<SidebarMenuButton
									isActive={page === item.id}
									onClick={() => onNavigate(item.id)}
									className='h-10'
								>
									<HugeiconsIcon icon={item.icon} size={18} strokeWidth={1.6} />
									<span>{item.title}</span>
									{item.id === 'sessions' && active_count > 0 && (
										<span className='ml-auto font-mono text-xs'>{active_count}</span>
									)}
								</SidebarMenuButton>
							</SidebarMenuItem>
						))}
					</SidebarMenu>
				</SidebarGroup>
				<SidebarSeparator />
				<SidebarGroup>
					<SidebarGroupLabel>仓库模块包</SidebarGroupLabel>
					<SidebarMenu>
						<SidebarMenuItem>
							<SidebarMenuButton isActive={!package_filter} onClick={() => onPackage('')}>
								<span className='package-dot' />
								全部包
								<span className='ml-auto font-mono text-xs text-muted-foreground'>
									{workspace?.packages.length ?? '—'}
								</span>
							</SidebarMenuButton>
						</SidebarMenuItem>
						{workspace?.packages.map(item => (
							<SidebarMenuItem key={item.name}>
								<SidebarMenuButton
									isActive={package_filter === item.name}
									onClick={() => onPackage(item.name)}
								>
									<span className='package-dot' />
									<span className='font-mono text-xs'>{item.name}</span>
									<span className='ml-auto font-mono text-xs text-muted-foreground'>
										{workspace.files.filter(file => file.package === item.name).length}
									</span>
								</SidebarMenuButton>
							</SidebarMenuItem>
						))}
					</SidebarMenu>
				</SidebarGroup>
			</SidebarContent>
		</Sidebar>
	)
}
