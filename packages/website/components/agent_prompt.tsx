import { getLocale, getTranslations } from 'next-intl/server'
import CopyPrompt from './copy_prompt'
import { localeHref } from '../i18n/locale'

export default async function AgentPrompt() {
	const locale = await getLocale()
	const t = await getTranslations('copy')

	return (
		<CopyPrompt
			labels={{ idle: t('idle'), success: t('success'), error: t('error') }}
			prompt={t('prompt', { url: '__DOCS_URL__' })}
			docs_href={localeHref('/llms-full.txt', locale)}
		/>
	)
}
