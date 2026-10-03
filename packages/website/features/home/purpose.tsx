import { getTranslations } from 'next-intl/server'

export default async function Purpose() {
	const t = await getTranslations('home')

	return (
		<>
			<section className='home-section' aria-labelledby='why-zxc'>
				<h2 id='why-zxc'>{t('whyTitle')}</h2>
				<p>{t('whyDescription')}</p>
				<p>{t('whyApproach')}</p>
				<blockquote className='home-principle'>{t('principle')}</blockquote>
			</section>
			<section className='home-section' aria-labelledby='what-you-can-build'>
				<h2 id='what-you-can-build'>{t('useTitle')}</h2>
				<p>{t('useIntro')}</p>
			</section>
		</>
	)
}
