import { Fragment } from 'react'
import {
	Pagination,
	PaginationContent,
	PaginationEllipsis,
	PaginationItem,
	PaginationLink,
	PaginationNext,
	PaginationPrevious
} from '@/vendor/ui/pagination'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/vendor/ui/select'

const page_sizes = [12, 24, 48].map(size => ({ value: size, label: String(size) }))

export default function SourcePagination({
	page,
	page_count,
	page_size,
	total,
	onPageChange,
	onPageSizeChange
}: {
	page: number
	page_count: number
	page_size: number
	total: number
	onPageChange: (page: number) => void
	onPageSizeChange: (size: number) => void
}) {
	const pages = [...new Set([1, page - 1, page, page + 1, page_count])]
		.filter(value => value >= 1 && value <= page_count)
		.sort((a, b) => a - b)

	return (
		<div className='grid grid-cols-2 items-center gap-4 xl:grid-cols-[minmax(0,1fr)_auto_minmax(0,1fr)]'>
			<span className='text-sm text-muted-foreground' aria-live='polite'>
				共 {total} 条
			</span>
			<Pagination
				className='col-span-2 row-start-2 mx-0 w-auto justify-self-center xl:col-span-1 xl:col-start-2 xl:row-start-1'
				aria-label='表格分页'
			>
				<PaginationContent>
					<PaginationItem>
						<PaginationPrevious
							href='#'
							text='上一页'
							aria-label='上一页'
							aria-disabled={page === 1}
							tabIndex={page === 1 ? -1 : undefined}
							className='aria-disabled:pointer-events-none aria-disabled:opacity-50'
							onClick={event => {
								event.preventDefault()
								if (page > 1) onPageChange(page - 1)
							}}
						/>
					</PaginationItem>
					{pages.map((value, index) => (
						<Fragment key={value}>
							{index > 0 && value - pages[index - 1] > 1 && (
								<PaginationItem>
									<PaginationEllipsis />
								</PaginationItem>
							)}
							<PaginationItem>
								<PaginationLink
									href='#'
									isActive={value === page}
									aria-label={`第 ${value} 页`}
									onClick={event => {
										event.preventDefault()
										onPageChange(value)
									}}
								>
									{value}
								</PaginationLink>
							</PaginationItem>
						</Fragment>
					))}
					<PaginationItem>
						<PaginationNext
							href='#'
							text='下一页'
							aria-label='下一页'
							aria-disabled={page === page_count}
							tabIndex={page === page_count ? -1 : undefined}
							className='aria-disabled:pointer-events-none aria-disabled:opacity-50'
							onClick={event => {
								event.preventDefault()
								if (page < page_count) onPageChange(page + 1)
							}}
						/>
					</PaginationItem>
				</PaginationContent>
			</Pagination>
			<div className='col-start-2 row-start-1 flex items-center justify-self-end gap-2 xl:col-start-3'>
				<span className='text-sm'>每页条数</span>
				<Select
					items={page_sizes}
					value={page_size}
					onValueChange={value => {
						if (value !== null) onPageSizeChange(value)
					}}
				>
					<SelectTrigger size='sm' aria-label='每页条数'>
						<SelectValue />
					</SelectTrigger>
					<SelectContent>
						{page_sizes.map(item => (
							<SelectItem key={item.value} value={item.value}>
								{item.label}
							</SelectItem>
						))}
					</SelectContent>
				</Select>
			</div>
		</div>
	)
}
