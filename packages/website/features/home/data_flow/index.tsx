'use client'

import { lazy, Suspense, useEffect, useRef, useState } from 'react'
import SceneBoundary from './scene_boundary'
import stages from './stages'
import usePlacements from './use_placements'

const FlowCanvas = lazy(() => import('./canvas'))

export default function DataFlow() {
	const rail_ref = useRef<HTMLDivElement>(null)
	const [active, setActive] = useState(false)
	const [reduced_motion, setReducedMotion] = useState(true)
	const placements = usePlacements(rail_ref)
	const last = placements.at(-1)

	useEffect(() => {
		const desktop = window.matchMedia('(min-width: 961px)')
		const motion = window.matchMedia('(prefers-reduced-motion: reduce)')

		function updatePreferences() {
			setActive(desktop.matches)
			setReducedMotion(motion.matches)
		}

		updatePreferences()
		desktop.addEventListener('change', updatePreferences)
		motion.addEventListener('change', updatePreferences)

		return () => {
			desktop.removeEventListener('change', updatePreferences)
			motion.removeEventListener('change', updatePreferences)
		}
	}, [])

	return (
		<aside
			ref={rail_ref}
			className='data-flow'
			aria-label='From source to output'
			style={{ minHeight: last ? last.center + last.height / 2 + 32 : undefined }}
		>
			<div className='flow-viewport' aria-hidden='true'>
				<div className='flow-canvas'>
					{active && placements.length > 0 && (
						<SceneBoundary>
							<Suspense fallback={null}>
								<FlowCanvas
									rail_ref={rail_ref}
									placements={placements}
									reduced_motion={reduced_motion}
								/>
							</Suspense>
						</SceneBoundary>
					)}
				</div>
			</div>
			<ol className='flow-stages'>
				{stages.map((stage, index) => (
					<li
						key={stage.title}
						className={`flow-stage flow-stage-${stage.side}`}
						style={{
							top: placements[index]
								? placements[index].center +
									('before' in stage
										? -placements[index].height / 2 - 26
										: placements[index].height / 2 - 4)
								: undefined
						}}
					>
						<div className='flow-caption'>
							<span>{stage.title}</span>
						</div>
					</li>
				))}
			</ol>
		</aside>
	)
}
