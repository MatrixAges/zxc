import { getLocale, getTranslations } from 'next-intl/server'
import { localeHref } from '../i18n/locale'
import { version } from '../package.json'

export default async function SiteHeader() {
	const locale = await getLocale()
	const t = await getTranslations('site')

	return (
		<header className='site-header'>
			<div className='header-brand'>
				<a href='https://matrixages.com'>
					MATRIXAGES{' '}
					<span className='brand-cursor' aria-hidden='true'>
						█
					</span>
				</a>
				<a className='wordmark' href={localeHref('/', locale)} target='_self' aria-label='zxc'>
					ZXC
				</a>
				<a href={localeHref('/', locale)} target='_self'>
					{version}
				</a>
			</div>
			<nav aria-label={t('mainNavigation')}>
				<a href={localeHref('/docs', locale)} target='_self'>
					[ {t('docs')} ]
				</a>
				<a href={localeHref('/llms-full.txt', locale)}>[ {t('forAgents')} ]</a>
				<a href='https://github.com/MatrixAges/zxc'>[ GITHUB ↗ ]</a>
			</nav>
		</header>
	)
}
