import type { ReactNode } from 'react'
import SiteHeader from '../components/site_header'
import '../styles/site.css'

export const metadata = {
	title: { default: 'zxc — A language for agents', template: '%s — zxc' },
	description: 'Explicit architecture. Constrained logic. A programming language and compiler designed for agents.'
}

export default function RootLayout({ children }: { children: ReactNode }) {
	return (
		<html lang='en'>
			<body>
				<a className='skip-link' href='#content'>
					Skip to content
				</a>
				<SiteHeader />
				{children}
				<footer className='site-footer'>
					<span>zxc / made for agents</span>
					<a href='/llms.txt'>[ llms.txt ]</a>
					<a href='https://github.com/MatrixAges/zxc'>[ source ↗ ]</a>
				</footer>
			</body>
		</html>
	)
}
