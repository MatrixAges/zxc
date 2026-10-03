import { getRequestConfig } from 'next-intl/server'
import { headers } from 'next/headers'
import { isLocale } from './locale'
import loadMessages from './messages'

export default getRequestConfig(async ({ locale: explicit_locale }) => {
	const value = explicit_locale ?? (await headers()).get('x-zxc-locale') ?? 'en'
	const locale = isLocale(value) ? value : 'en'

	return { locale, messages: await loadMessages(locale) }
})
