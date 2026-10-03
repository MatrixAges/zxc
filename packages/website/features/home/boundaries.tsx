import { getTranslations } from 'next-intl/server'

export default async function Boundaries() {
	const t = await getTranslations('home')

	return (
		<div className='capability-table'>
			<table>
				<caption>{t('boundaryCaption')}</caption>
				<thead>
					<tr>
						<th scope='col'>{t('boundaryPart')}</th>
						<th scope='col'>{t('boundaryResponsibility')}</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope='row'>.zx</th>
						<td>{t('boundaryZx')}</td>
					</tr>
					<tr>
						<th scope='row'>.rx</th>
						<td>{t('boundaryRx')}</td>
					</tr>
					<tr>
						<th scope='row'>{t('boundaryHost')}</th>
						<td>{t('boundaryHostDetail')}</td>
					</tr>
					<tr>
						<th scope='row'>{t('boundaryYou')}</th>
						<td>{t('boundaryYouDetail')}</td>
					</tr>
				</tbody>
			</table>
		</div>
	)
}
