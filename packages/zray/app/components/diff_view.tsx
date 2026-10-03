import type { WorktreeDiff } from '../../shared/types'
import { useMemo } from 'react'
import { parsePatchFiles } from '@pierre/diffs'
import { File, FileDiff, Virtualizer } from '@pierre/diffs/react'

export default function DiffView({ changes }: { changes: WorktreeDiff }) {
	const parsed = useMemo(() => {
		try {
			return {
				files: changes.patch
					? parsePatchFiles(changes.patch, undefined, true).flatMap(patch => patch.files)
					: [],
				error: ''
			}
		} catch (error) {
			return { files: [], error: String(error) }
		}
	}, [changes.patch])

	return (
		<div className='space-y-3'>
			{parsed.error && <p className='error-message'>无法解析变更：{parsed.error}</p>}
			{!changes.status && <p className='text-sm text-muted-foreground'>工作树暂无变更。</p>}
			{!!changes.status && (
				<details className='text-xs text-muted-foreground'>
					<summary>文件状态</summary>
					<pre className='mt-2 font-mono'>{changes.status}</pre>
				</details>
			)}
			{(parsed.files.length > 0 || changes.files.length > 0) && (
				<Virtualizer className='code-view'>
					{parsed.files.map((file, index) => (
						<FileDiff
							key={index}
							fileDiff={file}
							options={{
								theme: 'github-light',
								themeType: 'light',
								diffStyle: 'unified',
								disableBackground: true
							}}
						/>
					))}
					{changes.files.map(file => (
						<File
							key={file.path}
							file={{ name: file.path, contents: file.content }}
							options={{ theme: 'github-light', themeType: 'light' }}
						/>
					))}
				</Virtualizer>
			)}
			{changes.omitted.map(path => (
				<p className='text-xs text-muted-foreground' key={path}>
					新文件 {path} 内容较大，请在工作树中查看。
				</p>
			))}
		</div>
	)
}
