import type { Group, Mesh } from 'three'
import type { FlowProps } from './canvas'
import { useEffect, useMemo, useRef } from 'react'
import { useFrame, useThree } from '@react-three/fiber'
import { MathUtils } from 'three'
import FlowObject from './objects'
import stages from './stages'
import StudioEnvironment from './environment'
import createConnections from './connections'
import FlowConnection from './connection'

export default function FlowScene({ rail_ref, placements, reduced_motion }: FlowProps) {
	const { size, camera, gl, invalidate } = useThree()
	const root_ref = useRef<Group>(null)
	const objects_ref = useRef<Array<Group | null>>([])
	const pulses_ref = useRef<Array<Mesh | null>>([])
	const progress_ref = useRef(stages.map(() => 0))
	const motion_ref = useRef(0)
	const pointer_ref = useRef({ x: 0, y: 0 })
	const tilt_ref = useRef({ x: 0, y: 0 })
	const zoom = Math.min(120, size.width / 3.85)
	const paths = useMemo(() => createConnections(placements, zoom), [placements, zoom])

	useEffect(() => {
		camera.zoom = zoom
		camera.updateProjectionMatrix()
		invalidate()
	}, [camera, zoom, invalidate])

	useEffect(() => {
		function refresh() {
			if (!document.hidden) invalidate()
		}

		const rail = rail_ref.current!

		function movePointer(event: PointerEvent) {
			if (event.pointerType !== 'mouse') return

			const bounds = rail.getBoundingClientRect()
			pointer_ref.current = {
				x: (event.clientX - bounds.left) / bounds.width - 0.5,
				y: event.clientY / window.innerHeight - 0.5
			}
			refresh()
		}

		function resetPointer() {
			pointer_ref.current = { x: 0, y: 0 }
			refresh()
		}

		rail.addEventListener('pointermove', movePointer)
		rail.addEventListener('pointerleave', resetPointer)
		window.addEventListener('scroll', refresh, { passive: true })
		document.addEventListener('visibilitychange', refresh)

		return () => {
			rail.removeEventListener('pointermove', movePointer)
			rail.removeEventListener('pointerleave', resetPointer)
			window.removeEventListener('scroll', refresh)
			document.removeEventListener('visibilitychange', refresh)
		}
	}, [rail_ref, invalidate])

	useEffect(() => {
		invalidate()
	}, [reduced_motion, placements, invalidate])

	useFrame((_state, delta) => {
		if (!root_ref.current || !rail_ref.current || document.hidden) return

		const top = rail_ref.current.getBoundingClientRect().top - gl.domElement.getBoundingClientRect().top
		const still = reduced_motion

		if (!reduced_motion) motion_ref.current += Math.min(delta, 0.05)
		let unsettled = false

		for (const axis of ['x', 'y'] as const) {
			const target = still ? 0 : pointer_ref.current[axis]
			tilt_ref.current[axis] = MathUtils.damp(tilt_ref.current[axis], target, 9, Math.min(delta || 1 / 60, 0.05))
			unsettled ||= Math.abs(target - tilt_ref.current[axis]) > 0.001
		}

		root_ref.current.position.y = (size.height / 2 - top) / zoom

		objects_ref.current.forEach((object, index) => {
			if (!object) return

			const center = top + placements[index].center
			const target = reduced_motion
				? 1
				: MathUtils.clamp((size.height * 1.15 - center) / (size.height * 0.85), 0, 1)
			const progress = still
				? target
				: MathUtils.damp(progress_ref.current[index], target, 9, Math.min(delta || 1 / 60, 0.05))

			progress_ref.current[index] = progress
			unsettled ||= Math.abs(target - progress) > 0.001
			object.position.set(0, -placements[index].center / zoom, 0)
			object.scale.setScalar(index === 0 || index === 4 ? 0.9 + progress * 0.1 : 1)
			object.rotation.y =
				index === 0 || index === 4
					? (progress - 0.5) * 0.7 +
						tilt_ref.current.x * 0.16 +
						motion_ref.current * 0.18 +
						Math.sin(motion_ref.current * 0.45 + index) * 0.12
					: 0
			object.rotation.x =
				index === 0 || index === 4 ? tilt_ref.current.y * 0.12 + Math.sin(motion_ref.current * 0.35) * 0.13 : 0
			if (index === 4) {
				object.rotation.y = tilt_ref.current.x * 0.12 + Math.sin(motion_ref.current * 0.3) * 0.08
				object.rotation.x = tilt_ref.current.y * 0.1
			}

			object.rotation.z = 0
			object.visible = center > -placements[index].height && center < size.height + placements[index].height
		})

		pulses_ref.current.forEach((pulse, index) => {
			if (!pulse) return

			const path = paths[index]
			const travel = MathUtils.clamp(
				(size.height * 0.7 - top - placements[path.from].center) /
					(placements[path.to].center - placements[path.from].center),
				0,
				1
			)

			pulse.position.copy(path.curve.getPoint(still ? 0.5 : (travel + motion_ref.current * 0.12) % 1))
			pulse.visible = true
		})

		if (unsettled || (!reduced_motion && top < size.height && top + rail_ref.current.clientHeight > 0)) invalidate()
	})

	return (
		<>
			<StudioEnvironment />
			<ambientLight intensity={0.12} />
			<directionalLight position={[3, 5, 6]} intensity={1.4} color='#fff2d6' />
			<directionalLight position={[-4, -2, 3]} intensity={0.5} color='#c3b69a' />
			<group ref={root_ref}>
				{stages.map((stage, index) => (
					<group
						key={stage.id}
						ref={node => {
							objects_ref.current[index] = node
						}}
					>
						<FlowObject index={index} progress_ref={progress_ref} motion_ref={motion_ref} />
					</group>
				))}
				{paths.map((path, index) => (
					<group key={index}>
						<FlowConnection curve={path.curve} />
						<mesh
							ref={node => {
								pulses_ref.current[index] = node
							}}
						>
							<sphereGeometry args={[0.025, 12, 12]} />
							<meshBasicMaterial color='#d4c29b' />
						</mesh>
					</group>
				))}
			</group>
		</>
	)
}
