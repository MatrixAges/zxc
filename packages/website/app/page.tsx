import AgentPrompt from '../components/agent_prompt'
import { getLocale, getTranslations } from 'next-intl/server'
import { localeHref } from '../i18n/locale'
import Purpose from '../features/home/purpose'
import BusinessExample from '../features/home/business_example'
import AgentValue from '../features/home/agent_value'
import WorkingWithZxc from '../features/home/working_with_zxc'
import Performance from '../features/home/performance'
import Boundaries from '../features/home/boundaries'
import DataFlow from '../features/home/data_flow'

export default async function Home() {
	const locale = await getLocale()
	const t = await getTranslations('home')

	return (
		<main id='content' className='home'>
			<div className='home-copy'>
				<div className='home-intro'>
					<p>~*~ ZXC by MatrixAges, created by XWD ~*~</p>
					<h1>{t('title')}</h1>
					<p>{t('tagline')}</p>
					<p>{t('description')}</p>
					<div className='action-links'>
						<AgentPrompt />
						<a href={localeHref('/docs', locale)} target='_self'>
							[ {t('readDocs')} → ]
						</a>
					</div>
					<p className='muted'>
						{t('plainText')}: <a href={localeHref('/llms.txt', locale)}>{t('index')}</a> /{' '}
						<a href={localeHref('/llms-full.txt', locale)}>{t('fullReference')}</a>
					</p>
				</div>
				<Purpose />
				<BusinessExample />
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
				<Performance />
				<section className='home-section' aria-labelledby='about'>
					<h2 id='about'>{t('aboutTitle')}</h2>
					<p>{t('aboutDescription')}</p>
					<p>
						<a href={localeHref('/docs', locale)} target='_self'>
							{t('readDocs')} →
						</a>
						{' / '}
						<a href='https://github.com/MatrixAges/zxc'>{t('repository')} ↗</a>
						{' / '}
						<a href='/visuals/credits.txt'>{t('visualCredits')} →</a>
					</p>
				</section>
			</div>
			<DataFlow
				label={t('flowLabel')}
				labels={[
					t('flowInput'),
					t('flowComposition'),
					t('flowDependencies'),
					t('flowData'),
					t('flowStructure')
				]}
			/>
		</main>
	)
}
