import type { ReactNode } from 'react'
import { getLocale, getTranslations } from 'next-intl/server'
import SiteHeader from '../components/site_header'
import { localeHref } from '../i18n/locale'
import '../styles/site.css'
import '../styles/highlight.css'
import '../styles/data_flow.css'

export const dynamic = 'force-dynamic'

export async function generateMetadata() {
	const t = await getTranslations('home')

	return {
		title: { default: `zxc — ${t('title')}`, template: '%s — zxc' },
		description: t('description'),
		icons: { icon: { url: '/favicon.svg', type: 'image/svg+xml' } }
	}
}

export default async function RootLayout({ children }: { children: ReactNode }) {
	const locale = await getLocale()
	const t = await getTranslations('site')

	return (
		<html lang={locale} data-theme='dark'>
			<head>
				<base target='_blank' />
			</head>
			<body>
				<a className='skip-link' href='#content' target='_self'>
					{t('skip')}
				</a>
				<SiteHeader />
				{children}
				<footer className='site-footer'>
					<span aria-hidden='true'>–––</span>
					<nav aria-label={t('footerNavigation')}>
						<a href={localeHref('/docs', locale)}>{t('docs')}</a>
						<span aria-hidden='true'> | </span>
						<a href={localeHref('/llms.txt', locale)}>llms.txt</a>
						<span aria-hidden='true'> | </span>
						<a href='https://github.com/MatrixAges/zxc'>GitHub</a>
					</nav>
					<span className='footer-brand'>
						<span className='brand-logo' aria-hidden='true' />
						<span>© 2026 MATRIXAGES. zxc / {t('madeForAgents')}.</span>
					</span>
				</footer>
			</body>
		</html>
	)
}
