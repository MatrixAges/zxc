import { getLocale, getTranslations } from 'next-intl/server'
import { localeHref } from '../i18n/locale'

export default async function SiteHeader() {
	const locale = await getLocale()
	const t = await getTranslations('site')

	return (
		<header className='site-header'>
			<div className='header-brand'>
				<span>
					MATRIXAGES{' '}
					<span className='brand-cursor' aria-hidden='true'>
						█
					</span>
				</span>
				<a className='wordmark' href={localeHref('/', locale)} aria-label='zxc'>
					ZXC
				</a>
				<span>2026</span>
			</div>
			<nav aria-label={t('mainNavigation')}>
				<a href={localeHref('/docs', locale)}>[ {t('docs')} ]</a>
				<a href={localeHref('/llms-full.txt', locale)}>[ {t('forAgents')} ]</a>
				<a href='https://github.com/MatrixAges/zxc'>[ GITHUB ↗ ]</a>
			</nav>
		</header>
	)
}
