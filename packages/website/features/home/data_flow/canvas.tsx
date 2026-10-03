import type { RefObject } from 'react'
import type { StagePlacement } from './stages'
import { Canvas } from '@react-three/fiber'
import { WebGPURenderer } from 'three/webgpu'
import FlowScene from './scene'

export type FlowProps = {
	rail_ref: RefObject<HTMLDivElement | null>
	placements: Array<StagePlacement>
	reduced_motion: boolean
}

export default function FlowCanvas(props: FlowProps) {
	return (
		<Canvas
			orthographic
			camera={{ position: [0, 0, 20], zoom: 85, near: 0.1, far: 100 }}
			dpr={[1, 2]}
			frameloop='demand'
			fallback={<img className='flow-fallback' src='/favicon.svg' alt='' />}
			gl={async defaults => {
				const renderer = new WebGPURenderer({
					canvas: defaults.canvas as HTMLCanvasElement,
					antialias: true,
					alpha: true
				})

				await renderer.init()
				return renderer
			}}
		>
			<FlowScene {...props} />
		</Canvas>
	)
}
