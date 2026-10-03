import overview from './docs/overview.md?raw'
import agents from './docs/agents.md?raw'
import getting_started from './docs/getting_started.md?raw'
import modules from './docs/modules.md?raw'
import zx from './docs/zx.md?raw'
import dependencies from './docs/dependencies.md?raw'
import validation from './docs/validation.md?raw'
import reference from './docs/reference.md?raw'
import limits from './docs/limits.md?raw'

export const docs = [
	{ id: 'overview', title: 'Overview', group: 'Start here', body: overview },
	{ id: 'build-with-agents', title: 'Build with agents', group: 'Start here', body: agents },
	{ id: 'getting-started', title: 'Get started', group: 'Guides', body: getting_started },
	{ id: 'compose-modules', title: 'Compose RX modules', group: 'Guides', body: modules },
	{ id: 'write-logic', title: 'Write ZX logic', group: 'Guides', body: zx },
	{ id: 'keep-dependencies-acyclic', title: 'Keep dependencies acyclic', group: 'Guides', body: dependencies },
	{ id: 'validate-and-deliver', title: 'Validate and deliver', group: 'Guides', body: validation },
	{ id: 'language-reference', title: 'Language reference', group: 'Reference', body: reference },
	{ id: 'capabilities', title: 'Capabilities & limits', group: 'Reference', body: limits }
]

export const doc_groups = [...new Set(docs.map(doc => doc.group))]

export function getFullDocs() {
	return '# zxc — agent documentation\n\n' + docs.map(doc => `## ${doc.title}\n\n${doc.body}`).join('\n\n')
}
