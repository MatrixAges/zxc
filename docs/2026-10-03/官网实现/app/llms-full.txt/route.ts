import { getFullDocs } from '../../content/docs'

export function GET() {
	return new Response(getFullDocs(), { headers: { 'Content-Type': 'text/plain; charset=utf-8' } })
}
