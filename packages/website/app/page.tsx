import Markdown from '../components/markdown'
import AgentPrompt from '../components/agent_prompt'
import { getLocale, getTranslations } from 'next-intl/server'
import { localeHref } from '../i18n/locale'
import Purpose from '../features/home/purpose'
import AgentValue from '../features/home/agent_value'
import WorkingWithZxc from '../features/home/working_with_zxc'
import Boundaries from '../features/home/boundaries'
import DataFlow from '../features/home/data_flow'

export default async function Home() {
	const locale = await getLocale()
	const t = await getTranslations({ locale: 'en', namespace: 'home' })

	return (
		<main id='content' className='home'>
			<div className='home-copy'>
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
				<Purpose />
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
				</section>
				<section className='home-section' aria-labelledby='how-it-works'>
					<h2 id='how-it-works'>{t('howItWorks')}</h2>
					<p>{t('howDescription')}</p>
					<p className='compile-path'>
						<code>.zx</code>
						<span aria-hidden='true'>→</span>
						<span>{t('analysis')}</span>
						<span aria-hidden='true'>→</span>
						<span>{t('generation')}</span>
						<span aria-hidden='true'>→</span>
						<code>Zig</code>
					</p>
					<p>{t('hostDescription')}</p>
					<Boundaries />
				</section>
				<AgentValue />
				<WorkingWithZxc />
				<section className='home-section' aria-labelledby='about'>
					<h2 id='about'>{t('aboutTitle')}</h2>
					<p>{t('aboutDescription')}</p>
					<p>{t('aboutInvitation')}</p>
					<p>
						<a href={localeHref('/docs', locale)}>{t('readDocs')} →</a>
						{' / '}
						<a href='https://github.com/MatrixAges/zxc'>{t('repository')} ↗</a>
						{' / '}
						<a href='/visuals/credits.txt'>{t('visualCredits')} →</a>
					</p>
				</section>
			</div>
			<DataFlow />
		</main>
	)
}
