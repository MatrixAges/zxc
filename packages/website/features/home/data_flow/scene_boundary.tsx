import type { ReactNode } from 'react'
import { Component } from 'react'

export default class SceneBoundary extends Component<{ children: ReactNode }, { failed: boolean }> {
	state = { failed: false }

	static getDerivedStateFromError() {
		return { failed: true }
	}

	render() {
		if (this.state.failed) return <img className='flow-fallback' src='/favicon.svg' alt='' />

		return this.props.children
	}
}
