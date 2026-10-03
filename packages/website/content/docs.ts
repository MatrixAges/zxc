import type { Locale } from '../i18n/locale'
import { localeHref } from '../i18n/locale'
import loadMessages from '../i18n/messages'

const entries = [
	{ id: 'overview', file: 'overview', group: 'start' },
	{ id: 'build-with-agents', file: 'agents', group: 'start' },
	{ id: 'choose-integration', file: 'integration', group: 'guides' },
	{ id: 'getting-started', file: 'getting_started', group: 'guides' },
	{ id: 'compose-modules', file: 'modules', group: 'guides' },
	{ id: 'write-logic', file: 'zx', group: 'guides' },
	{ id: 'keep-dependencies-acyclic', file: 'dependencies', group: 'guides' },
	{ id: 'module-paths', file: 'paths', group: 'guides' },
	{ id: 'control-flow', file: 'control_flow', group: 'guides' },
	{ id: 'types-and-values', file: 'types', group: 'guides' },
	{ id: 'collections-and-ownership', file: 'collections', group: 'guides' },
	{ id: 'state-and-host', file: 'state', group: 'guides' },
	{ id: 'gateway-and-store', file: 'declarations', group: 'guides' },
	{ id: 'validate-and-deliver', file: 'validation', group: 'guides' },
	{ id: 'troubleshooting', file: 'troubleshooting', group: 'guides' },
	{ id: 'language-reference', file: 'reference', group: 'reference' },
	{ id: 'zx-reference', file: 'zx_reference', group: 'reference' },
	{ id: 'cli-reference', file: 'cli', group: 'reference' },
	{ id: 'host-integration', file: 'host', group: 'reference' },
	{ id: 'capabilities', file: 'limits', group: 'reference' }
] as const

const sources = import.meta.glob<string>('./docs/*/*.md', { query: '?raw', import: 'default' })

export async function getDocs(locale: Locale) {
	const messages = await loadMessages(locale)

	const titles: Record<string, string> = messages.docs

	return entries
		.filter(entry => Object.hasOwn(titles, entry.id))
		.map(entry => ({ ...entry, title: titles[entry.id], group: messages.groups[entry.group] }))
}

export async function getDocument(args: { locale: Locale; slug: string }) {
	const { locale, slug } = args
	const doc = (await getDocs(locale)).find(entry => entry.id === slug)

	if (!doc) return undefined

	const body = await sources[`./docs/${locale}/${doc.file}.md`]()

	return {
		...doc,
		body: body.replace(/\]\((\/[^)]+)\)/g, (_match, href: string) => `](${localeHref(href, locale)})`)
	}
}

export async function getFullDocs(locale: Locale) {
	const messages = await loadMessages(locale)
	const sections = await Promise.all(
		(await getDocs(locale)).map(async entry => {
			const doc = await getDocument({ locale, slug: entry.id })

			return `## ${doc!.title}\n\n${doc!.body}`
		})
	)

	return `# ${messages.agent.title}\n\n${sections.join('\n\n')}`
}
