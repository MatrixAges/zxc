import { getTranslations } from 'next-intl/server'
import Markdown from '../../components/markdown'

export default async function WorkingWithZxc() {
	const t = await getTranslations({ locale: 'en', namespace: 'home' })

	return (
		<>
			<section className='home-section' aria-labelledby='come-back-to'>
				<h2 id='come-back-to'>{t('returnTitle')}</h2>
				<p>{t('returnDescription')}</p>
				<figure className='home-change'>
					<figcaption>{t('changeCaption')}</figcaption>
					<Markdown>
						{
							'```diff\n- return in.amount - in.discount;\n+ return in.amount >= in.minimum\n+   ? in.amount - in.discount\n+   : in.amount;\n```'
						}
					</Markdown>
					<p className='muted'>{t('changeNote')}</p>
				</figure>
				<p>{t('returnReview')}</p>
			</section>
			<section className='home-section' aria-labelledby='human-review'>
				<h2 id='human-review'>{t('judgementTitle')}</h2>
				<p>{t('judgementDescription')}</p>
				<p>{t('judgementReview')}</p>
			</section>
		</>
	)
}
