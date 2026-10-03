import { getTranslations } from 'next-intl/server'
import Markdown from '../../components/markdown'
import checkout from '../../content/examples/checkout.rx?raw'
import quote from '../../content/examples/quote.zx?raw'

export default async function BusinessExample() {
	const t = await getTranslations('home')

	return (
		<section className='home-section' aria-labelledby='two-files'>
			<h2 id='two-files'>{t('twoFiles')}</h2>
			<div className='language-pair'>
				<div>
					<h3>{t('rx')}</h3>
					<p>{t('rxDescription')}</p>
					<Markdown>{'```xml\n' + checkout + '```'}</Markdown>
				</div>
				<div>
					<h3>{t('zx')}</h3>
					<p>{t('zxDescription')}</p>
					<Markdown>{'```typescript\n' + quote + '```'}</Markdown>
				</div>
			</div>
		</section>
	)
}
