export const locales = ['en', 'zh', 'ja', 'ko'] as const

export type Locale = (typeof locales)[number]

export function isLocale(value: string): value is Locale {
	return locales.some(locale => locale === value)
}

export function resolveLocale(args: { chinese: boolean; accept_language: string }) {
	const { chinese, accept_language } = args

	if (chinese) return 'zh'

	const preferences = accept_language.split(',').map(entry => {
		const [tag, ...parameters] = entry.trim().split(';')
		const quality = parameters.find(parameter => parameter.trim().startsWith('q='))

		return {
			language: tag.toLowerCase().split('-')[0],
			weight: quality ? Number(quality.trim().slice(2)) : 1
		}
	})

	for (const preference of preferences.sort((a, b) => b.weight - a.weight)) {
		const { language, weight } = preference

		if (weight > 0 && weight <= 1 && isLocale(language) && language !== 'zh') return language
	}

	return 'en'
}

export function localeHref(href: string, locale: string) {
	if (locale !== 'zh' || !href.startsWith('/') || href.startsWith('//')) return href

	const url = new URL(href, 'https://zxc.invalid')
	url.searchParams.set('__lang', 'zh')

	return url.pathname + url.search + url.hash
}
