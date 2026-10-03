import { File, Virtualizer } from '@pierre/diffs/react'

export default function CodeView({
	content,
	path,
	label = '源代码'
}: {
	content: string
	path: string
	label?: string
}) {
	return (
		<div role='region' aria-label={label}>
			<Virtualizer className='code-view'>
				<File
					file={{
						name: path,
						contents: content,
						lang: path.endsWith('.rx') ? 'xml' : path.endsWith('.zx') ? 'text' : undefined
					}}
					options={{ theme: 'github-light', themeType: 'light', overflow: 'scroll', disableFileHeader: true }}
				/>
			</Virtualizer>
		</div>
	)
}
