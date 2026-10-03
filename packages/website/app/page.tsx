import Markdown from '../components/markdown'
import AgentPrompt from '../components/agent_prompt'
import { getDocs } from '../content/docs'
import { getLocale, getTranslations } from 'next-intl/server'
import { localeHref } from '../i18n/locale'

export default async function Home() {
	const locale = await getLocale()
	const t = await getTranslations('home')
	const docs = await getDocs(locale)

	return (
		<main id='content' className='home'>
			<div className='home-intro'>
				<p className='eyebrow'>zxc / {t('experimental')} / 0.0.1</p>
				<h1>{t('title')}</h1>
				<p>{t('tagline')}</p>
				<p>{t('description')}</p>
				<div className='action-links'>
					<AgentPrompt />
					<a href={localeHref('/docs', locale)}>[ {t('readDocs')} → ]</a>
				</div>
				<p className='muted'>
					{t('plainText')}: <a href={localeHref('/llms.txt', locale)}>{t('index')}</a> /{' '}
					<a href={localeHref('/llms-full.txt', locale)}>{t('fullReference')}</a>
				</p>
			</div>
			<section className='home-section' aria-labelledby='two-files'>
				<h2 id='two-files'>{t('twoFiles')}</h2>
				<div className='language-pair'>
					<div>
						<h3>{t('rx')}</h3>
						<p>{t('rxDescription')}</p>
						<Markdown>
							{
								'```xml\n<Module>\n  <Call fn="quote" in="$in" out="ctx.quote" />\n\n  <Return value="ctx.quote" />\n</Module>\n```'
							}
						</Markdown>
					</div>
					<div>
						<h3>{t('zx')}</h3>
						<p>{t('zxDescription')}</p>
						<Markdown>
							{
								'```typescript\nexport type Input = { amount: u64; };\nexport type Output = { amount: u64; };\n\nexport default function (in: Input): Output {\n  return { amount: in.amount };\n}\n```'
							}
						</Markdown>
					</div>
				</div>
				<p className='muted'>{t('runtimeNote')}</p>
			</section>
			<section className='home-section' aria-labelledby='contract'>
				<h2 id='contract'>{t('contract')}</h2>
				<dl className='contract-list'>
					<div>
						<dt>{t('identity')}</dt>
						<dd>{t('identityDescription')}</dd>
					</div>
					<div>
						<dt>{t('dependencies')}</dt>
						<dd>{t('dependenciesDescription')}</dd>
					</div>
					<div>
						<dt>{t('data')}</dt>
						<dd>{t('dataDescription')}</dd>
					</div>
					<div>
						<dt>{t('verification')}</dt>
						<dd>{t('verificationDescription')}</dd>
					</div>
				</dl>
			</section>
			<section className='home-section' aria-labelledby='read-next'>
				<h2 id='read-next'>{t('readNext')}</h2>
				<ol className='reading-list'>
					{docs
						.filter(doc => doc.id !== 'overview')
						.map(doc => (
							<li key={doc.id}>
								<a href={localeHref(`/docs/${doc.id}`, locale)}>
									{doc.title}
									<span aria-hidden='true'>↗</span>
								</a>
							</li>
						))}
				</ol>
			</section>
			<section className='home-section' aria-labelledby='current-state'>
				<h2 id='current-state'>{t('boundaries')}</h2>
				<p>{t('boundariesDescription')}</p>
				<a href={localeHref('/docs/capabilities', locale)}>{t('capabilities')} →</a>
			</section>
		</main>
	)
}
