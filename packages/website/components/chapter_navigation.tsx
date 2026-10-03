import type { Locale } from '../i18n/locale'
import { getTranslations } from 'next-intl/server'
import { getDocs } from '../content/docs'
import { localeHref } from '../i18n/locale'

export default async function ChapterNavigation({ current, locale }: { current: string; locale: Locale }) {
	const t = await getTranslations('site')
	const docs = await getDocs(locale)
	const index = docs.findIndex(doc => doc.id === current)
	const previous = docs[index - 1]
	const next = docs[index + 1]

	return (
		<nav className='chapter-navigation' aria-label={t('chapterNavigation')}>
			{previous ? (
				<a href={localeHref(`/docs/${previous.id}`, locale)} target='_self'>
					← {previous.title}
				</a>
			) : (
				<span />
			)}
			{next && (
				<a href={localeHref(`/docs/${next.id}`, locale)} target='_self'>
					{next.title} →
				</a>
			)}
		</nav>
	)
}
