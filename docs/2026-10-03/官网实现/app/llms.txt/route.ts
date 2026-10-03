import { docs } from '../../content/docs'

export function GET() {
	const index = docs.map(doc => `- [${doc.title}](/docs/raw/${doc.id}): ${doc.group}`).join('\n')

	return new Response(
		`# zxc\n\n> A language and compiler for agents. Experimental.\n\nRead capabilities before generating code. RX orchestration and ZX computation have different implementation boundaries. Links are relative to this origin.\n\n## Documentation\n\n${index}\n\n## Complete reference\n\n- [Full documentation](/llms-full.txt)\n- [HTML documentation](/docs)\n`,
		{ headers: { 'Content-Type': 'text/plain; charset=utf-8' } }
	)
}
