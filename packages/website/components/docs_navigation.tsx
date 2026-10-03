import { getLocale, getTranslations } from 'next-intl/server'
import { getDocs } from '../content/docs'
import { localeHref } from '../i18n/locale'

export default async function DocsNavigation({ current }: { current: string }) {
	const locale = await getLocale()
	const t = await getTranslations('site')
	const docs = await getDocs(locale)
	const groups = [...new Set(docs.map(doc => doc.group))]

	return (
		<nav className='docs-navigation' aria-label={t('documentation')}>
			<a className='docs-index' href={localeHref('/docs', locale)}>
				{t('documentation')}
			</a>
			{groups.map(group => (
				<div className='nav-group' key={group}>
					<p>{group}</p>
					<ul>
						{docs
							.filter(doc => doc.group === group)
							.map(doc => (
								<li key={doc.id}>
									<a
										href={localeHref(`/docs/${doc.id}`, locale)}
										aria-current={current === doc.id ? 'page' : undefined}
									>
										{doc.title}
									</a>
								</li>
							))}
					</ul>
				</div>
			))}
			<a href={localeHref('/llms-full.txt', locale)}>[ {t('plainText')} ↗ ]</a>
		</nav>
	)
}
