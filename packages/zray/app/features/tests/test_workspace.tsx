import type { Run, SourceFile, Workspace } from '../../../shared/types'
import { useState } from 'react'
import { HugeiconsIcon } from '@hugeicons/react'
import { ViewIcon, PlayIcon } from '@hugeicons/core-free-icons'
import { Button } from '@/vendor/ui/button'
import { Input } from '@/vendor/ui/input'
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from '@/vendor/ui/sheet'
import CodeView from '@/components/code_view'
import SourceTable from '@/components/source_table'
import StatusBadge from '@/components/status_badge'
import useSource from '@/features/modules/use_source'
import rpc from '@/lib/rpc'

function TestSource({ file }: { file: SourceFile }) {
	const source = useSource(file.path)

	if (source.error) return <p className='error-message'>{source.error}</p>
	if (!source.loaded) return <p className='p-6 text-sm text-muted-foreground'>正在读取源码…</p>

	return <CodeView content={source.content} path={file.path} label='测试源码' />
}

export default function TestWorkspace({
	workspace,
	files,
	runs
}: {
	workspace: Workspace
	files: Array<SourceFile>
	runs: Array<Run>
}) {
	const [query, setQuery] = useState('')
	const [selected, setSelected] = useState('')
	const [error, setError] = useState('')
	const [busy, setBusy] = useState(false)
	const [tab, setTab] = useState('source')
	const filtered = files.filter(file => file.kind === 'test' && file.path.toLowerCase().includes(query.toLowerCase()))
	const current = files.find(file => file.path === selected)
	const run = runs.find(item => item.package === current?.package)

	const execute = async (file: SourceFile) => {
		setBusy(true)
		setError('')
		try {
			await rpc.execution.start.mutate({ package: file.package })
			setSelected(file.path)
			setTab('output')
		} catch (error) {
			setError(String(error))
		}
		setBusy(false)
	}
	const stop = async () => {
		if (!run) return
		try {
			await rpc.execution.stop.mutate({ id: run.id })
		} catch (error) {
			setError(String(error))
		}
	}

	return (
		<div className='page-stack'>
			<div className='page-title'>
				<h1>测试用例</h1>
				<span className='count-label'>{filtered.length} 个文件</span>
			</div>
			{error && (
				<p className='error-message' role='alert'>
					{error}
				</p>
			)}
			<section className='space-y-3'>
				<div className='flex items-center justify-between gap-3'>
					<Input
						className='max-w-sm'
						value={query}
						onChange={event => setQuery(event.target.value)}
						placeholder='搜索测试文件…'
						aria-label='搜索测试文件'
					/>
				</div>
				<SourceTable
					key={JSON.stringify([query, filtered.map(file => file.path)])}
					files={filtered}
					selected={selected}
					renderActions={file => {
						const package_run = runs.find(item => item.package === file.package)
						const runnable = workspace.packages.find(item => item.name === file.package)?.runnable

						return (
							<>
								{package_run && <StatusBadge status={package_run.status} />}
								<Button
									variant='ghost'
									size='icon-sm'
									aria-label='预览源码'
									title='预览源码'
									onClick={() => {
										setSelected(file.path)
										setTab('source')
									}}
								>
									<HugeiconsIcon icon={ViewIcon} size={16} />
								</Button>
								<Button
									variant='ghost'
									size='icon-sm'
									disabled={!runnable || busy || package_run?.status === 'running'}
									aria-label={`执行 ${file.package} 包测试`}
									title={`执行 ${file.package} 包测试`}
									onClick={() => execute(file)}
								>
									<HugeiconsIcon icon={PlayIcon} size={16} />
								</Button>
							</>
						)
					}}
				/>
			</section>
			<Sheet
				open={!!current}
				onOpenChange={open => {
					if (!open) setSelected('')
				}}
			>
				<SheetContent className='data-[side=right]:w-full data-[side=right]:sm:max-w-4xl overflow-y-auto'>
					<SheetHeader className='pr-16'>
						<SheetTitle>{current?.path.split('/').at(-1)}</SheetTitle>
						<SheetDescription className='break-all'>{current?.path}</SheetDescription>
					</SheetHeader>
					<div className='px-6'>
						<div className='tab-strip'>
							<button aria-pressed={tab === 'source'} onClick={() => setTab('source')}>
								用例源码
							</button>
							<button aria-pressed={tab === 'output'} onClick={() => setTab('output')}>
								执行输出
							</button>
							{run && <StatusBadge status={run.status} />}
						</div>
						{error && (
							<p className='error-message' role='alert'>
								{error}
							</p>
						)}
					</div>
					{tab === 'source' ? (
						current && <TestSource key={current.path} file={current} />
					) : (
						<div className='px-6'>
							{run?.status === 'running' && (
								<Button className='mb-3' size='sm' variant='outline' onClick={stop}>
									停止
								</Button>
							)}
							<pre className='terminal' aria-live='polite'>
								{run?.output ?? '尚未执行该包测试。'}
							</pre>
						</div>
					)}
					<p className='px-6 pb-6 text-xs leading-6 text-muted-foreground'>
						执行单位是整个包，状态不代表单独文件的结果。日志保留最近 200 KB；RX Runtime 尚未接入。
					</p>
				</SheetContent>
			</Sheet>
		</div>
	)
}
