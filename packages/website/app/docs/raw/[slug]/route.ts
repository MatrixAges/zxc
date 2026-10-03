import { getLocale, getTranslations } from 'next-intl/server'
import { getDocument } from '../../../../content/docs'

export async function GET(_request: Request, { params }: { params: Promise<{ slug: string }> }) {
	const { slug } = await params
	const locale = await getLocale()
	const doc = await getDocument({ locale, slug })

	if (!doc) {
		const t = await getTranslations('agent')

		return new Response(t('notFound'), { status: 404 })
	}

	return new Response(`# ${doc.title}\n\n${doc.body}`, {
		headers: { 'Content-Type': 'text/markdown; charset=utf-8' }
	})
}
