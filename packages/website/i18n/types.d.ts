import type { Locale } from './locale'
import type messages from '../locales/en.json'
import 'next-intl'

declare module 'next-intl' {
	interface AppConfig {
		Locale: Locale
		Messages: typeof messages
	}
}
