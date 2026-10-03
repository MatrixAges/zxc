import { useEffect, useMemo } from 'react'
import { useLoader } from '@react-three/fiber'
import { EquirectangularReflectionMapping } from 'three'
import { HDRLoader } from 'three/addons/loaders/HDRLoader.js'

export default function StudioEnvironment() {
	const source = useLoader(HDRLoader, '/visuals/studio_small_03_1k.hdr')
	const environment = useMemo(() => {
		const texture = source.clone()

		texture.mapping = EquirectangularReflectionMapping
		texture.needsUpdate = true
		return texture
	}, [source])

	useEffect(() => () => environment.dispose(), [environment])

	return <primitive object={environment} attach='environment' />
}
