import type { RefObject } from 'react'
import type { Group } from 'three'
import { useMemo, useRef } from 'react'
import { useFrame, useLoader } from '@react-three/fiber'
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js'

export default function FlowModel({
	name,
	motion_ref,
	progress_ref
}: {
	name: 'hopf_link' | 'parametric_sphere'
	motion_ref: RefObject<number>
	progress_ref: RefObject<Array<number>>
}) {
	const revision = name === 'hopf_link' ? '531c9d6bbeb5' : 'b2108ce566ac'
	const asset = useLoader(GLTFLoader, `/visuals/${name}.glb?v=${revision}`)
	const model = useMemo(() => asset.scene.clone(true), [asset])
	const root_ref = useRef<Group>(null)
	const linked = name === 'hopf_link'

	useFrame(() => {
		const root = root_ref.current

		if (!root) return

		const time = motion_ref.current
		const progress = progress_ref.current[linked ? 1 : 4]

		root.rotation.set(
			(linked ? 0.95 : 0.55) + Math.sin(time * 0.4) * 0.08,
			(linked ? 0.7 : 0.65) + Math.sin(time * 0.3) * 0.22 + (progress - 0.5) * 0.16,
			linked ? -0.35 : 0.1
		)
		root.scale.setScalar((linked ? 0.85 : 1) * (1 + Math.sin(time * 0.65) * 0.025))
	})

	return (
		<group ref={root_ref}>
			<primitive object={model} />
		</group>
	)
}
