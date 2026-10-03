import { getLocale } from 'next-intl/server'
import { redirect } from 'next/navigation'
import { localeHref } from '../../i18n/locale'

export default async function DocsPage() {
	redirect(localeHref('/docs/overview', await getLocale()))
}
