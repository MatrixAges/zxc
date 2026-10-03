export default function SiteHeader() {
	return (
		<header className='site-header'>
			<a className='wordmark' href='/' aria-label='zxc home'>
				zxc<span aria-hidden='true'>_</span>
			</a>
			<span className='header-note'>a language for agents</span>
			<nav aria-label='Main navigation'>
				<a href='/docs'>[ docs ]</a>
				<a href='/llms-full.txt'>[ for agents ]</a>
				<a href='https://github.com/MatrixAges/zxc'>[ github ↗ ]</a>
			</nav>
		</header>
	)
}
