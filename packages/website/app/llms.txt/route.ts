import { getLocale, getTranslations } from 'next-intl/server'
import { getDocs } from '../../content/docs'
import { localeHref } from '../../i18n/locale'

export async function GET() {
	const locale = await getLocale()
	const t = await getTranslations('agent')
	const site = await getTranslations('site')
	const docs = await getDocs(locale)
	const index = docs
		.map(doc => `- [${doc.title}](${localeHref(`/docs/raw/${doc.id}`, locale)}): ${doc.group}`)
		.join('\n')

	return new Response(
		`# zxc\n\n> ${t('summary')}\n\n${t('intro')}\n\n## ${site('documentation')}\n\n${index}\n\n## ${t('complete')}\n\n- [${t('full')}](${localeHref('/llms-full.txt', locale)})\n- [${t('html')}](${localeHref('/docs', locale)})\n`,
		{ headers: { 'Content-Type': 'text/plain; charset=utf-8' } }
	)
}
