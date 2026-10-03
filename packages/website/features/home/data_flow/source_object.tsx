import type { RefObject } from 'react'
import { useEffect, useMemo } from 'react'
import { useFrame, useLoader, useThree } from '@react-three/fiber'
import { Box3, Mesh, Vector3 } from 'three'
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js'
import { WebGPURenderer } from 'three/webgpu'
import createSourceMaterial from './source_material'

export default function SourceObject({
	index,
	progress_ref,
	motion_ref
}: {
	index: number
	progress_ref: RefObject<Array<number>>
	motion_ref: RefObject<number>
}) {
	const model_url =
		index === 4 ? '/visuals/output_sculpture.glb?v=7e0c54d19450' : '/visuals/source_sculpture.glb?v=c044f8f8e14a'
	const model = useLoader(GLTFLoader, model_url)
	const renderer = useThree(state => state.gl)
	const webgpu = renderer instanceof WebGPURenderer && 'isWebGPUBackend' in renderer.backend
	const surface = useMemo(() => createSourceMaterial(webgpu), [webgpu])
	const geometry = useMemo(() => {
		const mesh = model.scene.getObjectByProperty('isMesh', true)

		if (!(mesh instanceof Mesh)) throw new Error('Sculpture asset has no mesh')

		const result = mesh.geometry.clone()
		const size = new Box3().setFromObject(mesh).getSize(new Vector3())
		const scale = 3.1 / Math.max(size.x, size.y, size.z)

		result.center()
		result.scale(scale, scale, scale)

		if (index === 4) result.rotateX(Math.PI / 2)

		return result
	}, [model, index])

	useEffect(
		() => () => {
			geometry.dispose()
			surface.material.dispose()
		},
		[geometry, surface]
	)
	useFrame(() => {
		surface.progress.value = progress_ref.current[index]
		surface.time.value = motion_ref.current
	})

	return <mesh geometry={geometry} material={surface.material} rotation={[0.12, -0.2, index === 4 ? -0.24 : 0.1]} />
}
