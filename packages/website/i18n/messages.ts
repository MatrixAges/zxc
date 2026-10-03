import type { Locale } from './locale'

const loaders = {
	en: () => import('../locales/en.json'),
	zh: () => import('../locales/zh.json'),
	ja: () => import('../locales/ja.json'),
	ko: () => import('../locales/ko.json')
}

export default async function loadMessages(locale: Locale) {
	return (await loaders[locale]()).default
}
