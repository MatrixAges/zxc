import { getLocale, getTranslations } from 'next-intl/server'
import { notFound } from 'next/navigation'
import AgentPrompt from '../../../components/agent_prompt'
import DocsNavigation from '../../../components/docs_navigation'
import Markdown from '../../../components/markdown'
import { getDocument } from '../../../content/docs'
import { localeHref } from '../../../i18n/locale'

type PageProps = { params: Promise<{ slug: string }> }

export async function generateMetadata({ params }: PageProps) {
	const { slug } = await params
	const locale = await getLocale()
	const doc = await getDocument({ locale, slug })

	if (!doc) notFound()

	return { title: doc.title }
}

export default async function DocPage({ params }: PageProps) {
	const { slug } = await params
	const locale = await getLocale()
	const t = await getTranslations('site')
	const doc = await getDocument({ locale, slug })

	if (!doc) notFound()

	return (
		<main id='content' className='docs-layout'>
			<aside>
				<DocsNavigation current={doc.id} />
			</aside>
			<article className='docs-content'>
				<header className='docs-intro'>
					<p className='eyebrow'>zxc / {doc.group}</p>
					<div className='section-heading'>
						<h1>{doc.title}</h1>
						<a
							className='raw-link'
							href={localeHref(`/docs/raw/${doc.id}`, locale)}
							aria-label={t('rawLabel', { title: doc.title })}
						>
							[ .md ]
						</a>
					</div>
					<div className='action-links'>
						<AgentPrompt />
						<a href={localeHref('/llms-full.txt', locale)}>[ {t('fullText')} ↗ ]</a>
					</div>
				</header>
				<div className='doc-section'>
					<Markdown>{doc.body}</Markdown>
				</div>
			</article>
		</main>
	)
}
