import { getTranslations } from 'next-intl/server'

export default async function Performance() {
	const t = await getTranslations('home')

	return (
		<section className='home-section' aria-labelledby='atomic-performance'>
			<h2 id='atomic-performance'>{t('performanceTitle')}</h2>
			<p>{t('performanceDescription')}</p>
			<ul className='feature-list'>
				<li>{t('performanceInlining')}</li>
				<li>{t('performanceSpecialization')}</li>
				<li>{t('performanceOverhead')}</li>
			</ul>
			<p>{t('performancePath')}</p>
			<aside className='home-principle'>
				<strong>{t('performanceFutureLabel')}</strong>
				<br />
				{t('performanceFuture')}
			</aside>
		</section>
	)
}
