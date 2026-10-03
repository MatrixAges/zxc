import type { Locale } from '../i18n/locale'
import { localeHref } from '../i18n/locale'
import loadMessages from '../i18n/messages'

const entries = [
	{ id: 'overview', file: 'overview', group: 'start' },
	{ id: 'build-with-agents', file: 'agents', group: 'start' },
	{ id: 'getting-started', file: 'getting_started', group: 'guides' },
	{ id: 'compose-modules', file: 'modules', group: 'guides' },
	{ id: 'write-logic', file: 'zx', group: 'guides' },
	{ id: 'keep-dependencies-acyclic', file: 'dependencies', group: 'guides' },
	{ id: 'validate-and-deliver', file: 'validation', group: 'guides' },
	{ id: 'language-reference', file: 'reference', group: 'reference' },
	{ id: 'capabilities', file: 'limits', group: 'reference' }
] as const

const sources = import.meta.glob<string>('./docs/*/*.md', { query: '?raw', import: 'default' })

export async function getDocs(locale: Locale) {
	const messages = await loadMessages(locale)

	return entries.map(entry => ({ ...entry, title: messages.docs[entry.id], group: messages.groups[entry.group] }))
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
		entries.map(async entry => {
			const doc = await getDocument({ locale, slug: entry.id })

			return `## ${doc!.title}\n\n${doc!.body}`
		})
	)

	return `# ${messages.agent.title}\n\n${sections.join('\n\n')}`
}
