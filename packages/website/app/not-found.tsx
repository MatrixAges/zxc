import { getLocale, getTranslations } from 'next-intl/server'
import { localeHref } from '../i18n/locale'

export default async function NotFound() {
	const locale = await getLocale()
	const t = await getTranslations('site')

	return (
		<main id='content' className='home'>
			<p className='eyebrow'>404</p>
			<h1>{t('notFound')}</h1>
			<p>
				<a href={localeHref('/docs', locale)}>{t('returnDocs')} →</a>
			</p>
		</main>
	)
}
