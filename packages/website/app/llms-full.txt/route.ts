import { getLocale } from 'next-intl/server'
import { getFullDocs } from '../../content/docs'

export async function GET() {
	return new Response(await getFullDocs(await getLocale()), {
		headers: { 'Content-Type': 'text/plain; charset=utf-8' }
	})
}
