import type { SourceFile } from '../../../shared/types'
import { useState } from 'react'
import { HugeiconsIcon } from '@hugeicons/react'
import { ViewIcon, CodeIcon } from '@hugeicons/core-free-icons'
import { Button } from '@/vendor/ui/button'
import { Input } from '@/vendor/ui/input'
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from '@/vendor/ui/sheet'
import CodeView from '@/components/code_view'
import SourceTable from '@/components/source_table'
import useSource from './use_source'

function SourcePreview({ file }: { file: SourceFile }) {
	const source = useSource(file.path)

	if (source.error) return <p className='error-message'>{source.error}</p>
	if (!source.loaded) return <p className='p-6 text-sm text-muted-foreground'>正在读取源码…</p>

	return <CodeView content={source.content} path={file.path} />
}

export default function ModuleBrowser({
	files,
	onDevelop
}: {
	files: Array<SourceFile>
	onDevelop: (path: string) => void
}) {
	const [query, setQuery] = useState('')
	const [selected, setSelected] = useState('')
	const filtered = files.filter(
		file => file.kind === 'module' && file.path.toLowerCase().includes(query.toLowerCase())
	)
	const current = files.find(file => file.path === selected)

	return (
		<div className='page-stack'>
			<div className='page-title'>
				<h1>模块预览</h1>
				<span className='count-label'>{filtered.length} 个文件</span>
			</div>
			<section className='space-y-3'>
				<div className='flex items-center justify-between gap-3'>
					<Input
						className='max-w-sm'
						aria-label='搜索模块'
						value={query}
						onChange={event => setQuery(event.target.value)}
						placeholder='搜索模块路径…'
					/>
				</div>
				<SourceTable
					key={JSON.stringify([query, filtered.map(file => file.path)])}
					files={filtered}
					selected={selected}
					renderActions={file => (
						<>
							<Button
								variant='ghost'
								size='icon-sm'
								aria-label='预览源码'
								title='预览源码'
								onClick={() => setSelected(file.path)}
							>
								<HugeiconsIcon icon={ViewIcon} size={16} />
							</Button>
							<Button
								variant='ghost'
								size='icon-sm'
								aria-label='用 Codex 开发'
								title='用 Codex 开发'
								onClick={() => onDevelop(file.path)}
							>
								<HugeiconsIcon icon={CodeIcon} size={16} />
							</Button>
						</>
					)}
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
					{current && (
						<>
							<div className='file-meta'>
								<span>{current.language.toUpperCase()}</span>
								<span>源码预览</span>
								{current.language === 'rx' && <span>Runtime 尚未接入</span>}
							</div>
							<SourcePreview key={current.path} file={current} />
						</>
					)}
				</SheetContent>
			</Sheet>
		</div>
	)
}
