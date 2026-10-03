import { getTranslations } from 'next-intl/server'

export default async function AgentValue() {
	const t = await getTranslations('home')

	return (
		<section className='home-section' aria-labelledby='for-agents'>
			<h2 id='for-agents'>{t('agentTitle')}</h2>
			<p>{t('agentDescription')}</p>
			<p>{t('agentContext')}</p>
		</section>
	)
}
