import type { RefObject } from 'react'
import type { InstancedMesh } from 'three'
import { useLayoutEffect, useMemo, useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import { Color, Object3D } from 'three'

export default function FlowParticles({
	progress_ref,
	motion_ref
}: {
	progress_ref: RefObject<Array<number>>
	motion_ref: RefObject<number>
}) {
	const mesh_ref = useRef<InstancedMesh>(null)
	const transform = useMemo(() => new Object3D(), [])

	useLayoutEffect(() => {
		const mesh = mesh_ref.current!
		const silver = new Color('#a292240')
		const gold = new Color('#dcc9a0')

		for (let index = 0; index < 240; index++) mesh.setColorAt(index, index % 5 === 0 ? gold : silver)
		mesh.instanceColor!.needsUpdate = true
	}, [])

	useFrame(() => {
		const mesh = mesh_ref.current!
		const progress = progress_ref.current[3]

		for (let index = 0; index < 240; index++) {
			const phase = (index / 240 + progress * 0.2 + motion_ref.current * 0.06) % 1
			const angle = index * 2.39996
			const radius = 0.15 + phase * 1.15

			transform.position.set(Math.cos(angle) * radius, (0.5 - phase) * 4.5, Math.sin(angle) * radius)
			transform.scale.setScalar(0.025 + (index % 4) * 0.009)
			transform.updateMatrix()
			mesh.setMatrixAt(index, transform.matrix)
		}

		mesh.instanceMatrix.needsUpdate = true
	})

	return (
		<instancedMesh ref={mesh_ref} args={[undefined, undefined, 240]} frustumCulled={false}>
			<icosahedronGeometry args={[1, 1]} />
			<meshStandardMaterial metalness={1} roughness={0.2} />
		</instancedMesh>
	)
}
