import { docs } from '../../../../content/docs'

export async function GET(_request: Request, { params }: { params: Promise<{ slug: string }> }) {
	const { slug } = await params
	const doc = docs.find(entry => entry.id === slug)

	if (!doc) return new Response('Document not found', { status: 404 })

	return new Response(`# ${doc.title}\n\n${doc.body}`, {
		headers: { 'Content-Type': 'text/markdown; charset=utf-8' }
	})
}
