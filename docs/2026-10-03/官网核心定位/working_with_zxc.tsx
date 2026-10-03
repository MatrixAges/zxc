import { getTranslations } from 'next-intl/server'
import Markdown from '../../components/markdown'

export default async function WorkingWithZxc() {
	const t = await getTranslations('home')

	return (
		<>
			<section className='home-section' aria-labelledby='come-back-to'>
				<h2 id='come-back-to'>{t('returnTitle')}</h2>
				<p>{t('returnDescription')}</p>
				<figure className='home-change'>
					<figcaption>{t('changeCaption')}</figcaption>
					<Markdown>
						{
							'```diff\n- in.subtotal >= in.free_shipping_minimum => 0,\n+ discounted >= in.free_shipping_minimum => 0,\n```'
						}
					</Markdown>
					<p className='muted'>{t('changeNote')}</p>
				</figure>
				<p>{t('returnReview')}</p>
			</section>
			<section className='home-section' aria-labelledby='human-review'>
				<h2 id='human-review'>{t('judgementTitle')}</h2>
				<p>{t('judgementDescription')}</p>
				<dl className='home-facts'>
					{(['Compiler', 'Agent', 'You'] as const).map(role => (
						<div key={role}>
							<dt>{t(`judgement${role}Label`)}</dt>
							<dd>{t(`judgement${role}`)}</dd>
						</div>
					))}
				</dl>
			</section>
		</>
	)
}
