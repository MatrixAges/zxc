import ReactMarkdown from 'react-markdown'
import rehypeHighlight from 'rehype-highlight'
import remarkGfm from 'remark-gfm'

export default function Markdown({ children }: { children: string }) {
	return (
		<ReactMarkdown
			remarkPlugins={[remarkGfm]}
			rehypePlugins={[rehypeHighlight]}
			components={{
				table: ({ children }) => (
					<div className='markdown-table'>
						<table>{children}</table>
					</div>
				),
				a: ({ href, title, children }) => (
					<a href={href} title={title} target={href && /^\/docs(?:[/?#]|$)/.test(href) ? '_self' : undefined}>
						{children}
					</a>
				)
			}}
		>
			{children}
		</ReactMarkdown>
	)
}
