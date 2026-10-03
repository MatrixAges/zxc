import { getRequestConfig } from 'next-intl/server'
import { headers } from 'next/headers'
import { isLocale } from './locale'
import loadMessages from './messages'

export default getRequestConfig(async () => {
	const value = (await headers()).get('x-zxc-locale') ?? 'en'
	const locale = isLocale(value) ? value : 'en'

	return { locale, messages: await loadMessages(locale) }
})
