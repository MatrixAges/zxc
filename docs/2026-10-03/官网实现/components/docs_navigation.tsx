import { doc_groups, docs } from '../content/docs'

export default function DocsNavigation() {
	return (
		<nav className='docs-navigation' aria-label='Documentation contents'>
			<a className='docs-index' href='/docs'>
				Documentation
			</a>
			{doc_groups.map(group => (
				<div className='nav-group' key={group}>
					<p>{group}</p>
					<ul>
						{docs
							.filter(doc => doc.group === group)
							.map(doc => (
								<li key={doc.id}>
									<a href={`#${doc.id}`}>{doc.title}</a>
								</li>
							))}
					</ul>
				</div>
			))}
			<a href='/llms-full.txt'>[ plain text ↗ ]</a>
		</nav>
	)
}
