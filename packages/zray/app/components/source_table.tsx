import type { ReactNode } from 'react'
import type { SourceFile } from '../../shared/types'
import { useState } from 'react'
import SourcePagination from './source_pagination'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/vendor/ui/table'

export default function SourceTable({
	files,
	selected,
	renderActions
}: {
	files: Array<SourceFile>
	selected: string
	renderActions: (file: SourceFile) => ReactNode
}) {
	const [page, setPage] = useState(1)
	const [page_size, setPageSize] = useState(12)
	const page_count = Math.max(1, Math.ceil(files.length / page_size))
	const current_page = Math.min(page, page_count)
	const start = (current_page - 1) * page_size
	const page_files = files.slice(start, start + page_size)

	return (
		<div className='space-y-4'>
			<div className='panel overflow-hidden'>
				<Table>
					<TableHeader>
						<TableRow>
							<TableHead>文件</TableHead>
							<TableHead>所属包</TableHead>
							<TableHead>路径</TableHead>
							<TableHead>语言</TableHead>
							<TableHead className='text-right'>Actions</TableHead>
						</TableRow>
					</TableHeader>
					<TableBody>
						{page_files.map(file => (
							<TableRow key={file.path} data-state={selected === file.path ? 'selected' : undefined}>
								<TableCell className='font-mono text-xs'>{file.path.split('/').at(-1)}</TableCell>
								<TableCell className='font-mono text-xs'>{file.package}</TableCell>
								<TableCell
									className='max-w-sm truncate text-xs text-muted-foreground'
									title={file.path}
								>
									{file.path}
								</TableCell>
								<TableCell className='text-xs uppercase'>{file.language}</TableCell>
								<TableCell>
									<div className='flex items-center justify-end gap-2'>{renderActions(file)}</div>
								</TableCell>
							</TableRow>
						))}
						{!files.length && (
							<TableRow>
								<TableCell colSpan={5} className='h-32 text-center text-muted-foreground'>
									没有匹配的文件
								</TableCell>
							</TableRow>
						)}
					</TableBody>
				</Table>
			</div>
			<SourcePagination
				page={current_page}
				page_count={page_count}
				page_size={page_size}
				total={files.length}
				onPageChange={setPage}
				onPageSizeChange={size => {
					setPageSize(size)
					setPage(1)
				}}
			/>
		</div>
	)
}
