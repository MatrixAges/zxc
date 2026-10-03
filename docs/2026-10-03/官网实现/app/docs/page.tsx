import CopyPrompt from '../../components/copy_prompt'
import DocsNavigation from '../../components/docs_navigation'
import Markdown from '../../components/markdown'
import { docs } from '../../content/docs'

export const metadata = { title: 'Documentation' }

export default function DocsPage() {
	return (
		<main id='content' className='docs-layout'>
			<aside>
				<DocsNavigation />
			</aside>
			<article className='docs-content'>
				<header className='docs-intro'>
					<p className='eyebrow'>zxc / documentation</p>
					<h1>Read. Compose. Verify.</h1>
					<p>The working contract for agents building with zxc.</p>
					<div className='action-links'>
						<CopyPrompt />
						<a href='/llms-full.txt'>[ full text ↗ ]</a>
					</div>
				</header>
				{docs.map(doc => (
					<section className='doc-section' id={doc.id} key={doc.id}>
						<div className='section-heading'>
							<h2>
								<a href={`#${doc.id}`}>{doc.title}</a>
							</h2>
							<a
								className='raw-link'
								href={`/docs/raw/${doc.id}`}
								aria-label={`Read ${doc.title} as Markdown`}
							>
								[ .md ]
							</a>
						</div>
						<Markdown>{doc.body}</Markdown>
					</section>
				))}
			</article>
		</main>
	)
}
