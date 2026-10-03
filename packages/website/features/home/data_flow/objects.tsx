import type { RefObject } from 'react'
import { useEffect, useMemo } from 'react'
import { BoxGeometry, EdgesGeometry } from 'three'
import SourceObject from './source_object'
import FlowParticles from './particles'
import FlowModel from './model'

export const graph_nodes = [
	[-1.35, 0.45],
	[-0.68, -0.1],
	[0, -0.9],
	[0.68, 0.1],
	[1.35, -0.4]
]

export default function FlowObject({
	index,
	progress_ref,
	motion_ref
}: {
	index: number
	progress_ref: RefObject<Array<number>>
	motion_ref: RefObject<number>
}) {
	const edges = useMemo(() => {
		const box = new BoxGeometry(3.4, 2.35, 0.18)
		const geometry = new EdgesGeometry(box)

		box.dispose()
		return geometry
	}, [])

	useEffect(() => () => edges.dispose(), [edges])

	if (index === 4) return <FlowModel name='parametric_sphere' progress_ref={progress_ref} motion_ref={motion_ref} />

	if (index === 0) return <SourceObject index={index} progress_ref={progress_ref} motion_ref={motion_ref} />

	if (index === 1)
		return (
			<group>
				<lineSegments geometry={edges}>
					<lineBasicMaterial color='#a59677' />
				</lineSegments>
				<FlowModel name='hopf_link' progress_ref={progress_ref} motion_ref={motion_ref} />
			</group>
		)

	if (index === 2)
		return (
			<group>
				{graph_nodes.map(([x, y], item) => (
					<group key={item} position={[x, y, 0]}>
						{[0.06, 0.16, 0.24].map(radius => (
							<mesh key={radius}>
								<torusGeometry args={[radius, 0.004, 4, 48]} />
								<meshBasicMaterial color='#b4a383' />
							</mesh>
						))}
					</group>
				))}
			</group>
		)

	return <FlowParticles progress_ref={progress_ref} motion_ref={motion_ref} />
}
