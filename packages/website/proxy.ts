import type { NextRequest } from 'next/server'
import { NextResponse } from 'next/server'
import { resolveLocale } from './i18n/locale'

export function proxy(request: NextRequest) {
	const locale = resolveLocale({
		chinese: process.env.ZXC_WEBSITE_LOCALE === 'zh' || request.nextUrl.searchParams.get('__lang') === 'zh',
		accept_language: request.headers.get('accept-language') ?? ''
	})
	const request_headers = new Headers(request.headers)
	request_headers.set('x-zxc-locale', locale)

	const response = NextResponse.next({ request: { headers: request_headers } })
	response.headers.set('Content-Language', locale)
	response.headers.set('Vary', 'Accept-Language')
	response.headers.set('Cache-Control', 'private, no-store')

	return response
}

export const config = { matcher: ['/((?!_next/|cdn-cgi/|fonts/|__debug).*)'] }
